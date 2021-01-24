import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memorize_on_your_own/logins/loginPage.dart';

class SuggesPage extends StatefulWidget {
  @override
  _SuggesPageState createState() => _SuggesPageState();
}

class _SuggesPageState extends State<SuggesPage> {
  List<String> suggesCategory = ["Şikayet", "Öneri"];
  String selectedCategory;
  final suggesFormKey = GlobalKey<FormState>();
  String suggesText;
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String suggesTime= dateTime.toLocal().toString().split(' ')[0];

    return Container(
      alignment: Alignment.center,
      child: Form(
        key: suggesFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DropdownButton<String>(
                hint: Text("Başlık Seçiniz: ",style: TextStyle(color: Colors.green),),
                value: selectedCategory,
                icon: Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Colors.green,
                ),
                items: suggesCategory.map((e) {
                  return DropdownMenuItem<String>(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                onChanged: (selectedItem) {
                  setState(() {
                    selectedCategory = selectedItem;
                  });
                }),
            Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Metin Giriniz",
                    labelText: "Metin",
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .green), /* burda ayrıca border renklerini değiştirebiliriz değiştirmediğimiz durumda primarySwatch tan alır*/
                    ),
                  ),
                  onSaved: (inputedValue) {
                    suggesText = inputedValue;
                  },
                  validator: (String inputedText) {
                    if (inputedText.length < 10)
                      return "Metim 10 karaterden az olamaz\nLütfen açıklayınız";
                    else
                      return null;
                  },
                )),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                child: Text("Gönder",style: TextStyle(color: Colors.green),),
                onPressed: () {
                  if (selectedCategory == null) {
                    FocusScope.of(context).requestFocus(new FocusNode()); //klavyeyi kapatır
                    Fluttertoast.showToast(msg: "Lütfen Bir Başlık Seçiniz!",toastLength: Toast.LENGTH_SHORT,backgroundColor: Colors.red);
                  }else{
                    if(suggesFormKey.currentState.validate()){
                      suggesFormKey.currentState.save();
                      FocusScope.of(context).requestFocus(new FocusNode());
                      String docsName=selectedCategory+ " :" +suggesTime;
                      firestore.collection("Suggestions").doc(userEMail).set({'$docsName':'$suggesText'},SetOptions(merge: true));
                      Fluttertoast.showToast(msg: "İsteğiniz Başarıyla Gönderildi");
                    }
                  }
                })
          ],
        ),
      ),
    );
  }
}
