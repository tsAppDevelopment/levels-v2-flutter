import 'package:five_level_one/Widgets/UIWidgets/Cards.dart';
import 'package:five_level_one/Widgets/UIWidgets/Rows.dart';
import 'package:five_level_one/Widgets/UIWidgets/input/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class AircraftCard extends StatelessWidget {
  final String name;
  AircraftCard(this.name);
  @override
  Widget build(BuildContext context) {
    return CardAllwaysOpen(
          "Aircraft",
           Row2(Tex(this.name), CustomButton('Change MDS', onPressed: (){Phoenix.rebirth(context);},))
    );
  }
}