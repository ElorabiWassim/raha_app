const supabase = require('../config/supabase.js');

// 1. Get conversations for ANY user (homeowner OR service provider)
exports.getUserConversations = async (req, res) => {
    try {

        req.user = {
            user_id: '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7', // Mock UUID
            role: 'homeowner',
            email: 'test@example.com'
        };

        const userId = req.user.user_id; // Changed from homeownerId
        const userRole = req.user.role; // 'homeowner' or 'service_provider'

        console.log(`Getting conversations for ${userRole}: ${userId}`);

        // SAME LOGIC - works for both
        const { data, error } = await supabase
            .from('conversations')
            .select(`
        conversation_id,
        user1_id,
        user2_id,
        created_at,
        last_message_at,
        user1:users!conversations_user1_id_fkey(
          user_id,
          full_name,
          role
        ),
        user2:users!conversations_user2_id_fkey(
          user_id,
          full_name,
          role
        ),
        last_message:messages!messages_conversation_id_fkey(
          message_id,
          message_text,
          attachment_url,
          sender_id,
          created_at
        ).order(created_at.desc).limit(1)
      `)
            .or(`user1_id.eq.${userId},user2_id.eq.${userId}`)
            .order('last_message_at', { ascending: false });

        if (error) throw error;

        // Format response
        const formattedConversations = data.map(conv => {
            const isUser1 = conv.user1_id === userId;
            const otherUser = isUser1 ? conv.user2 : conv.user1;
            const lastMessage = conv.last_message?.[0] || null;

            return {
                conversation_id: conv.conversation_id,
                other_user: {
                    user_id: otherUser.user_id,
                    full_name: otherUser.full_name,
                    role: otherUser.role
                },
                last_message: lastMessage ? {
                    message_id: lastMessage.message_id,
                    text: lastMessage.message_text,
                    attachment_url: lastMessage.attachment_url,
                    sender_id: lastMessage.sender_id,
                    sent_at: lastMessage.created_at,
                    is_mine: lastMessage.sender_id === userId
                } : null,
                created_at: conv.created_at,
                updated_at: conv.last_message_at
            };
        });

        res.json({
            success: true,
            user_role: userRole, // Include role in response
            data: formattedConversations
        });

    } catch (error) {
        console.error('Get conversations error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
};

// 2. Get messages for a specific conversation
exports.getConversationMessages = async (req, res) => {
    try {

        req.user = {
            user_id: '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7', // Mock UUID
            role: 'homeowner',
            email: 'test@example.com'
        };
        const { conversationId } = req.params;
        const userId = req.user.user_id;

        // Verify user has access to this conversation
        const { data: conversation, error: convError } = await supabase
            .from('conversations')
            .select('conversation_id')
            .eq('conversation_id', conversationId)
            .or(`user1_id.eq.${userId},user2_id.eq.${userId}`)
            .single();

        if (convError || !conversation) {
            return res.status(403).json({
                success: false,
                error: 'Access denied or conversation not found'
            });
        }

        // Get messages with sender info - FIXED FOREIGN KEY
        const { data: messages, error } = await supabase
            .from('messages')
            .select(`
        message_id,
        conversation_id,
        sender_id,
        message_text,
        attachment_url,
        created_at,
        sender:users!messages_sender_id_fkey(
          user_id,
          full_name,
          role
        )
      `)
            .eq('conversation_id', conversationId)
            .order('created_at', { ascending: true });

        if (error) throw error;

        // Format messages
        const formattedMessages = messages.map(msg => ({
            message_id: msg.message_id,
            conversation_id: msg.conversation_id,
            text: msg.message_text,
            attachment_url: msg.attachment_url,
            sent_at: msg.created_at,
            sender: {
                user_id: msg.sender.user_id,
                full_name: msg.sender.full_name,
                role: msg.sender.role,
                is_me: msg.sender.user_id === userId
            }
        }));

        res.json({
            success: true,
            data: {
                conversation_id: conversationId,
                messages: formattedMessages,
                total: formattedMessages.length
            }
        });

    } catch (error) {
        console.error('Get messages error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
};

// 3. Send a new message
exports.sendMessage = async (req, res) => {
    try {



        req.user = {
            user_id: '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7', // Mock UUID
            role: 'homeowner',
            email: 'test@example.com'
        };
        const { conversationId } = req.params;
        const { message_text, attachment_url } = req.body;
        const senderId = req.user.user_id;

        // Validation
        if (!message_text?.trim() && !attachment_url) {
            return res.status(400).json({
                success: false,
                error: 'Message text or attachment is required'
            });
        }

        // Verify user can send to this conversation
        const { data: conversation, error: convError } = await supabase
            .from('conversations')
            .select('conversation_id, user1_id, user2_id')
            .eq('conversation_id', conversationId)
            .or(`user1_id.eq.${senderId},user2_id.eq.${senderId}`)
            .single();

        if (convError || !conversation) {
            return res.status(403).json({
                success: false,
                error: 'Cannot send message to this conversation'
            });
        }

        // Insert message - FIXED FOREIGN KEY
        const { data: message, error } = await supabase
            .from('messages')
            .insert({
                conversation_id: conversationId,
                sender_id: senderId,
                message_text: message_text?.trim() || null,
                attachment_url: attachment_url || null
            })
            .select(`
        message_id,
        conversation_id,
        sender_id,
        message_text,
        attachment_url,
        created_at,
        sender:users!messages_sender_id_fkey(
          user_id,
          full_name
        )
      `)
            .single();

        if (error) throw error;

        // Update conversation's last_message_at
        await supabase
            .from('conversations')
            .update({ last_message_at: new Date().toISOString() })
            .eq('conversation_id', conversationId);

        res.json({
            success: true,
            message: 'Message sent successfully',
            data: {
                ...message,
                sender: {
                    ...message.sender,
                    is_me: true
                }
            }
        });

    } catch (error) {
        console.error('Send message error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
};

// 4. Start a new conversation
exports.startConversation = async (req, res) => {
    try {


        req.user = {
            user_id: '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7', // Mock UUID
            role: 'homeowner',
            email: 'test@example.com'
        };
        const { other_user_id } = req.body;
        const userId = req.user.user_id;

        // Validation
        if (!other_user_id) {
            return res.status(400).json({
                success: false,
                error: 'other_user_id is required'
            });
        }

        if (userId === other_user_id) {
            return res.status(400).json({
                success: false,
                error: 'Cannot start conversation with yourself'
            });
        }

        // Check if other user exists
        const { data: otherUser, error: userError } = await supabase
            .from('users')
            .select('user_id, role, status')
            .eq('user_id', other_user_id)
            .single();

        if (userError || !otherUser) {
            return res.status(404).json({
                success: false,
                error: 'User not found'
            });
        }

        if (otherUser.status !== 'active') {
            return res.status(400).json({
                success: false,
                error: 'User is not active'
            });
        }

        // Check if conversation already exists
        const { data: conv1 } = await supabase
            .from('conversations')
            .select('conversation_id')
            .eq('user1_id', userId)
            .eq('user2_id', other_user_id);

        const { data: conv2 } = await supabase
            .from('conversations')
            .select('conversation_id')
            .eq('user1_id', other_user_id)
            .eq('user2_id', userId);

        let existingConversations = [];
        if (conv1) existingConversations = existingConversations.concat(conv1);
        if (conv2) existingConversations = existingConversations.concat(conv2);

        if (existingConversations.length > 0) {
            // Get full conversation details
            const { data: existingConv } = await supabase
                .from('conversations')
                .select(`
                    conversation_id,
                    user1_id,
                    user2_id,
                    created_at,
                    last_message_at,
                    user1:users!conversations_user1_id_fkey(
                        user_id,
                        full_name
                    ),
                    user2:users!conversations_user2_id_fkey(
                        user_id,
                        full_name
                    )
                `)
                .eq('conversation_id', existingConversations[0].conversation_id)
                .single();

            return res.status(400).json({
                success: false,
                message: 'Conversation already exists',
                data: existingConv
            });
        }


        // Create new conversation
        const { data: conversation, error } = await supabase
            .from('conversations')
            .insert({
                user1_id: userId,
                user2_id: other_user_id,
                last_message_at: new Date().toISOString()
            })
            .select(`
                conversation_id,
                user1_id,
                user2_id,
                created_at,
                last_message_at,
                user1:users!conversations_user1_id_fkey(
                user_id,
                full_name
                ),
                user2:users!conversations_user2_id_fkey(
                user_id,
                full_name
                )
            `)
            .single();

        if (error) throw error;

        res.json({
            success: true,
            message: 'Conversation started successfully',
            data: conversation
        });

    } catch (error) {
        console.error('Start conversation error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
};

// 5. Get conversation participants
exports.getConversationParticipants = async (req, res) => {
    try {
        req.user = {
            user_id: '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7', // Mock UUID
            role: 'homeowner',
            email: 'test@example.com'
        };
        const { conversationId } = req.params;
        const userId = req.user.user_id;

        // Get conversation with both users
        const { data: conversation, error } = await supabase
            .from('conversations')
            .select(`
        conversation_id,
        user1:users!conversations_user1_id_fkey(
          user_id,
          full_name,
          role
        ),
        user2:users!conversations_user2_id_fkey(
          user_id,
          full_name,
          role
        )
      `)
            .eq('conversation_id', conversationId)
            .or(`user1_id.eq.${userId},user2_id.eq.${userId}`)
            .single();

        if (error || !conversation) {
            return res.status(404).json({
                success: false,
                error: 'Conversation not found or access denied'
            });
        }

        // Determine which user is "me" and which is "other"
        const isUser1 = conversation.user1.user_id === userId;
        const me = isUser1 ? conversation.user1 : conversation.user2;
        const other = isUser1 ? conversation.user2 : conversation.user1;

        res.json({
            success: true,
            data: {
                conversation_id: conversationId,
                me: {
                    ...me,
                    is_me: true
                },
                other_user: other
            }
        });

    } catch (error) {
        console.error('Get participants error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
};