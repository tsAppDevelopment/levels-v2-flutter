



import 'package:five_level_one/backend/cont.dart';
import 'package:five_level_one/backend/model.dart';
import 'package:five_level_one/widgets/display/text.dart';
import 'package:five_level_one/widgets/input/customButton.dart';
import 'package:five_level_one/widgets/input/validatedText.dart';
import 'package:five_level_one/widgets/layout/alignPadding.dart';
import 'package:five_level_one/widgets/layout/cards/ccard.dart';
import 'package:five_level_one/widgets/layout/div.dart';
import 'package:five_level_one/widgets/layout/rows/row1.dart';
import 'package:five_level_one/widgets/layout/rows/row2.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class ValidatedCargoUI extends StatefulWidget {/// interates the data model NameWeightFS with UI elements for input, and error checking
  var ope = false;
  var calculated = false;
  String
  fs0,
  fs1,
  cargomaxweight,
  simpleMom;
  NameWeightFS nwf;
  IntCallBackIntPara onPressed;
  ValidatedText nameVT, weightVT, fsVT, qtyVT;
  Widget opened,closed;
  Key key;

  NotifyCargoValid notifyValid;

  ValidatedCargoUI({@required this.fs0, @required this.fs1, @required this.cargomaxweight, @required this.simpleMom, @required this.onPressed, @required this.key, @required this.notifyValid}){
    this.nwf = NameWeightFS();
    this.nwf.simplemom = this.simpleMom;
    this.calculated = false;
  }

  ///caculates fs
  ValidatedCargoUI.fromAddA({@required this.fs0, @required this.fs1, @required this.cargomaxweight, @required this.nwf, @required this.onPressed, @required this.key, @required this.notifyValid})
  : super(key:key)
  {
    this.simpleMom = this.nwf.simplemom; 
    this.calculated = true;
    this.nwf = nwf;
  }
  
  
  @override
  _ValidatedCargoUIState createState() => _ValidatedCargoUIState();
}

class _ValidatedCargoUIState extends State<ValidatedCargoUI> {
  ///determines to get caculated or non caculated fs
  String _getNWFfs(){
    if(this.widget.nwf.mom.isNotEmpty && this.widget.nwf.fs.isEmpty){
      return this.widget.nwf.getFS();
    }
    return this.widget.nwf.fs;
  }

  @override
  void initState() {
    super.initState();
    this.widget.nameVT = ValidatedText(
      initText: getNameTruncated(),
      inputType:2, 
      onChange: changeName,
      maxChars: 30,
      validateText: validateName,
      width: double.infinity,
    );

    this.widget.weightVT = ValidatedText(
      initText: this.widget.nwf.weight,
      inputType:1, 
      onChange: changeWeight,
      maxChars: 8,
      validateText: validateWeight,
    );

    this.widget.fsVT = ValidatedText(
      initText: _getNWFfs(),
      inputType:1, 
      onChange: changeFS,
      maxChars: 8,
      validateText: validateFS,
    );

    this.widget.qtyVT = ValidatedText(
      initText: this.widget.nwf.qty,
      inputType:1, 
      onChange: changeQty,
      maxChars: 8,
      validateText: validateQty,
    );

    buildStates();
  }

  String getNameTruncated(){
    var ret = this.widget.nwf.name;
    if(ret.length>30){return ret;}
    return ret.substring(0,26) + '...';
  }

  bool validateName(String x){
    if(x.length>=1){return true;}
    return false;
  }

  void changeName(String x){
    this.widget.nwf.name = x;
    setState((){});
  }

  bool validateWeight(String x){
    if(
      double.tryParse(x)!=null
      &&
      double.parse(x)> 0 
      &&
      double.parse(x)<= double.parse(this.widget.cargomaxweight)
    ){
      return true;
    }
    return false;
  }

  void changeWeight(String x){
    this.widget.nwf.weight = x;
    setState((){});
  }

  bool validateFS(String x){
    if(
      double.tryParse(x)!= null
      &&
      double.parse(x)>= double.parse(this.widget.fs0)
      &&
      double.parse(x)<= double.parse(this.widget.fs1)
    ){
      return true;
    }
    return false;
  }

  void changeFS(String x){
    this.widget.nwf.fs = x;
    setState((){});
  }

  bool validateQty(String x){
    if(
      int.tryParse(x)!=null
      &&
      int.parse(x)>0
    ){
      return true;
    }
    return false;
  }

  void changeQty(String x){
    this.widget.nwf.qty = x;
     setState((){});
  }

  Widget getCardTitle(){
    if(validateCargoUI()){
      if(this.widget.ope){
      return TitleCC(open:true, tex:Tex(this.widget.nwf.qty +' EA '+this.widget.nwf.name, fontWeight: FontWeight.normal));
      }
      return TitleCC(open:false,tex: Tex(this.widget.nwf.qty +' EA '+this.widget.nwf.name, fontWeight: FontWeight.normal));
    }
    if(this.widget.ope){
    return TitleCC(open:true,tex:Tex(this.widget.nwf.qty +' EA '+this.widget.nwf.name, fontWeight: FontWeight.normal,color: Const.focusedErrorBorderColor));
    }
    return TitleCC(open:false,tex:Tex(this.widget.nwf.qty +' EA '+this.widget.nwf.name, fontWeight: FontWeight.normal,color: Const.focusedErrorBorderColor));
  }

  bool validateCargoUI(){
    var ret;
    if(
      this.widget.nameVT.valid
      &&
      this.widget.weightVT.valid
      &&
      this.widget.fsVT.valid
      &&
      this.widget.qtyVT.valid
    ){ret = true;}
    else{ret = false;}

    //if function is not null, update listner
    this.widget.notifyValid?.call(this.widget.nwf.id,ret);
    return ret;
  }

  void removePress(){
    this.widget.onPressed(this.widget.nwf.id);
  }

  void buildStates(){

    this.widget.opened = Column(children: [
        Padding(padding: EdgeInsets.fromLTRB(0,5,0,0),child:RowCenterOne(this.widget.nameVT)),
        Div(),
        Row2(Tex('Weight'), this.widget.weightVT),
        Div(),
        Row2(Tex('Fuselage Station'), this.widget.fsVT),
        Div(),
        Row2(Tex('Qty'), this.widget.qtyVT),
        Div(),
        Padding(padding: EdgeInsets.fromLTRB(0,0,0,5),child:RowCenterOne(CustomButton('Remove',onPressed: (){this.widget.onPressed(this.widget.nwf.id);},)))
    ],);

    this.widget.closed = Container();
  }

  Widget buildInput(){
    if(this.widget.ope){return this.widget.opened;}
    return this.widget.closed;
  }

  toggle(){
    setState(() {
      this.widget.ope = !this.widget.ope;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(
          Const.cardP,
          Const.cardP,
          Const.cardP,
          0.0
          ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Card(
                color: Const.cargoUIColor,
                shape: Border(
                    top: BorderSide(
                  color: Const.cargoUIColor,
                  width: Const.cardTabSize,
                )),
                child: Column(
                  children: [
                    InkWell(
                        child: AlignPadding(
                            3.0, Alignment.center, getCardTitle()),
                        onTap: toggle,),
                    buildInput()
                  ],
                ))));
  }
}