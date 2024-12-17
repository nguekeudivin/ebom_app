import 'dart:async';

import 'package:ebom/src/config/app_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final String? baseUrl;

  ChatService({this.baseUrl = AppApi.chat});

  Future<dynamic> createConversation(
    int receiverId,
    String receiverRole,
  ) async {
    final Completer<dynamic> completer = Completer();

    // Get the token from preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http
        .post(
      Uri.parse('$baseUrl/conversation/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
      body: jsonEncode(
        {'recepteur_id': receiverId, 'recepteur_role': receiverRole},
      ),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        completer.complete(responseBody['data']);
      } else {
        completer.completeError(
          "Une erreur c'est produite au cours de la creation de la conversation",
        );
      }
    }).catchError((error) {
      completer.completeError(
        "Une erreur c'est produite au cours de la creation de la conversation",
      );
    });

    return completer.future;
  }

  Future<List<dynamic>> getConversations() async {
    final Completer<List<dynamic>> completer = Completer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        completer.complete(responseBody['data']);
      } else {
        completer.completeError(
          "Une erreur c'est produite lors du chargement des conversations",
        );
      }
    }).catchError((error) {
      completer.completeError(
        "Une erreur c'est produite lors du chargement des conversations",
      );
    });

    return completer.future;
  }

  Future<List<dynamic>> getMessages(int conversationId) async {
    final Completer<List<dynamic>> completer = Completer();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http.get(
      Uri.parse('$baseUrl/conversation/$conversationId/chats'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print(responseBody['data']);
        completer.complete(responseBody['data']);
      } else {
        completer.completeError(
          "Une erreur c'est produite lors du chargement des messages",
        );
      }
    }).catchError((error) {
      completer.completeError(
        "Une erreur c'est produite lors du chargement des messages",
      );
    });

    return completer.future;
  }

  Future<dynamic> writeMessage(int conversationId, String content) async {
    final Completer<dynamic> completer = Completer();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http
        .post(
      Uri.parse('$baseUrl/chat'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
      body: jsonEncode({
        'conversation_id': conversationId,
        'message': content,
        'reponseChatID': -1,
      }),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        completer.complete(responseBody['data']);
      } else {
        completer.completeError(
          'Erreur connexion internet',
        );
      }
    }).catchError((error) {
      completer.completeError(
        'Erreur connexion internet',
      );
    });

    return completer.future;
  }

  Future<dynamic> getLastMessage(int conversationId) async {
    final Completer<dynamic> completer = Completer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http.get(
      Uri.parse('$baseUrl/conversation/$conversationId/chat/last'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        completer.complete(responseBody['data']);
      } else {
        completer.completeError(
          'Erreur lors de la recuperation des derniers messages',
        );
      }
    }).catchError((error) {
      completer.completeError(
        'Erreur connexion internet',
      );
    });

    return completer.future;
  }

  Future<List<dynamic>> getUnreadMessages(int conversationId) async {
    final Completer<List<dynamic>> completer = Completer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http.get(
      Uri.parse('$baseUrl/conversation/$conversationId/chats/unread'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // We are not sur that this block we not raise any error.
        // In case does raise an error. We capture and send a empty result.
        try {
          List<dynamic> list = [];
          for (int i = 0; i < responseBody['data'].length; i++) {
            list.add(responseBody['data'][i]);
          }
          completer.complete(list);
        } catch (e) {
          completer.complete([]);
        }
      } else {
        completer.completeError(
          'Erreur lors de la recuperation des messages en attentes',
        );
      }
    }).catchError((error) {
      completer.completeError(
        'Erreur connexion internet',
      );
    });

    return completer.future;
  }

  Future<bool> deleteMessage(int messageId) async {
    final Completer<bool> completer = Completer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('ebom_token') as String;

    http.delete(
      Uri.parse('$baseUrl/chat/$messageId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'userKey': token,
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        completer.complete(true);
      } else {
        completer.completeError(
          "Une erreur c'est produite lors de la suppression du message",
        );
      }
    }).catchError((error) {
      completer.completeError(
        'Erreur connexion internet',
      );
    });

    return completer.future;
  }
}
