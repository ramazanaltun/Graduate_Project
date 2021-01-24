import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(10),
      child: Container( decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1)),
        child: Text(
          "Şu anda yapılacak bir ayar yok lütfen güncellemeleri bekleyiniz veya lütfen İstek ve Şikayet kısmında belirtiniz.",
          style:TextStyle(fontSize: 18,),),
      ),
    );
  }
}
