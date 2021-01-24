import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorize_on_your_own/exam_result.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:math' as math;

import 'logins/loginPage.dart';
import 'model/word_model.dart';

class ExamPage extends StatefulWidget {
  String examTitle;
  String examTopic;

  ExamPage(this.examTitle, this.examTopic);

  @override
  _ExamPageState createState() => _ExamPageState(examTitle, examTopic);
}

class _ExamPageState extends State<ExamPage> {
  String examTitle;
  String examTopic;

  _ExamPageState(this.examTitle, this.examTopic);

  List<WordModel> examList = [];
  List<WordModel> examListUsage = [];
  int listSize;
  int truesize = 0, falseSize = 0;
  String questResultText = "Doğru cevap diğerine geçin";
  String question = " ";
  String currectAnswer;
  String button0 = "asd",
      button2 = "asdfas",
      button3 = "asdas",
      button4 = "asdas",
      button1 = "asdasda";
  int questionIndex = 0;
  List<String> randomAnswer = ["kalem", "silgi", "defter", "computer"];
  List<String> randomAsnwerUsage = [];
  Color trueFalse0 = Colors.black,
      trueFalse1 = Colors.black,
      trueFalse2 = Colors.black,
      trueFalse3 = Colors.black,
      trueFalse4 = Colors.black;
  bool questionDone = false;
  Timer timer;
  int _start = 2;
  double step=0;
  double stepValue;
  String stepStr="0";
  @override
  void initState() {
    // TODO: implement initState
    getDataFromFirebase();
    super.initState();
  }

