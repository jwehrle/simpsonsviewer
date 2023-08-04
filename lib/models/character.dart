/// Extracts first and last name of character from [text]. Expects first and
/// last name to be first and second words in [text]. "Words" == one or more letters
/// separated by a single space.
/// If [text] has 2 or more words, returns first as firs name and second as last name.
/// If [text] is empty, returns empty string.
/// If [text] has only one word, returns that one word.
String _extractName(String text) {
  final textList = text.split(' ');
  if (textList.isEmpty) {
    return '';
  }
  final nameList = textList.sublist(0, textList.length > 1 ? 2 : 1);
  return nameList.length == 1 ? nameList[0] : '${nameList[0]} ${nameList[1]}';
}

/// Extracts image url from [map].
/// If [map] contains "Icon" field, 
/// and "Icon" value is a map,
/// and "Icon" map contains "URL" field,
/// and "URL" value is type String then returns "URL" value.
/// If any of the above are false, returns empty string.
String _extractImageURL(Map<String, dynamic> map) {
  if (!map.containsKey("Icon")) {
    return '';
  }
  final icon = map["Icon"]!;
  if (icon is! Map) {
    return '';
  }
  if (!icon.containsKey("URL")) {
    return '';
  }
  final url = icon["URL"]!;
  if (url is! String) {
    return '';
  }
  return url;
}

/// Encapsulates required character details of [name], [description], and [imageURL].
/// Has no public constructor. Use the factory, Character.fromMap().
class Character {
  final String name;
  final String description;
  final String imageURL;

  /// Private constructor. Use only Character.fromMap()
  Character._({
    required this.name,
    required this.description,
    required this.imageURL,
  });

  /// Creates a Character from [map]. Expects key value pairs based on
  /// duckduckgo API. See https://serpapi.com/duckduckgo-search-api
  factory Character.fromMap(Map<String, dynamic> map) {
    final String text = map['Text'] ?? '';
    return Character._(
      name: _extractName(text),
      description: text,
      imageURL: _extractImageURL(map),
    );
  }

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
