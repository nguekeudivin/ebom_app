import 'package:ebom/src/components/header/header.dart';
import 'package:ebom/src/components/skeleton/snapshot_loader.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/chart.dart';
import 'package:ebom/src/screens/chat/chat_screen.dart';

import 'package:ebom/src/services/chat_service.dart';
import 'package:ebom/src/utils/helpers.dart';
import 'package:flutter/material.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  late Future<dynamic> conversations;
  ChatService chatService = ChatService();

  String lastMessage(Chat chat) {
    return chat.messages[chat.messages.length - 1].content;
  }

  DateTime lastMessageTime(Chat chat) {
    return chat.messages[chat.messages.length - 1].time;
  }

  @override
  void initState() {
    super.initState();
    conversations = chatService.getConversations();
  }

  @override
  Widget build(BuildContext context) {
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
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: InputSearch(),
                      // ),
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      FutureBuilder(
                        future: conversations,
                        builder: (context, snapshot) {
                          return SnapshotLoader(
                            snapshot: snapshot,
                            notFoundMessage: 'Aucune conversation disponible',
                            builder: () {
                              return Column(
                                children: List.generate(
                                  snapshot.data!.length,
                                  (index) {
                                    return ConversationItem(
                                      conversation: snapshot.data![index],
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
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

class ConversationItem extends StatefulWidget {
  final dynamic conversation;
  const ConversationItem({required this.conversation, super.key});

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  //late Future<List<dynamic>> messages;
  ChatService chatService = ChatService();
  dynamic lastMessage = {'message': ''};
  List<dynamic> unReadMessages = [];

  @override
  void initState() {
    super.initState();
    chatService.getLastMessage(widget.conversation['id']).then((message) {
      if (message != null) {
        setState(() {
          lastMessage = message;
        });
      }
    });

    chatService.getUnreadMessages(widget.conversation['id']).then((unReads) {
      setState(() {
        unReadMessages = unReads;
      });
    });
    // messages = chatService.getMessages(widget.conversation['id']);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                conversation: widget.conversation,
              ),
            ),
          ),
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
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
                    borderRadius: BorderRadius.circular(
                      50.0,
                    ), // Rounded corners
                    child: Image.network(
                      //  widget.conversation['image'],
                      'https://admin.beigie-innov.com/storage/users/default.png',
                      width: 40.0, // Image size
                      height: 40.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.conversation['nom'] ?? ''),
                    SizedBox(
                      width: width - 16 * 2 - 12 - 100,
                      child: Text(
                        truncate(
                          lastMessage['message'] ?? '',
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
                // Text(
                //   DateFormat('HH:mm').format(
                //     DateTime.now(),
                //   ),
                //   style: const TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey,
                //   ),
                // ),
                if (unReadMessages.isNotEmpty)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '${unReadMessages.length}',
                        style: const TextStyle(
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
  }
}