  void refresh() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 1) {
                timer.cancel();
                questionIndex++;
                if (listSize > questionIndex) {
                  debugPrint(
                      listSize.toString() + "   " + questionIndex.toString());
                  startExam();
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ExamResult(examTitle, truesize, falseSize)));
                }
              } else {
                _start = _start - 1;
              }
            }));
    if((step+stepValue)>=1){
      step=1;
    }else{
      step+=stepValue;
      print("$step Step değeri");
      stepStr="$step".split('.')[1];
      if(stepStr.length==1){
        stepStr=stepStr[0]+"0";
      }else{
        stepStr=stepStr[0]+stepStr[1];
      }
      print(stepStr+" step seterşgdf");
    }

  }

  void startExam() async {
    questionDone = false;
    trueFalse0 = Colors.black;
    trueFalse1 = Colors.black;
    trueFalse2 = Colors.black;
    trueFalse3 = Colors.black;
    trueFalse4 = Colors.black;
    DocumentSnapshot documentSnapshot =
        await firestore.doc("users/$userEMail/$examTopic/$examTitle").get();
    examList.clear();
    if (documentSnapshot.exists) {
      //bu döküman veri tabanında varmı sorusunu cevaplar

      documentSnapshot.data().forEach((key, value) {
        debugPrint("Anahtar: $key deger: $value");
        setState(() {
          examList.add(WordModel(examTopic.toString(), examTitle.toString(),
              key.toString(), value.toString()));
        });
      });
    } else {
      debugPrint("değer bulunamadı");
    }
    examListUsage = examList;
    randomAsnwerUsage = randomAnswer;
    question = examList[questionIndex].word;
    currectAnswer = examList[questionIndex].explain;

    //int sa=examListUsage.length;
    int indexT1 = math.Random().nextInt(examListUsage.length);
    button0 = examListUsage[indexT1].explain;
    examListUsage.removeAt(indexT1);
    if (examListUsage.length < 0) {
      int index2 = math.Random().nextInt(randomAsnwerUsage.length);
      button1 = randomAsnwerUsage[index2];
      randomAsnwerUsage.removeAt(index2);
      int index3 = math.Random().nextInt(randomAsnwerUsage.length);
      button2 = randomAsnwerUsage[index3];
      randomAsnwerUsage.removeAt(index3);
      int index4 = math.Random().nextInt(randomAsnwerUsage.length);
      button3 = randomAsnwerUsage[index4];
      randomAsnwerUsage.removeAt(index4);
      int index5 = math.Random().nextInt(randomAsnwerUsage.length);
      button4 = randomAsnwerUsage[index5];
      randomAsnwerUsage.removeAt(index5);
    } else {
      int indexT2 = math.Random().nextInt(examListUsage.length);
      button1 = examListUsage[indexT2].explain;
      examListUsage.removeAt(indexT2);
    }
    if (randomAsnwerUsage.length < 4) {
    } else {
      int indexT3 = math.Random().nextInt(examListUsage.length);
      button2 = examListUsage[indexT3].explain;
      examListUsage.removeAt(indexT3);
    }
    if (examListUsage.length <= 0) {
      int index4 = math.Random().nextInt(randomAsnwerUsage.length);
      button3 = randomAsnwerUsage[index4];
      randomAsnwerUsage.removeAt(index4);
      int index5 = math.Random().nextInt(randomAsnwerUsage.length);
      button4 = randomAsnwerUsage[index5];
      randomAsnwerUsage.removeAt(index5);
    } else {
      int indexT4 = math.Random().nextInt(examListUsage.length);
      button3 = examListUsage[indexT4].explain;
      examListUsage.removeAt(indexT4);
    }
    if (randomAsnwerUsage.length < 4) {
    } else {
      int indexT5 = math.Random().nextInt(examListUsage.length);
      button4 = examListUsage[indexT5].explain;
      examListUsage.removeAt(indexT5);
    }

    debugPrint(
        " button1: $button0  button2: $button1  button3: $button2 button4: $button3 button5: $button4");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).size.height -
                (MediaQuery.of(context).size.height - 50),
            0,
            0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, //dikey hizalama yapar
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 80,
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2500,
                    percent: step,
                    center: Text("$stepStr%"),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.green,
                  ),
                ),
                Expanded(
                    child: IconButton(onPressed:(){
                      Navigator.of(context).popUntil(ModalRoute.withName('/testpage'));
                    },
                        icon: Icon(
                  Icons.close,
                  color: Colors.red,
                )))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("Aşağıdaki kelimenin anlamını seçiniz"),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                question,
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //aralarında boşluk bırakarak hizalar
              children: <Widget>[
                ButtonTheme(
                    minWidth: 120,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: trueFalse3, width: 2.5)),
                        child: Text(button3),
                        onPressed: () {
                          if (button3 == currectAnswer) {
                            setState(() {
                              trueFalse3 = Colors.blue;
                              truesize++;
                              questResultText =
                                  "Tebrikler. Doğru cevap diğer soruya geçiliyor..";
                              questionDone = true;
                            });
                          } else {
                            setState(() {
                              falseSize++;
                              trueFalse3 = Colors.red;
                              questResultText =
                                  "Üzgünüm. Yanlış cevap diğer soruya geçiliyor..\nDoğru Cevepa: $currectAnswer";
                              questionDone = true;
                            });
                          }
                          refresh();
                        })),
                ButtonTheme(
                    minWidth: 120,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.green[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: trueFalse2, width: 2.5)),
                        child: Text(button2),
                        onPressed: () {
                          if (button2 == currectAnswer) {
                            setState(() {
                              trueFalse2 = Colors.blue;
                              truesize++;
                              questResultText =
                                  "Tebrikler. Doğru cevap diğer soruya geçiliyor..";
                              questionDone = true;
                            });
                          } else {
                            setState(() {
                              falseSize++;
                              trueFalse2 = Colors.red;
                              questResultText =
                                  "Üzgünüm. Yanlış cevap diğer soruya geçiliyor..\nDoğru Cevepa: $currectAnswer";
                              questionDone = true;
                            });
                          }
                          refresh();
                        })),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                    minWidth: 120,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.red[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: trueFalse0, width: 2.5)),
                        child: Text(button0),
                        onPressed: () {
                          if (button0 == currectAnswer) {
                            setState(() {
                              trueFalse0 = Colors.blue;
                              truesize++;
                              questResultText =
                                  "Tebrikler. Doğru cevap diğer soruya geçiliyor..";
                              questionDone = true;
                            });
                          } else {
                            setState(() {
                              falseSize++;
                              trueFalse0 = Colors.red;
                              questResultText =
                                  "Üzgünüm. Yanlış cevap diğer soruya geçiliyor..\nDoğru Cevepa: $currectAnswer";
                              questionDone = true;
                            });
                          }
                          refresh();
                        })),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonTheme(
                    minWidth: 120,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.cyan[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: trueFalse1, width: 2.5)),
                        child: Text(button1),
                        onPressed: () {
                          if (button1 == currectAnswer) {
                            setState(() {
                              trueFalse1 = Colors.blue;
                              truesize++;
                              questResultText =
                                  "Tebrikler. Doğru cevap diğer soruya geçiliyor..";
                              questionDone = true;
                            });
                          } else {
                            setState(() {
                              falseSize++;
                              trueFalse1 = Colors.red;
                              questResultText =
                                  "Üzgünüm. Yanlış cevap diğer soruya geçiliyor..\nDoğru Cevepa: $currectAnswer";
                              questionDone = true;
                            });
                          }
                          refresh();
                        })),
                ButtonTheme(
                    minWidth: 120,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: trueFalse4, width: 2.5)),
                        child: Text(button4),
                        onPressed: () {
                          if (button4 == currectAnswer) {
                            setState(() {
                              trueFalse4 = Colors.blue;
                              truesize++;
                              questResultText =
                                  "Tebrikler. Doğru cevap diğer soruya geçiliyor..";
                              questionDone = true;
                            });
                          } else {
                            setState(() {
                              falseSize++;
                              trueFalse4 = Colors.red;
                              questResultText =
                                  "Üzgünüm. Yanlış cevap diğer soruya geçiliyor..\nDoğru Cevepa: $currectAnswer";
                              questionDone = true;
                            });
                          }
                          refresh();
                        })),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Visibility(
              visible: questionDone,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Text(questResultText),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future getDataFromFirebase() async {
    DocumentSnapshot documentSnapshot =
        await firestore.doc("users/$userEMail/$examTopic/$examTitle").get();
    examList.clear();
    if (documentSnapshot.exists) {
      //bu döküman veri tabanında varmı sorusunu cevaplar

      documentSnapshot.data().forEach((key, value) {
        debugPrint("Anahtar: $key deger: $value");
        setState(() {
          examList.add(WordModel(examTopic.toString(), examTitle.toString(),
              key.toString(), value.toString()));
        });
      });
    } else {
      debugPrint("değer bulunamadı");
    }

    listSize = examList.length;
    if(listSize!=0){
      stepValue= (100/listSize)/100;
    }

    startExam();
  }
}
