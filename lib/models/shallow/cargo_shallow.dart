import 'package:flutter/material.dart';
import '../../util.dart';
import '../../widgets/input/black_button_admin.dart';
import '../../widgets/input/edit_text_admin.dart';
import 'serializable.dart';

class CargoShallow implements APISerialiable {
  int aircraftid;
  int cargoid;

  String name;
  void setName(String s) => name = s;
  double weight;
  void setWeight(double w) => weight = w;
  double fs;
  void setFs(double s) => fs = s;
  int category;
  void setCategory(int c) => category = c;

  String ep = 'cargo';
  Function(Map<String, dynamic>) onSave;

  CargoShallow.fromJson(Map<String, dynamic> json, this.onSave)
      : aircraftid = json["aircraftid"],
        cargoid = json["cargoid"] ?? 0,
        name = json["name"] ?? '',
        weight = json["weight"] ?? 0,
        fs = json["fs"] ?? -1,
        category = json["category"] ?? 3;

  @override
  Map<String, dynamic> toJson() => {
        "aircraftid": aircraftid,
        "cargoid": cargoid,
        "name": name,
        "weight": weight,
        "fs": fs,
        "category": category,
      };

  @override
  Widget getForm() {
    final key = GlobalKey<FormState>();
    return Form(
        key: key,
        child: SingleChildScrollView(
            child: Column(children: [
          EditTextAdmin(
              initialValue: name,
              hintText: 'Name',
              validate: (s) => validateStringNotEmpty(s, setName)),
          EditTextAdmin(
              initialValue: weight.toString(),
              hintText: 'Weight',
              validate: (s) => valiadateDoublePositive(s, setWeight)),
          EditTextAdmin(
              initialValue: fs.toString(),
              hintText: 'Default FS (overridden by config)',
              validate: (s) => valiadateDoubleAny(s, setFs)),
          EditTextAdmin(
              initialValue: category.toString(),
              hintText: '1: Steward, 2: Emergency, 3: Extra',
              validate: (s) => validateOneTwoOrThree(s, setCategory)),
          BlackButtonAdmin(() {
            if (key.currentState.validate()) {
              this.onSave(this.toJson());
            }
          })
        ])));
  }
}
