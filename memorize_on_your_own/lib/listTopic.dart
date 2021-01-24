import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorize_on_your_own/exam.dart';
import 'package:memorize_on_your_own/update_list.dart';

import 'logins/loginPage.dart';

class ListTopic extends StatefulWidget {
  @override
  _ListTopicState createState() => _ListTopicState();
}

class _ListTopicState extends State<ListTopic> {
  List<String> categoryList = [
    "Kelime Ezberlerim",
    "Notlarım",
    "Unutulmayacaklar Listesi"
  ];
  String selectedCategory;

  List<String> titleList = [];
  bool infoNullData = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start, //düşeyde hizalama yapar
        //crossAxisAlignment: CrossAxisAlignment.stretch,

        children: <Widget>[
          DropdownButton<String>(
              items: categoryList.map((e) {
                return DropdownMenuItem<String>(
                  child: Text(e.toUpperCase()),
                  value: e,
                );
              }).toList(),
              hint: Text("Kategori Seçiniz:",style: TextStyle(color: Colors.green),),
              value: selectedCategory,
              icon: Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.green,),
              onChanged: (selected) {
                titleList.clear();
                setState(() {
                  selectedCategory = selected;
                  getTitleFromFireBase();
                });
              }),
          Visibility(
            child: Text(
                "Bu kategoride eklediğiniz başlık bulunmamaktadır.\nSözlük oluştur kısmından bir sözlük oluşturun."),
            visible: infoNullData,
          ),
          Expanded(
              child: Container(

            height: MediaQuery.of(context).size.height - 20,
            width: MediaQuery.of(context).size.width - 20,
            child: ListView.builder(
                //Kelimelerin listelendiği yer
                //physics: NeverScrollableScrollPhysics(),//listenin kaymasını engeller
                //reverse: true,//elemanları terten listeler
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: titleList.length,
                itemBuilder: (context, index) => Card(
                      color: index % 2 == 0 ? Colors.blue : Colors.pink,
                      child: ListTile(
                        onTap: () {
                          //debugPrint(wordList[index].toString());
                          alertShow(titleList[index]);
                        },
                        onLongPress: () {},
                        leading: Icon(Icons.title_sharp),
                        title: Text(titleList[index]),
                        //subtitle: Text(wordList[index].explain),
                      ),
                    )),
          ))
        ],
      ),
    );
  }

//Color(0x00000000) transparan color
  Widget alertShow(String clickTitle) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0x00000000),
            //title: Text("title"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                     // debugPrint("$clickTitle a basilddiiiiiiiiiiiiiii");
                     return Navigator.push(context, MaterialPageRoute(builder: (context)=>ExamPage(clickTitle,selectedCategory)));
                     //Sayfalar arası doğru geçiş bu şekildedir sadece materialPageroute ile sayfa değişikliği yapmaz
                    },
                    color: Colors.green,
                    child: Text(
                      "Sınavı Başlat",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      return Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdatePage(clickTitle,selectedCategory)));
                    },
                    color: Colors.green,
                    child: Text("Sözlüğü Düzenle",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future getTitleFromFireBase() async {
    firestore
        .collection("users/$userEMail/$selectedCategory")
        .get()
        .then((value) {
      debugPrint(value.docs.length.toString() + "kaçtane dokuman var");
      if (value.docs.length >= 1) {
        setState(() {
          infoNullData = false;
        });
      } else
        setState(() {
          infoNullData = true;
        });

      for (int i = 0; i < value.docs.length; i++) {
        debugPrint(value.docs[i].id.toString());
        setState(() {
          titleList.add(value.docs[i].id.toString());
        });
      }
    });
  }
}
