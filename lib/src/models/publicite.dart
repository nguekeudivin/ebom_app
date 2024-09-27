class Publicite {
  int id;
  String titre;
  String secteur;
  int orientation;
  String url;
  String image;
  int click;

  // Constructor with default values for image and click
  Publicite({
    required this.id,
    required this.titre,
    required this.secteur,
    required this.orientation,
    required this.url,
    this.image = 'https://admin.bie-innov.com/storage/publicites/default.jpg',
    this.click = 0,
  });

  // Factory method for creating an instance from JSON
  factory Publicite.fromJson(Map<String, dynamic> json) {
    return Publicite(
      id: json['id'],
      titre: json['titre'],
      secteur: json['secteur'],
      orientation: json['orientation'],
      url: json['url'],
      image: json['image'] ??
          'https://admin.bie-innov.com/storage/publicites/default.jpg',
      click: json['click'] ?? 0,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'secteur': secteur,
      'orientation': orientation,
      'url': url,
      'image': image,
      'click': click,
    };
  }
}
