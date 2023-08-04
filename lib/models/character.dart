import 'dart:convert';

String _extractName(String text) {
  final textList = text.split(' ');
  String name = '';
  if (textList.isNotEmpty) {
    final nameList = textList.sublist(0, textList.length > 1 ? 2 : 1);
    name =
        nameList.length == 1 ? nameList[0] : '${nameList.first} ${nameList[1]}';
  }
  return name;
}

String _extractImageURL(Map<String, dynamic> map) {
  final Map icon = map["Icon"] ?? {};
  return icon["URL"] ?? '';
}

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
    final String text = map['Text'] ?? '';
    return Character._(
      name: _extractName(text),
      description: text,
      imageURL: _extractImageURL(map),
    );
  }

  factory Character.fromJson(String source) =>
      Character.fromMap(json.decode(source));

  @override
  String toString() =>
      'Character(name: $name, description: $description, imageURL: $imageURL)';

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
