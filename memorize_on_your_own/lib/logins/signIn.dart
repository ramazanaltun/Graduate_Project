import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _adSoyad, _eMailAdress, _sifre,_sifreOnay;
  final formkey = GlobalKey<FormState>();
  bool textKontrol = false;
  String secilenCinsiyet = "Belirsiz";
  List<String> cinsiyet = ["Belirsiz", "Kadın", "Erkek"];
  DateTime dTarih = DateTime.now();
  FirebaseAuth _auth = FirebaseAuth.instance;
  LoginPage loginPage=LoginPage();





  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt İşlemleri"),
      ),
      body: bodyPage(),
    );
  }

Widget bodyPage(){
    return Container(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: formkey,
          autovalidateMode: AutovalidateMode.disabled,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  hintText: "Ad ve Soyad",
                  //hintStyle: TextStyle(color: Colors.pink),
                  fillColor: Colors.pink,
                  labelText: "Ad-Soyad",
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .green), /* burda ayrıca border renklerini değiştirebiliriz değiştirmediğimiz durumda primarySwatch tan alır*/
                  ),
                ),
                validator: (String girilenDeger) {
                  if (girilenDeger.length < 5) {
                    return "Ad Soyad 5 karekterden küçük olamaz";
                  } else
                    return null;
                },
                onSaved: (deger) => _adSoyad = deger,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.green),
                    borderRadius: BorderRadius.circular(3)),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text("Cinsiyet :"),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    ),
                    DropdownButton<String>(
                      items: cinsiyet.map((e) {
                        return DropdownMenuItem<String>(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (selected) {
                        setState(() {
                          secilenCinsiyet = selected;
                        });
                      },
                      value: secilenCinsiyet,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(3)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () => _selectDate(context), // Refer step 3
                      child: Text(
                        'Doğum Tarihinizi Giriniz',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.green.shade400,
                    ),
                    Text(
                      "${dTarih.toLocal()}".split(' ')[0],
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: _eMailKontrol,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "Email",
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .green), /* burda ayrıca border renklerini değiştirebiliriz değiştirmediğimiz durumda primarySwatch tan alır*/
                  ),
                ),
                onSaved: (deger) => _eMailAdress = deger,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true, //şifre girdisi
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Şifre",
                    //hintStyle: TextStyle(color: Colors.pink),
                    fillColor: Colors.pink,
                    labelText: "şifre",
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder()),
                validator: (String girilenDeger) {
                  _sifre=girilenDeger;
                  if (girilenDeger.length < 8) {

                    return "Şifre 8 karekterden küçük olamaz";
                  } else
                    debugPrint("Şifrenin girilen değeri: $girilenDeger _sifre: $_sifre");
                  return null;
                },
                onSaved: (deger) => _sifre = deger,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true, //şifre girdisi
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Şifreni Onayla",
                    //hintStyle: TextStyle(color: Colors.pink),
                    fillColor: Colors.pink,
                    labelText: "şifre onayla",
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder()),
                validator: (String girilenDeger) {

                  if (girilenDeger.length >= 8) {
                    if(girilenDeger!=_sifre){
                      debugPrint("Girilen değer: $girilenDeger _sifre: $_sifre");
                      return "Şifreniz Uyuşmuyor";
                    }else{
                      return null;
                    }

                  }else
                    return "Şifre 8 karekterne Küçük olamaz";
                },
                onSaved: (deger) => _sifreOnay = deger,
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton.icon(
                icon: Icon(Icons.save),
                label: Text("KAYDET"),
                color: Colors.green.shade100,
                onPressed: _girilenBilgileriAl,
              )
            ],
          ),
        ),
      ),
    );
}
  void _girilenBilgileriAl() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      debugPrint(
          "Girilen mail:$_eMailAdress Şifresi: $_sifre AdSoyad: $_adSoyad");
      _emailsifreolustur();
    }
  }
  void kullaniciBilgilendir(String email){
    showDialog(context: context, barrierDismissible: false, builder: (context) {
      return AlertDialog(title: Text("Önemli!"),
        content: Text(
            "Hesabınızı aktif etmeniz için \n$email adresinize mail attık \nlütfen mail'inizi kontrol edin"),
        actions: [
          FlatButton(onPressed: () {
            //Navigator.pushNamed(context, '/LoginPage');
            Navigator.of(context).popUntil(ModalRoute.withName('/LoginPage'));
            //Navigator.of(context).pop(); //bir önceki sayfaya gitmek için
          }, child: Text("anladım"))
        ],);
    },);
  }
  String _eMailKontrol(String email) {
    Pattern pattern =
        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email))
      return "Geçersiz Email";
    else
      return null;
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dTarih, // Refer step 1
        firstDate: DateTime(1940),
        lastDate: DateTime.now());
    if (picked != null && picked != dTarih)
      setState(() {
        dTarih = picked;
      });
  }
  void addEmailAndName() {
    firestore.collection("users").doc(_eMailAdress.toString()).set({
      'adi': '$_adSoyad',
    }).then((value) => debugPrint("isim eklendi"));
  }
  void _emailsifreolustur() async {
    try {

      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: _eMailAdress, password: _sifreOnay);
      User _newUser = _credential.user;
      await _newUser.sendEmailVerification();
      if (_auth.currentUser != null) {
        addEmailAndName();
        kullaniciBilgilendir(_eMailAdress);
        debugPrint("size bir emaail attık lütfen hesabınızı onaylayın");
        await _auth.signOut();
        debugPrint("kullanıcıyı sistemden attık");
      }
      _auth.authStateChanges().listen((User user) {
        if (user == null) {
          debugPrint('**********Kullanıcı Çıkış Yaptı!****************');
        } else {
          print(
              '*********************Kullanıcı Sistemde Online!************************');
        }
      });

      debugPrint(_newUser.toString());
    } catch (e) {
      debugPrint("************ Hata Var*********[firebase_auth/emaıl-already-ın-use] The email address is already in use by another account.");
      if(e.toString()=="[firebase_auth/emaıl-already-ın-use] The email address is already in use by another account."){
        Fluttertoast.showToast(
            msg: "Mail Giriş Hatası: Bu Mail zaten kullanılıyor \nbaşka bir Mail deneyin ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0

        );
      }

      debugPrint(e.toString());
    }
  }
}
