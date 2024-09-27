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

  // Constructor with default values for sigle, pays, and image
  Entreprise({
    required this.id,
    required this.nom,
    this.sigle = '',
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
    this.pays = 'Cameroun',
    this.image = 'https://admin.bie-innov.com/storage/users/default.png',
  });

  // Factory method for creating an instance from JSON
  factory Entreprise.fromJson(Map<String, dynamic> json) {
    return Entreprise(
      id: json['id'],
      nom: json['nom'],
      sigle: json['sigle'] ?? '',
      email: json['email'],
      telephone: json['telephone'],
      rccm: json['rccm'],
      niu: json['niu'],
      directeur: json['directeur'],
      dateCreation: json['date_creation'],
      boitePostale: json['boite_postale'],
      quartier: json['quartier'],
      departement: json['departement'],
      arrondissement: json['arrondissement'],
      ville: json['ville'],
      pays: json['pays'] ?? 'Cameroun',
      image: json['image'] ??
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
    };
  }
}
