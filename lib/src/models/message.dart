import 'package:ebom/src/models/product.dart';

class Message {
  final int id;
  final String content;
  final int senderId;
  final int receiverId;
  final DateTime time;
  final Produit? produit;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.time,
    this.produit,
  });

  // Factory constructor to create a Chat object from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      time: json['time'],
    );
  }

  // Method to convert Chat object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'time': time,
    };
  }
}
