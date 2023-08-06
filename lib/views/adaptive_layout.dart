import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:simpsonsviewer/controllers/app_controller.dart';
import 'package:simpsonsviewer/models/character.dart';
import 'package:simpsonsviewer/views/character_list.dart';

/// Leargest size of shortest side of a phone
const double kSizeBreakPoint = 550.0;

/// Flex for list in large mode
const int kListFlex = 2;

/// Flex for detail in large mode
const int kDetailFlex = 3;

/// Display for app. Adaptive to size (tablet or phone), orientation 
/// (in large size), and platform (iOS or otherwise).
/// In large mode, displays list + detail of selected Character.
/// In small mode, displays list.
class AdaptiveLayout extends StatelessWidget {

  /// Creates a widget that displays for app. Adaptive to size
  ///  (tablet or phone), orientation (in large size), and 
  /// platform (iOS or otherwise). In large mode, displays 
  /// list + detail of selected Character. In small mode, displays list.
  const AdaptiveLayout({super.key, required this.controller});

  /// Controller for fetching list of characters and selecting 
  /// characters
  final AppController controller;

  /// Determines whether device is larger than a typical phone
  bool _isLarge(BuildContext context, BoxConstraints constraints) {
    bool isLarge;
    if (constraints.hasBoundedHeight && constraints.hasBoundedWidth) {
      double shortest = constraints.maxHeight > constraints.maxWidth
          ? constraints.maxWidth
          : constraints.maxHeight;
      isLarge = shortest > kSizeBreakPoint;
    } else {
      isLarge = MediaQuery.of(context).size.shortestSide > kSizeBreakPoint;
    }
    return isLarge;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SizeAdaptiveView(
            isLarge: _isLarge(context, constraints),
            orientation: orientation,
            getCharacterList: controller.fetchAll,
            onSelect: (character) => controller.select = character,
            selectedCharacter: controller.selectedCharacter,
          );
        },
      );
    });
  }
}

/// Displays either [ListDetail] or [CharacterList] depending
/// on [isLarge].
/// [isLarge] : Whether device is larger than a phone (tablet)
/// [orientation] : Orientation of device, used by [ListDetail]
/// [selectedCharacter] : ValueListenable of character used by
/// both [ListDetail] and [CharacterList]
/// [getCharacterList] : Function used to fetch list of characters
/// [onSelect] : Function used to select character
class SizeAdaptiveView extends StatelessWidget {

  /// Creates a widget that displays either [ListDetail] or 
  /// [CharacterList] depending on [isLarge].
  /// [isLarge] : Whether device is larger than a phone (tablet)
  /// [orientation] : Orientation of device, used by [ListDetail]
  /// [selectedCharacter] : ValueListenable of character used by
  /// both [ListDetail] and [CharacterList]
  /// [getCharacterList] : Function used to fetch list of characters
  /// [onSelect] : Function used to select character
  const SizeAdaptiveView({
    super.key,
    required this.isLarge,
    required this.orientation,
    required this.selectedCharacter,
    required this.getCharacterList,
    required this.onSelect,
  });

  ///Whether device is larger than a phone (tablet)
  final bool isLarge;

  /// Orientation of device, used by [ListDetail]
  final Orientation orientation;

  /// ValueListenable of character used by
  /// both [ListDetail] and [CharacterList]
  final ValueListenable<Character?> selectedCharacter;

  /// Function used to fetch list of characters
  final Future<List<Character>> Function() getCharacterList;

  /// Function used to select character
  final ValueChanged<Character?> onSelect;

  @override
  Widget build(BuildContext context) {
    return isLarge
        ? ListDetail(
            orientation: orientation,
            selectedCharacter: selectedCharacter,
            getCharacterList: getCharacterList,
            onSelect: onSelect,
          )
        : CharacterList(
            getCharacterList: getCharacterList,
            onSelect: onSelect,
            useScaffold: true,
          );
  }
}

/// Displays both list and deatil views. Facilitates search
/// and selection and detail display in one view.
/// [orientation] determines the location of list and detail.
/// [selectedCharacter] ValueListenable detail listens to.
/// [getCharacterList] Function returns Future<List<Character>>
/// [onSelect] callback for list to select characters.
class ListDetail extends StatelessWidget {

/// Creates a widget that displays both list and deatil views. 
/// Facilitates search and selection and detail display in one view.
/// [orientation] determines the location of list and detail.
/// [selectedCharacter] ValueListenable detail listens to.
/// [getCharacterList] Function returns Future<List<Character>>
/// [onSelect] callback for list to select characters.
  const ListDetail({
    super.key,
    required this.orientation,
    required this.selectedCharacter,
    required this.getCharacterList,
    required this.onSelect,
  });

  /// Device orientation. Determines direction and location
  /// of list and detail
  final Orientation orientation;

  /// ValueListenable to which detail listens to displays 
  /// character details.
  final ValueListenable<Character?> selectedCharacter;

  /// Function that fetches list of characters for use by list.
  final Future<List<Character>> Function() getCharacterList;

  /// Callback for list items to select character
  final ValueChanged<Character?> onSelect;

  @override
  Widget build(BuildContext context) {
    // Make basic list view
    Widget list = CharacterList(
      getCharacterList: getCharacterList,
      onSelect: onSelect,
      useScaffold: false,
    );
    // Wrap in platform specific scaffold
    list = Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Simpsons'),
            ),
            child: Padding(
              padding: kCupertinoNavBarHeight,
              child: list,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Simpsons'),
            ),
            body: list,
          );
    // Wrap in Flixible for use in Flex
    list = Flexible(
      flex: kListFlex,
      child: list,
    );
    Widget detail = ValueListenableBuilder<Character?>(
      valueListenable: selectedCharacter,
      builder: (context, value, _) {
        return Center(
          child: Text(value != null ? value.name : 'None selected'),
        );
      },
    );
    // Wrap in platform specific scaffold
    detail = Platform.isIOS
        ? CupertinoPageScaffold(
            child: detail,
          )
        : Scaffold(
            body: detail,
          );
    // Wrap in Flixible for use in Flex
    detail = Flexible(
      flex: kDetailFlex,
      child: detail,
    );
    // Assemble Flex params
    final Axis direction;
    final List<Widget> flexChildren;
    if (orientation == Orientation.portrait) {
      direction = Axis.vertical;
      flexChildren = [detail, list];
    } else {
      direction = Axis.horizontal;
      flexChildren = [list, detail];
    }
    return Flex(
      direction: direction,
      children: flexChildren,
    );
  }
}
