import 'dart:convert';

class Connexion {
  final String? id;
  final String nom;
  final String? sigle;
  final String email;
  final String telephone;
  final String image;
  final String role;
  final String? status;
  final bool? isValid;

  Connexion({
    required this.email,
    required this.telephone,
    required this.image,
    required this.role,
    required this.nom,
    this.id,
    this.sigle,
    this.status,
    this.isValid,
  });

  // Factory method to create a Connexion from a JSON map
  factory Connexion.fromJson(Map<String, dynamic> json) {
    return Connexion(
      id: json['id'],
      nom: json['nom'],
      sigle: json['sigle'],
      email: json['email'],
      telephone: json['telephone'],
      image: json['image'],
      role: json['role'],
      status: json['status'],
      isValid: json['isValid'],
    );
  }

  // Method to convert a Connexion to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'sigle': sigle,
      'email': email,
      'telephone': telephone,
      'image': image,
      'role': role,
      'status': status,
      'isValid': isValid,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Static method to create a Connexion from a JSON string
  static Connexion fromJsonString(String jsonString) {
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return Connexion.fromJson(jsonData);
  }
}
