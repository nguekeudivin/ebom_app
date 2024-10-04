class Conversation {
  final int id;
  final String nom;
  final String sigle;
  final String email;
  final String telephone;
  final String image;
  final String role;

  // Default image URL
  static const String defaultImage =
      'https://admin.beigie-innov.com/storage/users/default.png';

  Conversation({
    required this.id,
    required this.nom,
    required this.sigle,
    required this.email,
    required this.telephone,
    required this.role,
    this.image = defaultImage,
  });

  // Factory constructor to create a Conversation object from JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      nom: json['nom'],
      sigle: json['sigle'],
      email: json['email'],
      telephone: json['telephone'],
      image: json['image'] ?? defaultImage,
      role: json['role'],
    );
  }

  // Method to convert Conversation object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'sigle': sigle,
      'email': email,
      'telephone': telephone,
      'image': image,
      'role': role,
    };
  }
}
