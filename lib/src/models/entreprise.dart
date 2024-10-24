class Entreprise {
  int id;
  String nom;
  String sigle;
  String email;
  String telephone;
  String rccm;
  String niu;
  String directeur;
  String dateCreation;
  String boitePostale;
  String quartier;
  String departement;
  String arrondissement;
  String ville;
  String pays;
  String image;
  String slogan;
  String logo;
  String description;
  String url;
  String banniere;

  // Constructor with default values for sigle, pays, and image
  Entreprise({
    required this.id,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.rccm,
    required this.niu,
    required this.directeur,
    required this.dateCreation,
    required this.boitePostale,
    required this.quartier,
    required this.departement,
    required this.arrondissement,
    required this.ville,
    this.sigle = '',
    this.pays = 'Cameroun',
    this.image = 'https://admin.bie-innov.com/storage/users/default.png',
    this.slogan = '',
    this.logo = 'https://admin.bie-innov.com/storage/users/default.png',
    this.description = '',
    this.url = '',
    this.banniere = '',
  });

  // Factory method for creating an instance from JSON
  factory Entreprise.fromJson(Map<String, dynamic> json) {
    return Entreprise(
      id: int.parse(json['id']),
      nom: json['nom'],
      sigle: json['sigle'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      rccm: json['rccm'] ?? '',
      niu: json['niu'] ?? '',
      directeur: json['directeur'] ?? '',
      dateCreation: json['date_creation'] ?? '',
      boitePostale: json['boite_postale'] ?? '',
      quartier: json['quartier'] ?? '',
      departement: json['departement'] ?? '',
      arrondissement: json['arrondissement'] ?? '',
      ville: json['ville'] ?? '',
      pays: json['pays'] ?? 'Cameroun',
      image: json['image'] ??
          'https://admin.bie-innov.com/storage/users/default.png',
      slogan: json['slogan'] ?? '',
      logo: json['logo'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      banniere: json['banniere'] ?? '',
    );
  }

  factory Entreprise.fromDynamic(dynamic data) {
    return Entreprise(
      id: data['id'] is String ? int.parse(data['id']) : data['id'],
      nom: data['nom'] ?? '',
      sigle: data['sigle'] ?? '',
      email: data['email'] ?? '',
      telephone: data['telephone'] ?? '',
      rccm: data['rccm'] ?? '',
      niu: data['niu'] ?? '',
      directeur: data['directeur'] ?? '',
      dateCreation: data['date_creation'] ?? '',
      boitePostale: data['boite_postale'] ?? '',
      quartier: data['quartier'] ?? '',
      departement: data['departement'] ?? '',
      arrondissement: data['arrondissement'] ?? '',
      ville: data['ville'] ?? '',
      pays: data['pays'] ?? 'Cameroun',
      image: data['image'] ??
          'https://admin.bie-innov.com/storage/users/default.png',
      slogan: data['slogan'] ?? '',
      logo: data['logo'] ??
          'https://admin.bie-innov.com/storage/users/default.png',
      description: data['description'] ?? '',
      url: data['url'] ?? '',
      banniere: data['banniere'] ??
          'https://admin.bie-innov.com/storage/users/default.png',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'sigle': sigle,
      'email': email,
      'telephone': telephone,
      'rccm': rccm,
      'niu': niu,
      'directeur': directeur,
      'date_creation': dateCreation,
      'boite_postale': boitePostale,
      'quartier': quartier,
      'departement': departement,
      'arrondissement': arrondissement,
      'ville': ville,
      'pays': pays,
      'image': image,
      'slogan': slogan,
      'logo': logo,
      'description': description,
      'url': url,
      'banniere': banniere,
    };
  }
}
