import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constant.dart';
import '../../models/nested/aircraft.dart';
import '../../models/nested/general.dart';
import '../../screens/glossary/glossary.dart';
import '../../screens/units/units.dart';
import '../../services/user_service.dart';
import '../../widgets/display/row_center_text.dart';
import '../../widgets/input/custom_button.dart';
import '../../widgets/input/more_op_modal.dart';
import '../../widgets/layout/card_allways_open.dart';
import '../../widgets/layout/div.dart';
import '../../widgets/layout/row2.dart';
import '../percentmac/per_mac_screen.dart';
import 'bottom_navigation.dart';
import 'loading.dart';

class Home extends StatefulWidget {
  final UserService services;
  Home(this.services): assert(services!=null);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BottomNav bn;
  General general;
  Widget body = Loading();
  Image img = Image.asset('assets/0.png');
  bool didLoad = false;
  bool didAccept = false;
  final sc = ScrollController();
  String apiResponse;

  @override
  void dispose() {
    sc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterFirstBuild();
    });

  }

  void afterFirstBuild() async {

    //dont await precache
    await precacheImage(img.image, context);

    //pre cach should complete before general is built
    general = await this.widget.services.getGeneral();

    //state is set and disclaimer is drawn
    buildDiclaimer();

    //after airpages load, accept unlocks
    this.widget.services.getAirs().then((airs) {
      setBn(airs);
    });

  }



  void setBn(List<Aircraft> airs) {
    var ap = LinkedHashMap<int, List<Widget>>();

    //build air pages
    for (int i = 0; i < airs.length; i++) {
      ap[i] = [Units(), PerMacScreen(airs[i]), GlossaryScreen(airs[i].glossarys)];
    }

    //set bn bar
    bn = BottomNav(
        tabPages: ap,
        general: general,
        airNames: List.generate(airs.length, (i) => airs[i].name));
    
    //set did load to unlock accept button
    didLoad = true;

    //if user clicked accept before ap were done building set state
    if (didAccept) {
      setState(() {
        body = bn;
      });
    }
  }

  void buildDiclaimer() {
    var ret = Scaffold(
      key:Key('home'),
        backgroundColor: background,
        body: CupertinoScrollbar(
            isAlwaysShown: true,
            controller: sc,
            child:Center(child: SingleChildScrollView( //wrapper to prevent jitters
            controller: sc,
            child:Container(
              width: maxCardWidth*.75,
              child:Column(
              children: [
              CardAllwaysOpen(
                  name: 'FIVE LEVEL', children: [Center(child: Container(width: 500, height: 500, child: img))], color: textColor),
              CardAllwaysOpen(
                  name: general.name,
                  color: textColor,
                  children: [
                    RowCenterText(general.body),
                    Div(),
                    Row2(CustomButton('I Accept', onPressed: accept),
                        MoreOpModal(general))
                  ])
            ]))))));

    setState(() {
      body = ret;
    });
  }

  void accept() {
    if (didLoad) {
      setState(() {body = bn;});

    } else {
      setState(() {
        didAccept = true;
        body = Loading();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return body;
  }
}
