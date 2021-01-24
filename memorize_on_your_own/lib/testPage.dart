import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memorize_on_your_own/logins/loginPage.dart';
import 'package:memorize_on_your_own/suggesPage.dart';
import 'listTopic.dart';
import 'model/word_model.dart';
import 'setting.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String appBarTitle="Sözlük Ekle"; //sayfa geçişlerinde AppBarin ismini değiştirmek için
  int _start=1; // Timer başlangın zamanı
  Timer timer;
  Widget stateForBody; //Drawer üzerinden sayfa geçişleri yapabilmesi için Scaffoldun Body kismini değişmesi için
  bool _visible; //floatinActionButton görünürlüğü için
  final _formKey = GlobalKey<FormState>();
  String selectedTopic;
  String addedTitle = "dasda";
  String addedWord = "sjfjsd";
  String addedWordExplain = "hsdf";
  String dropdownValue=null;
  List<WordModel> wordList = [];
  DateTime backButtonOnPressedTime;
  @override
  void initState() {
    _visible = true; //floattinactionbutton un ilk gönürlüğünü belirtiyor
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        stateForBody = BodyPage();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //wordListTest.add(WordModel("dfsf", "asfsf", "fsd", "asf"));
    return Scaffold(
      drawer: DraverMenu(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: new Visibility(
          visible: _visible,
          child: FloatingActionButton(
            child: Icon(Icons.add_comment_outlined),
            onPressed: () {
              setState(() {
                if (selectedTopic != null) {
                  if (_formKey.currentState.validate()) {
                    //dropdownmenü değeri null olmaması için(null olduğunda hata verir)
                    _formKey.currentState.save();
                    firestore
                        .collection("users")
                        .doc(userEMail)
                        .collection(selectedTopic)
                        .doc(addedTitle)
                        .set({'$addedWord': '$addedWordExplain'},
                            SetOptions(merge: true));
                    getDataFromFirebase();
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Lütfen bir kategori",
                      toastLength: Toast.LENGTH_SHORT);
                }

                debugPrint(selectedTopic.toString() +
                    "   " +
                    addedTitle.toString() +
                    "  " +
                    addedWord.toString() +
                    "  " +
                    addedWordExplain.toString());

                refresh();
              });
            },
          )),
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: WillPopScope(onWillPop: doubleClickExit,child: stateForBody),
    );
  }
  Future<bool> doubleClickExit() async{
  DateTime currentTime=DateTime.now();

  bool backButton=backButtonOnPressedTime==null||currentTime.difference(backButtonOnPressedTime)> Duration(seconds: 2);

  if(backButton){
    backButtonOnPressedTime=currentTime;
    Fluttertoast.showToast(msg: "Çıkmak için iki defa basınız");
    return false;
  }
  SystemNavigator.pop(); //uygulamayi kapatir
  //return true;
  }
  void refresh() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
        oneSec,
    (Timer timer) => setState(() {
      if (_start < 1) {
        timer.cancel();
        stateForBody = BodyPage();
      }
      else {
        _start = _start - 1;
      }
    }));

  }
  Widget BodyPage() {
    return GestureDetector(
      /* Body'i gesturedetectore nin içine alma sebebim boş yere tıklayınca kılavyenin kapanmasını istediğimden. gesturedetectorenini behaviore
        * özelliğine HitTestBehavior.opaque atayıp onTap özelliğine ise klavyeyi kapamasını atadım */
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1),
                    borderRadius: BorderRadius.circular(3)),
                child: DropdownButton<String>(
                  icon: Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.green,),
                  hint: Text("Kategori seçiniz:",style: TextStyle(color: Colors.green),),
                  isDense: true,
                  value: selectedTopic,
                  items: [
                    DropdownMenuItem<String>(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add_comment_outlined,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text("Kelime Ezberlerim"),
                        ],
                      ),
                      value: "Kelime Ezberlerim",
                    ),
                    DropdownMenuItem<String>(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.sticky_note_2_outlined,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text("Notlarım"),
                        ],
                      ),
                      value: "Notlarim",
                    ),
                    DropdownMenuItem<String>(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.alarm_on,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text("Unutulmayacaklar Listesi"),
                        ],
                      ),
                      value: "Unutulmayacaklar Listesi",
                    ),
                  ],
                  onChanged: (String secilen) {
                    setState(() {
                      selectedTopic = secilen;
                      wordList.clear();
                      stateForBody = BodyPage();
                    });
                  },
                  //bu verilen stringi arayüzde gösterir
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: "Başlık",
                    labelText: "Başlık Giriniz",
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
                  onChanged: (String deger) {
                    setState(() {
                      addedTitle = deger;
                    });
                  },
                  validator: (String girilenDeger) {
                    if (girilenDeger.length < 1) {
                      debugPrint(girilenDeger + "girilen değer başlık");
                      return "Konu başlığı boş geçilemez";
                    } else
                      return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                    hintText: "Kelime",
                    labelText: "Kelime Giriniz",
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
                  onChanged: (String deger) {
                    setState(() {
                      addedWord = deger;
                    });
                  },
                  validator: (String girilenDeger) {
                    if (girilenDeger.length < 1) {
                      return "kelime giriniz";
                    } else
                      return null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                    hintText: "Açıklama",
                    labelText: "Kelime'in Açıklmasını giriniz",
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
                  onChanged: (String deger) {
                    setState(() {
                      addedWordExplain = deger;
                    });
                  },
                  validator: (String girilenDeger) {
                    if (girilenDeger.length < 1) {
                      return "Açıklama Giriniz";
                    } else
                      return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
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
                    itemCount: wordList.length,
                    itemBuilder: (context, index) => Card(
                          color: index % 2 == 0 ? Colors.blue : Colors.pink,
                          child: ListTile(
                            onTap: () {
                              debugPrint(wordList[index].toString());
                            },
                            onLongPress: () {
                              debugPrint(wordList.length.toString());
                            },
                            leading: Icon(Icons.sticky_note_2),
                            title: Text(wordList[index].word),
                            subtitle: Text(wordList[index].explain),
                          ),
                        )),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future getDataFromFirebase() async {
    DocumentSnapshot documentSnapshot = await firestore
        .doc("users/$userEMail/$selectedTopic/$addedTitle")
        .get();
    wordList.clear();
    if (documentSnapshot.exists) {
      //bu döküman veri tabanında varmı sorusunu cevaplar

      documentSnapshot.data().forEach((key, value) {
        debugPrint("Anahtar: $key deger: $value");
        setState(() {
          wordList.add(WordModel(selectedTopic.toString(),
              addedTitle.toString(), key.toString(), value.toString()));
        });
        //kompak bir algoritma
        /*  for (int i = wordList.length; i < documentSnapshot.data().length; i++) {
      debugPrint(documentSnapshot.data().keys.toList()[i].toString() +
          "gelen değerler");
      debugPrint(documentSnapshot.data().values.toList()[i].toString() +
          "gelen değerler");
    }*/
      });
    } else {
      debugPrint("değer bulunamadı");
    }
  }

  Drawer DraverMenu() {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEMail),
            //currentAccountPicture: Image.network(userPicture),
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Sözlük Oluştur"),
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                    _visible = true;
                    stateForBody = BodyPage();
                    appBarTitle="Sözlük Oluştur";
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.sticky_note_2_outlined),
                title: Text("Ezber Listem"),
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                    _visible = false;
                    stateForBody = ListTopic();
                    appBarTitle="Ezber Listem";
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.add_comment),
                title: Text("Şikayet ve İstek"),
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                    _visible = false;
                    stateForBody = SuggesPage();
                    appBarTitle="Şikayet ve İstek";
                  });
                },
              ),
              Divider(
                height: 64,
                thickness: 0.5,
                color: Colors.white.withOpacity(0.3),
                indent: 32,
                endIndent: 32,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Ayarlar"),
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                    _visible=false;
                    stateForBody=SettingPage();
                    appBarTitle="Ayarlar";
                  });

                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Çıkış Yap"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  auth.signOut();
                },
              )
            ],
          ))
        ],
      ),
    );
  }
}
