class Service {
  int id;
  String nom;
  String prix;
  String categorie;
  String description;
  String details; // Nullable field
  String image;
  int vues;
  String userRole;
  int userId;
  int categoryId;

  // Constructor with default values for prix, image, and vues
  Service({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.description,
    required this.userRole,
    required this.userId,
    required this.categoryId,
    this.prix = '',
    this.details = '',
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
      categoryId: json['category_id'],
    );
  }

  factory Service.fromDynamic(dynamic data) {
    return Service(
      id: data['id'] is String ? int.parse(data['id']) : data['id'],
      nom: data['nom'] ?? '',
      prix: data['prix'] ?? '',
      categorie: data['categorie'] ?? '',
      description: data['description'] ?? '',
      details: data['details'] ?? '',
      image: data['image'] ??
          'https://admin.bie-innov.com/storage/services/default.jpg',
      vues: data['vues'] ?? 0,
      userRole: data['user_role'] ?? '',
      userId: data['user_id'] ?? 0,
      categoryId: data['categorie_id'] != null
          ? (data['categorie_id'] is String
              ? int.parse(data['categorie_id'])
              : data['categorie_id'])
          : 0,
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
