import 'package:ebom/src/components/chat/message_item.dart';
import 'package:ebom/src/components/form/input_text_area_field.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/chart.dart';
import 'package:ebom/src/models/message.dart';
import 'package:ebom/src/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  const ChatScreen({required this.chat, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(
                      context,
                    ); // Navigate back to the previous page
                  },
                ),
                Container(
                  width: 50.0, // Slightly larger to include border
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Ensures the border is circular
                    border: Border.all(
                      color: AppColors.primary, // Set your border color
                      width: 3.0, // Border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(50.0), // Rounded corners
                    child: Image.asset(
                      widget.chat.image,
                      width: 40.0, // Image size
                      height: 40.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.chat.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    children:
                        List.generate(widget.chat.messages.length, (index) {
                      Message message = widget.chat.messages[index];
                      return MessageItem(
                        message: message,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: InputTextAreaField(
                hintText: '',
                controller: messageController,
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                backgroundColor: AppColors.primaryLighter,
                borderColor: AppColors.primaryLighter,
                maxLines: null,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary, // Background color
                shape: BoxShape
                    .circle, // Optional: to make the background circular
              ),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white, // Icon color
                onPressed: () {
                  // Implement your send message logic here
                  setState(() {
                    messages.add(
                      Message(
                        id: 0,
                        receiverId: 1,
                        time: DateTime.now(),
                        senderId: 0, // Assuming this user is the sender
                        content: messageController.text,
                      ),
                    );

                    messages.add(
                      Message(
                        id: 0,
                        receiverId: 0,
                        time: DateTime.now(),
                        senderId: 1, // Assuming this user is the sender
                        content: 'This is a reply to your message',
                      ),
                    );

                    messageController.clear();
                  });
                  _scrollToBottom();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
