import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simpsonsviewer/base/controllers/app_controller.dart';
import 'package:simpsonsviewer/base/views/adaptive_layout.dart';

const String kSimpsonsID = 'simpsons';
const String kAppTitle = 'The Simpsons';

void main() {
  runApp(const TheSimpsonsApp());
}

/// App for exploring the characters of The Simpsons TV Show.
/// Adaptive for:
/// - Android and iOS
/// - Phone and Tablet
/// - Light and Dark modes
class TheSimpsonsApp extends StatefulWidget {
  const TheSimpsonsApp({super.key});

  @override
  State<StatefulWidget> createState() => TheSimpsonsAppState();
}

class TheSimpsonsAppState extends State<TheSimpsonsApp> {
  late final AppController _controller;
  late final http.Client _client;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _controller = AppController(showName: kSimpsonsID, client: _client);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        title: kAppTitle,
        home: AdaptiveLayout(
          appTitle: 'The Simpsons Viewer',
          controller: _controller,
        ),
      );
    }
    return MaterialApp(
      title: kAppTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AdaptiveLayout(
        appTitle: 'The Simpsons Viewer',
        controller: _controller,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _client.close();
    super.dispose();
  }
}
