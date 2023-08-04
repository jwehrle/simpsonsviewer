import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:simpsonsviewer/models/character.dart';

String _duckDuckGoQuery(String showName) {
  return "http://api.duckduckgo.com/?q=$showName+characters&format=json";
}

class AppController {

  /// The name of the used in the query field of the duckduckgo API call.
  /// [showName] must conform to API. See https://serpapi.com/duckduckgo-search-api
  final String showName;

  /// Creates a controller for this application which can:
  /// Fetch all characters from [showName],
  /// Search characters based on key terms,
  /// Character selection.
  AppController({
    required this.showName,
  });

  /// Underlying selection ValueNotifier.
  final ValueNotifier<Character?> _selectedCharacter = ValueNotifier(null);

  /// The currently selected Character. If none is selected, value == null.
  /// Listen to this Listenable for selection changes.
  ValueListenable<Character?> get selectedCharacter => _selectedCharacter;

  /// Select the character. Set to null to unselect. Changes trigger
  /// notifications to all listeners.
  set select(Character? character) => _selectedCharacter.value = character;

  /// Returns list of all characters.
  List<Character> fetchAll() {
    return [];
  }

  /// Returns list of all Characters where "Text" field contains [search]
  List<Character> fetchAllContaining(String search) {
    return [];
  }

  /// Dispose of resources that need to be disposed.
  void dispose() {
    _selectedCharacter.dispose();
  }
}
