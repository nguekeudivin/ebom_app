import 'package:ebom/src/components/products/product_in_chat.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessageItem extends StatelessWidget {
  final dynamic message;
  final String previousMessageDate;

  const MessageItem({
    required this.previousMessageDate,
    required this.message,
    super.key,
  });

  String getHumanFormatDate(String dateString) {
    String yesterday = DateFormat('d-M-y')
        .format(DateTime.now().subtract(const Duration(days: 1)));
    String today = DateFormat('d-M-y').format(DateTime.now());

    if (dateString == yesterday) {
      return 'Hier';
    }

    if (dateString == today) {
      return "Aujourd'hui";
    }

    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    bool received(String userRole) {
      return userRole !=
          Provider.of<ConnexionProvider>(context).connexion!.role;
    }

    String previousMessageDay = '';
    String currentMessageDay =
        DateFormat('d-M-y').format(DateTime.parse(message['date']));

    if (previousMessageDate != '') {
      previousMessageDay =
          DateFormat('d-M-y').format(DateTime.parse(previousMessageDate));
    }

    return Column(
      children: [
        previousMessageDay != currentMessageDay
            ? Text(getHumanFormatDate(currentMessageDay))
            : const Text(''),
        Align(
          alignment: received(message['user_role'])
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              crossAxisAlignment: received(message['user_role'])
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  child:
                      message['product'] != null ? const ProductInChat() : null,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: received(message['user_role'])
                        ? AppColors.primary
                        : AppColors.darkBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message['message'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: received(message['user_role'])
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      Text(
                        // DateFormat('HH:mm').format(message.time),
                        DateFormat('HH:mm').format(
                          DateTime.parse(message['date']),
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                      // const SizedBox(
                      //   width: 8,
                      // ),
                      // const Icon(
                      //   Icons.done_all,
                      //   color: AppColors.primary,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
