import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:simpsonsviewer/models/character.dart';

/// Displays list of character names adaptively based on
/// platform and [useScaffold], which is set by the device size
/// and indicates phone or tablet.
class CharacterList extends StatelessWidget {
  final Future<List<Character>> Function() getCharacterList;
  final ValueChanged<Character?> onSelect;
  final bool useScaffold;

  /// Creates a list of character names using [getCharacterList]
  const CharacterList({
    super.key,
    required this.getCharacterList,
    required this.onSelect,
    required this.useScaffold,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
        future: getCharacterList(),
        builder: (context, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return CharacterListError(
                error: 'Unknown error',
                useScaffold: useScaffold,
              );
            case ConnectionState.waiting:
              return CharacterListLoading(
                useScaffold: useScaffold,
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snap.hasData) {
                return CharacterListBody(
                  characters: snap.data!,
                  useScaffold: useScaffold,
                  onSelect: onSelect,
                );
              }
              if (snap.hasError) {
                return CharacterListError(
                  error: snap.error!,
                  useScaffold: useScaffold,
                );
              }
              return CharacterListBody(
                characters: const [],
                useScaffold: useScaffold,
                onSelect: onSelect,
              );
          }
        });
  }
}

class CharacterListLoading extends StatelessWidget {
  final bool useScaffold;

  const CharacterListLoading({
    super.key,
    required this.useScaffold,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      const Widget cuperChild = Center(
        child: CupertinoActivityIndicator(),
      );
      if (useScaffold) {
        return const CupertinoPageScaffold(
          child: cuperChild,
        );
      }
      return cuperChild;
    }
    const Widget matChild = Center(
      child: CircularProgressIndicator(),
    );
    if (useScaffold) {
      return const Scaffold(
        body: matChild,
      );
    }
    return matChild;
  }
}

class CharacterListBody extends StatelessWidget {
  final List<Character> characters;
  final bool useScaffold;
  final ValueChanged<Character?> onSelect;

  const CharacterListBody({
    super.key,
    required this.characters,
    required this.useScaffold,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      final Widget cuperChild = SingleChildScrollView(
        child: CupertinoListSection(
          children: characters
              .map((e) => CupertinoListTile(
                    title: Text(e.name),
                    onTap: () => onSelect(e),
                  ))
              .toList(),
        ),
      );
      if (useScaffold) {
        return CupertinoPageScaffold(
          child: cuperChild,
        );
      }
      return cuperChild;
    }
    final Widget matChild = ListView(
      children: characters
          .map((e) => ListTile(
                title: Text(e.name),
                onTap: () => onSelect(e),
              ))
          .toList(),
    );
    if (useScaffold) {
      return Scaffold(
        body: matChild,
      );
    }
    return matChild;
  }
}

class CharacterListError extends StatelessWidget {
  final Object error;
  final bool useScaffold;

  const CharacterListError({
    super.key,
    required this.error,
    required this.useScaffold,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      Widget cuperChild = const Center(
        child: CupertinoListTile(
          title: Text('Error'),
        ),
      );
      if (useScaffold) {
        return CupertinoPageScaffold(
          child: cuperChild,
        );
      }
      return cuperChild;
    }
    Widget matChild = const Center(
      child: ListTile(
        title: Text('Error'),
      ),
    );
    if (useScaffold) {
      return Scaffold(
        body: matChild,
      );
    }
    return matChild;
  }
}
