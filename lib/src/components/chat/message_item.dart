import 'package:ebom/src/components/products/product_in_chat.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/services/connexion_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageItem extends StatelessWidget {
  final dynamic message;

  const MessageItem({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    bool received(String userRole) {
      return userRole !=
          Provider.of<ConnexionProvider>(context).connexion!.role;
    }

    return Align(
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
              child: message['product'] != null ? const ProductInChat() : null,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: received(message['user_role'])
                    ? AppColors.primary
                    : AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message['message'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Row(
            //     mainAxisAlignment: received(message['user_role'])
            //         ? MainAxisAlignment.start
            //         : MainAxisAlignment.end,
            //     children: [
            //       Text(
            //         // DateFormat('HH:mm').format(message.time),
            //         DateFormat('HH:mm').format(DateTime.now()),
            //       ),
            //       const SizedBox(
            //         width: 8,
            //       ),
            //       const Icon(
            //         Icons.done_all,
            //         color: AppColors.primary,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
