import 'package:ebom/src/models/chart.dart';
import 'package:ebom/src/models/message.dart';
import 'package:ebom/src/resources/app_assets.dart';

List<Message> messages = [
  Message(
    id: 1,
    content:
        "Hey, I heard you're selling a product. Can you tell me more about it?",
    senderId: 0,
    receiverId: 1,
    time: DateTime.now().subtract(const Duration(minutes: 50)),
  ),
  Message(
    id: 2,
    content:
        'Yes, I have a few items for sale. What exactly are you looking for?',
    senderId: 1,
    receiverId: 0,
    time: DateTime.now().subtract(const Duration(minutes: 48)),
  ),
  Message(
    id: 3,
    content:
        "I'm interested in electronics, especially phones. Do you have any?",
    senderId: 0,
    receiverId: 1,
    time: DateTime.now().subtract(const Duration(minutes: 46)),
  ),
];

List<Chat> chats = [
  Chat(
    name: 'Ebom Customer Service',
    image: AppAssets.logoSquare,
    messages: [
      Message(
        id: 0,
        senderId: 1,
        receiverId: 0,
        time: DateTime.now(),
        content:
            "Bienvenue sur l'application Ebom. Dites-nous en quoi le service client peut vous aider à améliorer votre expérience dans cette application.",
      ),
      Message(
        id: 1,
        senderId: 0,
        receiverId: 1,
        time: DateTime.now().subtract(const Duration(minutes: 2)),
        content:
            "Merci, j'ai des questions sur le fonctionnement de l'application.",
      ),
      Message(
        id: 2,
        senderId: 1,
        receiverId: 0,
        time: DateTime.now().subtract(const Duration(minutes: 1)),
        content: 'Bien sûr ! Quel aspect vous intéresse ?',
      ),
      Message(
        id: 3,
        senderId: 0,
        receiverId: 1,
        time: DateTime.now().subtract(const Duration(seconds: 30)),
        content:
            "J'aimerais en savoir plus sur les fonctionnalités de recherche.",
      ),
    ],
  ),
  Chat(
    name: 'Toyota Motors',
    image: AppAssets.entreprise,
    messages: [
      Message(
        id: 4,
        senderId: 1,
        receiverId: 0,
        time: DateTime.now(),
        content: 'Bonjour ! Comment puis-je vous aider avec votre Toyota ?',
      ),
      Message(
        id: 5,
        senderId: 0,
        receiverId: 1,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        content: 'Je recherche des informations sur les derniers modèles.',
      ),
      Message(
        id: 6,
        senderId: 1,
        receiverId: 0,
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        content:
            'Nous avons de super nouveaux modèles ! Voulez-vous planifier un essai ?',
      ),
      Message(
        id: 7,
        senderId: 0,
        receiverId: 1,
        time: DateTime.now().subtract(const Duration(minutes: 15)),
        content: 'Oui, ce serait super. Quand êtes-vous disponible ?',
      ),
    ],
  ),
  Chat(
    name: 'Tech Solutions',
    image: AppAssets.productExample,
    messages: [
      Message(
        id: 8,
        senderId: 1,
        receiverId: 0,
        time: DateTime.now(),
        content: 'Salut ! Oui, nous sommes prévus pour la réunion à 10h.',
      ),
      Message(
        id: 9,
        senderId: 0,
        receiverId: 1,
        time: DateTime.now().subtract(const Duration(minutes: 2)),
        content: 'Avons-nous un ordre du jour préparé ?',
      ),
      Message(
        id: 10,
        senderId: 1,
        receiverId: 0,
        time: DateTime.now().subtract(const Duration(minutes: 1)),
        content: 'Oui, je vais le partager avec vous sous peu.',
      ),
      Message(
        id: 11,
        senderId: 0,
        receiverId: 1,
        time: DateTime.now().subtract(const Duration(seconds: 30)),
        content: "Super ! J'ai hâte de le voir.",
      ),
    ],
  ),
  Chat(
    name: 'OPIPS Capital',
    image: AppAssets.servicesImages[1],
    messages: [
      Message(
        id: 12,
        senderId: 4,
        receiverId: 0,
        time: DateTime.now(),
        content:
            "Bonjour ! Êtes-vous prêt à explorer de nouvelles opportunités d'investissement ?",
      ),
      Message(
        id: 13,
        senderId: 0,
        receiverId: 4,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        content: 'Oui, je suis intéressé à en savoir plus sur vos services.',
      ),
      Message(
        id: 14,
        senderId: 4,
        receiverId: 0,
        time: DateTime.now().subtract(const Duration(minutes: 10)),
        content:
            "Nous offrons une variété de plans d'investissement adaptés à vos besoins.",
      ),
      Message(
        id: 15,
        senderId: 0,
        receiverId: 4,
        time: DateTime.now().subtract(const Duration(minutes: 15)),
        content:
            'Cela semble intéressant ! Pouvez-vous fournir plus de détails ?',
      ),
    ],
  ),
];
