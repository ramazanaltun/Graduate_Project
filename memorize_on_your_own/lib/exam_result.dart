import 'package:flutter/material.dart';

class ExamResult extends StatelessWidget {
  String examTitle;
  int trueResult;
  int falseResult;
  ExamResult(this.examTitle,this.trueResult,this.falseResult);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$examTitle Sınavı Sonucu"),),
        body: Container(
          alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Text("Doğru Sayısı: $trueResult"),
          SizedBox(height: 5,),
          Text("Yanlış Sayısı: $falseResult"),
        SizedBox(height: 50,),
          RaisedButton(child: Text("Ana Sayfaya Dön"),onPressed: (){
            Navigator.of(context).popUntil(ModalRoute.withName('/testpage'));
          })
        ],
      ),
    ));
  }
}
