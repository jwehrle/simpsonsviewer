import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_detail_base/list_detail_base.dart';
import 'package:simpsonsviewer/base/controllers/app_controller.dart';
import 'package:simpsonsviewer/base/models/character.dart';
import 'package:simpsonsviewer/base/views/character_detail.dart';
import 'package:simpsonsviewer/base/views/character_list.dart';

const String kSimpsonsID = 'simpsons';
const String kAppTitle = 'Simpsons Character Viewer';

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

  /// Prevents TextFields in [CharacterListBody] from being reassigned
  /// on orientation changes.
  final GlobalKey<CharacterListBodyState> _characterListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _controller = AppController(
      showName: kSimpsonsID,
      client: _client,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller
          .fetchAll()
          .then((value) => _controller.characterList = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget layout = ListDetail(
      controller: _controller,
      child: Builder(
        builder: (innerContext) {
          return ListDetailLayout<Character>(
            controller: _controller,
            listBuilder: (context) {
              return  SizedBox(
                key: _characterListKey,
                child: const CharacterListBody(
                  appTitle: kAppTitle,
                  // characters: _characterList!,
                ),
              );
            },
            detailBuilder: (context) => const CharacterDetailTablet(),
          );
        },
      ),
    );

    return Platform.isIOS
        ? CupertinoApp(
            title: kAppTitle,
            home: CupertinoPageScaffold(
              navigationBar:
                  const CupertinoNavigationBar(middle: Text(kAppTitle)),
              child: Padding(
                padding: const EdgeInsets.only(top: 68.0, bottom: 32.0),
                child: layout,
              ),
            ),
          )
        : MaterialApp(
            title: kAppTitle,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: Scaffold(
              appBar: AppBar(title: const Text(kAppTitle)),
              body: layout,
            ),
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    _client.close();
    // _strCtl.close();
    super.dispose();
  }
}
