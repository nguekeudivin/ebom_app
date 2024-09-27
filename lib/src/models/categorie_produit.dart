class CategorieProduit {
  int id;
  String nom;
  String description;
  String icone;
  String image;
  String banniere;
  int vues;

  // Constructor with default values for icone, image, and banniere
  CategorieProduit({
    required this.id,
    required this.nom,
    required this.description,
    this.icone =
        'https://admin.bie-innov.com/storage/type_entreprises/default_icone.png',
    this.image =
        'https://admin.bie-innov.com/storage/type_entreprises/default.png',
    this.banniere =
        'https://admin.bie-innov.com/storage/type_entreprises/default_banniere.png',
    required this.vues,
  });

  // Factory method for creating an instance from JSON
  factory CategorieProduit.fromJson(Map<String, dynamic> json) {
    return CategorieProduit(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      icone: json['icone'] ??
          'https://admin.bie-innov.com/storage/type_entreprises/default_icone.png',
      image: json['image'] ??
          'https://admin.bie-innov.com/storage/type_entreprises/default.png',
      banniere: json['banniere'] ??
          'https://admin.bie-innov.com/storage/type_entreprises/default_banniere.png',
      vues: json['vues'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'icone': icone,
      'image': image,
      'banniere': banniere,
      'vues': vues,
    };
  }
}
