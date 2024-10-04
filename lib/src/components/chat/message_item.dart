import 'package:ebom/src/components/products/product_in_chat.dart';
import 'package:ebom/src/config/app_colors.dart';
import 'package:ebom/src/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    bool received(int senderId) {
      return senderId != 0;
    }

    return Align(
      alignment: received(message.senderId)
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          crossAxisAlignment: received(message.senderId)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              child: message.produit != null ? const ProductInChat() : null,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: received(message.senderId)
                    ? AppColors.primary
                    : AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message.content,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: received(message.senderId)
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('HH:mm').format(message.time),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.done_all,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
