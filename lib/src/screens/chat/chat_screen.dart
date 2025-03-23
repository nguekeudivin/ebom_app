import 'dart:async';
import 'dart:convert';

import 'package:ebom/src/components/chat/message_item.dart';
import 'package:ebom/src/components/form/input_text_area_field.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/screens/app_layout.dart';
import 'package:ebom/src/screens/chat/chats_list_screen.dart';
import 'package:ebom/src/screens/subscriptions/subscribe_modal.dart';
import 'package:ebom/src/services/app_service.dart';
import 'package:ebom/src/services/chat_service.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:ebom/src/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// The ChatScreen is open in two modes. The first one is on the start conversation mode and the other is open conversation.
// On the start conversation mode, the conversationId = 0. On the open conversation mode conversationId = 1.
// L'objectif au final c'est de pourvoir etre en mesure de charger les messages d'une conversation.
class ChatScreen extends StatefulWidget {
  final dynamic conversation;
  final int receiverId;
  const ChatScreen({
    required this.conversation,
    required this.receiverId,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool loading = true;
  int conversationId = 0;

  // We define a variable to store the selected message.
  int selectedMessageIndex = -1;

  ChatService chatService = ChatService();
  late Future<bool> conversation;

  List<dynamic> messages = [];

  late Timer _timer;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Is can chat.
    Provider.of<SubscriptionProvider>(
      context,
      listen: false,
    ).canChat(context).then((value) {
      if (value) {
        // Save the reference.
        Provider.of<SubscriptionProvider>(
          // ignore: use_build_context_synchronously
          context,
          listen: false,
        ).start('@chat');

        showModalBottomSheet(
          // ignore: use_build_context_synchronously
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          scrollControlDisabledMaxHeightRatio: 0.81,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: const SubscribeModal(),
              ),
            );
          },
        ).whenComplete(() {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => AppLayout(),
            ),
          );
          // ignore: use_build_context_synchronously
          Provider.of<AppLayoutNavigationProvider>(context, listen: false)
              .setActive(0);
        });
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      refreshMessages();
    });

    // Create a conversation.
    if (widget.conversation['id'] == null) {
      chatService
          .createConversation(widget.receiverId, 'entreprise')
          .then((conversation) {
        // Go back to chats screen to load all chat.
        // ignore: use_build_context_synchronously
        if (conversation is int) {
          Provider.of<AppLayoutNavigationProvider>(
            // ignore: use_build_context_synchronously
            context,
            listen: false,
          ).setActiveScreen('products_screen');
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const ChatsListScreen(),
            ),
          );
        } else {
          setState(() {
            conversationId = conversation['id'];
          });
        }
      }).catchError((error) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text(
                "Nous ne parvenons pas a demarrer la conversation. L'utilisateur a probablement desactiver le chat",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }).whenComplete(() {
        setState(() {
          loading = false;
        });
      });
    } else {
      conversationId = widget.conversation['id'];

      // Get messages
      chatService.getMessages(conversationId).then((items) {
        setState(() {
          loading = false;
          messages = items;
          _scrollToBottom();
        });
      }).catchError((error) {
        setState(() {
          loading = false;
        });
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(error),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      });
    }

    _scrollToBottom();
  }

  void deleteMessage(int messageIndex) {
    // If the message come the server then the id is different from zero.
    // Then we send a request to the server.
    if (messages[messageIndex]['id'] != 0) {
      chatService.deleteMessage(messages[messageIndex]['id']).then(
            (res) => {
              // Filter the message list.
              setState(() {
                messages = messages
                    .asMap()
                    .entries
                    .where((entry) => entry.key != messageIndex)
                    .map((entry) => entry.value)
                    .toList();
                // Set the selected message index to -1.
                selectedMessageIndex = -1;
              }),
            },
          );
    } else {
      // The id is equal to zero then we implement the local delete.
      // But with some issues. But it really depends on the implementation of the API.
      setState(() {
        messages = messages
            .asMap()
            .entries
            .where((entry) => entry.key != messageIndex)
            .map((entry) => entry.value)
            .toList();
        // Set the selected message index to -1.// Set the selected message index to -1.
        selectedMessageIndex = -1;
        selectedMessageIndex = -1;
      });
    }
  }

  void refreshMessages() {
    chatService.getMessages(conversationId).then((items) {
      setState(() {
        //  loading = false;
        messages = items;
        _scrollToBottom();
      });
    }).catchError((error) {
      setState(() {
        loading = false;
      });
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              // I a message is selected we show action.
              selectedMessageIndex != -1
                  ? Container(
                      color: AppColors.gray200,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedMessageIndex = -1;
                              }); // Navigate back to the previous page
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              deleteMessage(selectedMessageIndex);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      // Otherwise we display information about the current chat
                      color: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
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
                              shape: BoxShape
                                  .circle, // Ensures the border is circular
                              border: Border.all(
                                color: Colors.white, // Set your border color
                                width: 2, // Border width
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                50.0,
                              ), // Rounded corners
                              child: Image.network(
                                'https://admin.beigie-innov.com/storage/users/default.png',
                                //widget.chat.image,
                                width: 40.0, // Image size
                                height: 40.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${widget.conversation['nom']}',
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
                      loading
                          ? const CircularProgressIndicator()
                          : Column(
                              children: List.generate(messages.length, (index) {
                                dynamic message = messages[index];
                                return GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      selectedMessageIndex = index;
                                    });
                                  },
                                  child: Container(
                                    color: selectedMessageIndex == index
                                        ? AppColors.primaryLighter
                                        : null,
                                    child: MessageItem(
                                      message: message,
                                      previousMessageDate: index > 0
                                          ? messages[index - 1]['date']
                                          : '',
                                    ),
                                  ),
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
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: InputTextAreaField(
                      hintText: '',
                      controller: messageController,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                        if (!loading) {
                          chatService.writeMessage(
                            conversationId,
                            messageController.text,
                          );
                          setState(() {
                            messages.add(
                              json.decode(
                                jsonEncode(
                                  {
                                    'id': 0,
                                    'message': messageController.text,
                                    'fichier': '#',
                                    'reponse_a': -1,
                                    'vu_pa': '',
                                    'user_id': conversationId,
                                    'user_role': Provider.of<ConnexionProvider>(
                                      context,
                                      listen: false,
                                    ).connexion!.role,
                                    'date': DateTime.now().toIso8601String(),
                                  },
                                ),
                              ),
                            );
                            messageController.clear();
                          });
                          _scrollToBottom();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
