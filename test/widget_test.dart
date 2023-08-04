// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simpsonsviewer/controllers/app_controller.dart';

import 'package:simpsonsviewer/main.dart';
import 'package:simpsonsviewer/models/character.dart';

/// Example character map taken from successful API result.
const Map<String, dynamic> wellFormedCharacterMap = {
  "FirstURL": "https://duckduckgo.com/Apu_Nahasapeemapetilan",
  "Icon": {"Height": "", "URL": "/i/99b04638.png", "Width": ""},
  "Result":
      "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilon\">Apu Nahasapeemapetilon</a><br>Apu Nahasapeemapetilon is a recurring char…",
  "Text":
      "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons…",
};

/// Example character map with only one word in Text field. Edge case for name extraction.
const Map<String, dynamic> textWithSingleCharacterMap = {
  "FirstURL": "https://duckduckgo.com/Apu_Nahasapeemapetilan",
  "Icon": {"Height": "", "URL": "/i/99b04638.png", "Width": ""},
  "Result":
      "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilon\">Apu Nahasapeemapetilon</a><br>Apu Nahasapeemapetilon is a recurring char…",
  "Text": "Apu",
};

/// Example character map with no image url. Happens frequently.
const Map<String, dynamic> noImageCharacterMap = {
  "FirstURL": "https://duckduckgo.com/Apu_Nahasapeemapetilan",
  "Icon": {"Height": "", "URL": "", "Width": ""},
  "Result":
      "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilon\">Apu Nahasapeemapetilon</a><br>Apu Nahasapeemapetilon is a recurring char…",
  "Text":
      "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons…",
};

/// Example character map with no image url. Happens frequently.
const Map<String, dynamic> weirdImageCharacterMap = {
  "FirstURL": "https://duckduckgo.com/Apu_Nahasapeemapetilan",
  "Icon": {"Height": "", "URL": true, "Width": ""},
  "Result":
      "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilon\">Apu Nahasapeemapetilon</a><br>Apu Nahasapeemapetilon is a recurring char…",
  "Text":
      "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons…",
};

/// Example character map for failed API result.
const Map<String, dynamic> emptyCharacterMap = {};

void main() {
  group('Character model tests', () {
    test('Character test: Wellformed map', () {
      Character character = Character.fromMap(wellFormedCharacterMap);
      expect(character.name, "Apu Nahasapeemapetilon");
      expect(character.description,
          "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons…");
      expect(character.imageURL, "/i/99b04638.png");
    });

    test('Character test: Text with single word map', () {
      Character character = Character.fromMap(textWithSingleCharacterMap);
      expect(character.name, "Apu");
      expect(character.description, "Apu");
      expect(character.imageURL, "/i/99b04638.png");
    });

    test('Character test: No image map', () {
      Character character = Character.fromMap(noImageCharacterMap);
      expect(character.name, "Apu Nahasapeemapetilon");
      expect(character.description,
          "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons…");
      expect(character.imageURL, "");
    });

    test('Character test: No image map', () {
      Character character = Character.fromMap(weirdImageCharacterMap);
      expect(character.name, "Apu Nahasapeemapetilon");
      expect(character.description,
          "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons…");
      expect(character.imageURL, "");
    });

    test('Character test: Empty map', () {
      Character character = Character.fromMap(emptyCharacterMap);
      expect(character.name, "");
      expect(character.description, "");
      expect(character.imageURL, "");
    });
  });

  group("AppController tests", () { 
    test('showName', () {
      AppController controller = AppController(showName: "simpsons");
    expect(controller.showName, "simpsons");
    controller.dispose();
    });

    test('fetchAll', () {
      AppController controller = AppController(showName: "simpsons");
      final result = controller.fetchAll();
    expect(result, <Character>[]);
    controller.dispose();
    });

    test('fetchAllContaining', () {
      AppController controller = AppController(showName: "simpsons");
    final result = controller.fetchAllContaining('test');
    expect(result, <Character>[]);
    controller.dispose();
    });

    test('select', () {
      Character character = Character.fromMap(wellFormedCharacterMap);
      AppController controller = AppController(showName: "simpsons");
      controller.selectedCharacter.addListener(() => expect(controller.selectedCharacter, character));
      controller.select = character;
      controller.dispose();
    });

    test('unselect', () {
      AppController controller = AppController(showName: "simpsons");
      controller.selectedCharacter.addListener(() => expect(controller.selectedCharacter, null));
      controller.select = null;
      controller.dispose();
    });
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
