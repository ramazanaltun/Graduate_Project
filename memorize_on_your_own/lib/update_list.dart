import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memorize_on_your_own/model/word_model.dart';

import 'logins/loginPage.dart';

class UpdatePage extends StatefulWidget {
  String clickList, selectedTopic;

  UpdatePage(this.clickList, this.selectedTopic);

  @override
  _UpdatePageState createState() => _UpdatePageState(clickList, selectedTopic);
}

class _UpdatePageState extends State<UpdatePage> {
  String clickList, selectedTopic;

  _UpdatePageState(this.clickList, this.selectedTopic);

  List<WordModel> wordList = [];

  @override
  void initState() {
    // TODO: implement initState
    getWordData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
        height: MediaQuery.of(context).size.height - 20,
        width: MediaQuery.of(context).size.width - 20,
        child: ListView.builder(

            //Kelimelerin listelendiği yer
            //physics: NeverScrollableScrollPhysics(),//listenin kaymasını engeller
            //reverse: true,//elemanları terten listeler
            //scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: wordList.length,
            itemBuilder: (context, index) => Card(
                  color: index % 2 == 0 ? Colors.white : Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 1),
                        borderRadius: BorderRadius.circular(3)),
                    child: ListTile(
                      onTap: () {
                        debugPrint(wordList[index].toString());
                        alertDialogShow(wordList[index].word, wordList[index].explain);
                      },
                      onLongPress: () {
                        debugPrint(wordList.length.toString());
                      },
                      leading: Icon(
                        Icons.sticky_note_2,
                        color: Colors.green,
                      ),
                      title: Text(wordList[index].word),
                      subtitle: Text(wordList[index].explain),
                    ),
                  ),
                )),
      ),
    );
  }

  Widget alertDialogShow(String clickWord, String explain) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: clickWord,
                      ),
                      TextFormField(
                        initialValue: explain,
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.baseline,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {},
                        child: Text("Güncelle"),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text("Sil"),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future getWordData() async {
    DocumentSnapshot documentSnapshot =
        await firestore.doc("users/$userEMail/$selectedTopic/$clickList").get();
    wordList.clear();
    if (documentSnapshot.exists) {
      //bu döküman veri tabanında varmı sorusunu cevaplar

      documentSnapshot.data().forEach((key, value) {
        debugPrint("Anahtar: $key deger: $value");
        setState(() {
          wordList.add(WordModel(selectedTopic.toString(), clickList.toString(),
              key.toString(), value.toString()));
        });
      });
    } else {
      debugPrint("değer bulunamadı");
    }
  }
}
