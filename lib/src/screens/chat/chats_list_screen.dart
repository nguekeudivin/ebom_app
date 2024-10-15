import 'package:ebom/src/components/form/input_search.dart';
import 'package:ebom/src/components/header/header.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/chart.dart';

import 'package:ebom/src/screens/chat/chat_screen.dart';
import 'package:ebom/src/services/chat_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  String lastMessage(Chat chat) {
    return chat.messages[chat.messages.length - 1].content;
  }

  DateTime lastMessageTime(Chat chat) {
    return chat.messages[chat.messages.length - 1].time;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(title: 'Chats'),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: InputSearch(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: List.generate(
                          chats.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        receiverId: 0,
                                        chat: chats[index],
                                      ),
                                    ),
                                  ),
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width:
                                              50.0, // Slightly larger to include border
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape
                                                .circle, // Ensures the border is circular
                                            border: Border.all(
                                              color: AppColors
                                                  .primary, // Set your border color
                                              width: 3.0, // Border width
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              50.0,
                                            ), // Rounded corners
                                            child: Image.asset(
                                              chats[index].image,
                                              width: 40.0, // Image size
                                              height: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(chats[index].name),
                                            SizedBox(
                                              width: width - 16 * 2 - 12 - 100,
                                              child: Text(
                                                truncate(
                                                  lastMessage(chats[index]),
                                                  40,
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          DateFormat('HH:mm').format(
                                            lastMessageTime(chats[index]),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '2',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
