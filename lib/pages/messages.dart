import 'package:flutter/material.dart';

class Conversation extends StatelessWidget {
  const Conversation({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}

class ChatScreen extends StatelessWidget {
  //it would be stateful later when each one send a message we call setstate
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      //dummy data , we will use real data later
      {
        "text": "Hello, I will be there in about 15 minutes.",
        "isMe": false,
        "time": "10:30 AM",
      },
      {
        "text": "Great, thank you for the update!",
        "isMe": true,
        "time": "10:31 AM",
      },
      {"text": "See you soon.", "isMe": false, "time": "10:31 AM"},
      {
        "text":
            "Perfect. Just to confirm, you have all the necessary tools for the faucet replacement, right? No need for me to provide anything.",
        "isMe": true,
        "time": "10:32 AM",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/Wassimo.png'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Wassimo",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Plumber",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.more_vert, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            //for constructing the messages we will complete the business logic later
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return MessageBubble(
                  text: msg["text"]! as String,
                  isMe: msg["isMe"]! as bool,
                  time: msg["time"]! as String,
                );
              },
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isMe ? Colors.green : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isMe
                    ? const Radius.circular(18)
                    : const Radius.circular(4),
                bottomRight: isMe
                    ? const Radius.circular(4)
                    : const Radius.circular(18),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(
              time,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                filled: true,
                fillColor: const Color(0xFFF4F4F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.green,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
