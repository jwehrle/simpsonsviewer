// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simpsonsviewer/main.dart';
import 'package:simpsonsviewer/models/character.dart';

const Map<String, dynamic> testCharacterMap = {
"FirstURL" : "https://duckduckgo.com/Apu_Nahasapeemapetilan",
"Icon" : {"Height" : "", "URL" : "/i/99b04638.png", "Width" : "" },
"Result" : "<a href=\"https://duckduckgo.com/Apu_Nahasapeemapetilon\">Apu Nahasapeemapetilon</a><br>Apu Nahasapeemapetilon is a recurring char…",
"Text" : "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons…",
};

void main() {

  test('Character test', () {
    Character character = Character.fromMap(testCharacterMap);
    expect(character.name, "Apu Nahasapeemapetilon");
    expect(character.description, "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the American animated television series The Simpsons…");
    expect(character.imageURL, "/i/99b04638.png");
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
