import 'package:flutter/material.dart';
import 'package:simpsonsviewer/controllers/app_controller.dart';
import 'package:simpsonsviewer/models/character.dart';
import 'package:simpsonsviewer/views/character_list.dart';

const double kSizeBreakPoint = 550.0;

class AdaptiveLayout extends StatelessWidget {
  final AppController controller;

  const AdaptiveLayout({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return LayoutBuilder(builder: (context, constraints) {
        bool isLarge;
        if (constraints.hasBoundedHeight && constraints.hasBoundedWidth) {
          double shortest = constraints.maxHeight > constraints.maxWidth
              ? constraints.maxWidth
              : constraints.maxHeight;
          isLarge = shortest > kSizeBreakPoint;
        } else {
          isLarge = MediaQuery.of(context).size.shortestSide > kSizeBreakPoint;
        }
        if (isLarge) {
          return Flex(
            direction: orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            children: [
              Flexible(
                flex: 2,
                child: CharacterList(
                  getCharacterList: controller.fetchAll,
                  onSelect: (character) => controller.select = character,
                  useScaffold: false,
                ),
              ),
              Flexible(
                flex: 3,
                child: ValueListenableBuilder<Character?>(
                    valueListenable: controller.selectedCharacter,
                    builder: (context, value, _) {
                      return Center(
                        child:
                            Text(value != null ? value.name : 'None selected'),
                      );
                    }),
              ),
            ],
          );
        } else {
          return CharacterList(
            getCharacterList: controller.fetchAll,
            onSelect: (character) => controller.select = character,
            useScaffold: true,
          );
        }
      });
    });
  }
}
