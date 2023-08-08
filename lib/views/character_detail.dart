import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:simpsonsviewer/models/character.dart';
import 'package:simpsonsviewer/models/constants.dart';

class CharacterDetailTablet extends StatelessWidget {
  const CharacterDetailTablet({
    super.key,
    required this.selectedCharacter,
  });

  final ValueListenable<Character?> selectedCharacter;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Character?>(
      valueListenable: selectedCharacter,
      builder: (context, character, _) {
        Widget body;

        if (character != null) {
          List<Widget> children = [
            Expanded(
              child: CharacterImage(
                character: character,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CharacterDescription(
                character: character,
              ),
            )
          ];
          body = Column(
            mainAxisSize: MainAxisSize.max,
            children: children,
          );
        } else {
          body = Container();
        }
        return AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          child: Container(
            key: ValueKey(character?.hashCode ?? 'null'),
            child: body,
          ),
        );
      },
    );
  }
}

class CharacterDetailPhone extends StatelessWidget {
  const CharacterDetailPhone({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    Widget body;

    List<Widget> children = [
      Expanded(
        child: Padding(
          padding: Platform.isIOS ? kCupertinoNavBarHeight : EdgeInsets.zero,
          child: CharacterImage(
            character: character,
          ),
        ),
      ),
      Padding(
        padding: Platform.isIOS ? kCupertinoDescriptionPadding : EdgeInsets.zero,
        child: CharacterDescription(
          character: character,
        ),
      )
    ];
    body = Column(
      mainAxisSize: MainAxisSize.max,
      children: children,
    );

    final title = Text(character.name);
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: title),
        child: body,
      );
    }
    return Scaffold(
      appBar: AppBar(title: title),
      body: body,
    );
  }
}

class CharacterImage extends StatelessWidget {
  const CharacterImage({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kCupertinoNavBarHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        return character.imageURL.isEmpty
            ? Image.asset(
                'assets/no_image.png',
                fit: BoxFit.contain,
              )
            : Image.network(
                '$kImageUrlPrefix${character.imageURL}',
                fit: BoxFit.contain,
              );
      }),
    );
  }
}

class CharacterDescription extends StatelessWidget {
  const CharacterDescription({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  Widget build(BuildContext context) {
    final title = Text(character.name);
    final desc = Text(
      character.description,
      maxLines: 20,
    );
    return Platform.isIOS
        ? CupertinoListTile(
            title: title,
            subtitle: desc,
          )
        : ListTile(
            title: title,
            subtitle: desc,
          );
  }
}
