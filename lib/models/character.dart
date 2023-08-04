import 'dart:convert';

class Character {
  final String name;
  final String description;
  final String imageURL;

  Character._({
    required this.name,
    required this.description,
    required this.imageURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageURL': imageURL,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character._(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageURL: map['imageURL'] ?? '',
    );
  }

  factory Character.fromJson(String source) => Character.fromMap(json.decode(source));

  @override
  String toString() => 'Character(name: $name, description: $description, imageURL: $imageURL)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Character &&
      other.name == name &&
      other.description == description &&
      other.imageURL == imageURL;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ imageURL.hashCode;
}
