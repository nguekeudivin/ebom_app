import 'package:ebom/src/models/message.dart';

class Chat {
  String name;
  String image;
  List<Message> messages;

  Chat({
    required this.name,
    required this.image,
    required this.messages,
  });
}
