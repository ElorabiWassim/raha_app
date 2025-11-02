import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/constants/app_text_style.dart';

// Message Model
class Message {
  final String name;
  final String profileImage;
  final String lastMessage;
  final String service;
  final String time;
  final bool isUnread;
  final bool isOnline;

  Message({
    required this.name,
    required this.profileImage,
    required this.lastMessage,
    required this.service,
    required this.time,
    this.isUnread = false,
    this.isOnline = false,
  });
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messages = _getMessages();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6F6E0), Color(0xFFFFFFFF), Color(0xFFF9FFF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageCard(context, messages[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7E6).withOpacity(0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: Text(
              'Messages',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading4.copyWith(color: AppColors.textDark),
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: AppColors.textDark,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context, Message message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: message.isUnread
              ? AppColors.primary.withOpacity(0.2)
              : const Color(0xFFE4E4E7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to chat screen
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Image with Online Status
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(message.profileImage),
                    ),
                    if (message.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Message Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            message.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: message.isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            message.time,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: message.isUnread
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: message.isUnread
                                  ? AppColors.primary
                                  : const Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message.lastMessage,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: message.isUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: message.isUnread
                              ? AppColors.textDark
                              : const Color(0xFF888888),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message.service,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
                // Unread Indicator
                if (message.isUnread)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Conversations Yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start booking a service to begin\nchatting with a provider.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Message> _getMessages() {
    return [
      Message(
        name: 'Karim B.',
        profileImage: 'https://i.pravatar.cc/150?img=12',
        lastMessage: 'I will be there in 15 minutes...',
        service: 'Cleaning',
        time: '10:45 AM',
        isUnread: true,
        isOnline: true,
      ),
      Message(
        name: 'Amina Z.',
        profileImage: 'https://i.pravatar.cc/150?img=47',
        lastMessage: 'Thank you for the great work!',
        service: 'Plumbing',
        time: 'Yesterday',
        isUnread: false,
        isOnline: false,
      ),
      Message(
        name: 'Yacine M.',
        profileImage: 'https://i.pravatar.cc/150?img=33',
        lastMessage: 'Can you come on Wednesday instead?',
        service: 'Gardening',
        time: 'Wed',
        isUnread: false,
        isOnline: false,
      ),
    ];
  }
}