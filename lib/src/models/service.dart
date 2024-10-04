class Service {
  int id;
  String nom;
  int prix;
  String categorie;
  String description;
  String? details; // Nullable field
  String image;
  int vues;
  String userRole;
  int userId;

  // Constructor with default values for prix, image, and vues
  Service({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.description,
    required this.userRole,
    required this.userId,
    this.prix = 0,
    this.details,
    this.image = 'https://admin.bie-innov.com/storage/services/default.jpg',
    this.vues = 0,
  });

  // Factory method for creating an instance from JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      nom: json['nom'],
      prix: json['prix'] ?? 0,
      categorie: json['categorie'],
      description: json['description'],
      details: json['details'],
      image: json['image'] ??
          'https://admin.bie-innov.com/storage/services/default.jpg',
      vues: json['vues'] ?? 0,
      userRole: json['user_role'],
      userId: json['user_id'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prix': prix,
      'categorie': categorie,
      'description': description,
      'details': details,
      'image': image,
      'vues': vues,
      'user_role': userRole,
      'user_id': userId,
    };
  }
}
