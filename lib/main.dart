import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simpsonsviewer/base/controllers/app_controller.dart';
import 'package:simpsonsviewer/base/views/adaptive_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<StatefulWidget> createState() => MyAppState();

}

class MyAppState extends State<MyApp> {

  late final AppController controller;
  late final http.Client client;

  @override
  void initState() {
    super.initState();
    client = http.Client();
    controller = AppController(showName: 'simpsons', client: client);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'Simpsons!',
        theme: const CupertinoThemeData(
          primaryColor: CupertinoColors.systemPurple,
        ),
        home: AdaptiveLayout(controller: controller),
      );
    }
    return MaterialApp(
      title: 'Simpsons',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AdaptiveLayout(controller: controller),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    client.close();
    super.dispose();
  }
}