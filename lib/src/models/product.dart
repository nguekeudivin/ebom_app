class Product {
  int id;
  String nom;
  String marque;
  int prix;
  String categorie;
  String description;
  String? details; // Nullable field
  String image;
  int vues;
  String? userRole;
  int? userId;

  // Constructor with default values for prix, image, and vues
  Product({
    required this.id,
    required this.nom,
    required this.marque,
    required this.categorie,
    required this.description,
    this.userRole,
    this.userId,
    this.details,
    this.image = 'https://admin.bie-innov.com/storage/produits/default.jpg',
    this.vues = 0,
    this.prix = 0,
  });

  // Factory method for creating an instance from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nom: json['nom'],
      marque: json['marque'],
      prix: json['prix'] ?? 0,
      categorie: json['categorie'],
      description: json['description'],
      details: json['details'],
      image: json['image'] ??
          'https://admin.bie-innov.com/storage/produits/default.jpg',
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
      'marque': marque,
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

  factory Product.fromDynamic(dynamic json) {
    return Product(
      id: json['id'],
      nom: json['nom'],
      marque: json['marque'],
      prix: json['prix'] ?? 0,
      categorie: json['categorie'],
      description: json['description'],
      details: json['details'],
      image: json['image'] ??
          'https://admin.bie-innov.com/storage/produits/default.jpg',
      vues: json['vues'] ?? 0,
      userRole: json['user_role'],
      userId: json['user_id'],
    );
  }
}
