import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
String userName = "sdfsd";
String userEMail = "sfdsd";
String
    userPicture; //="https://media-exp1.licdn.com/dms/image/C4D03AQFo2Zxe51I_hg/profile-displayphoto-shrink_200_200/0/1589235038840?e=1613606400&v=beta&t=jHgCFAapmwTyFW46iR8qQyJapy1HN18w28bjdE_FZQY";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";
  final formkey = GlobalKey<FormState>();
  bool login = false;
  User _oturumAcanUser;

  Future girisID(String mail, String b) async {
    SharedPreferences _girilenid = await SharedPreferences.getInstance();
    SharedPreferences _sifre = await SharedPreferences.getInstance();
    SharedPreferences _name = await SharedPreferences.getInstance();
    SharedPreferences _login = await SharedPreferences.getInstance();
    firestore.collection("users/$mail").get().then((value)  {
      print("Kiişiniin adiii :  "+value.docs[0].toString());
    });
    _girilenid.setString("id", mail);
    _sifre.setString("sifre", b);
    _name.setString("uName", "Ramazan");
    _login.setBool("login", true);
    print(_girilenid.getString("id"));
  }
  Future googleLogin(String mail,String userName,String userPP) async{
    SharedPreferences _gelenMail=await SharedPreferences.getInstance();
    SharedPreferences _gelenName=await SharedPreferences.getInstance();
    SharedPreferences _gelenPP=await SharedPreferences.getInstance();
    SharedPreferences _login=await SharedPreferences.getInstance();
    _gelenMail.setString("mail", mail);
    _gelenName.setString("name", userName);
    _login.setBool("login", true);
    _gelenPP.setString("PP", userPP);
    print(_gelenName.getString("name"));
  }
  Future otoLoginGmail() async{
    SharedPreferences _gelenMail=await SharedPreferences.getInstance();
    SharedPreferences _gelenName=await SharedPreferences.getInstance();
    SharedPreferences _gelenPP=await SharedPreferences.getInstance();
    userEMail=_gelenMail.getString("mail");
    userName=_gelenName.getString("name");
    userPicture=_gelenPP.getString("PP");
    if(userName!=null && userEMail!=null){
      print("gmail girisi yapildi");
      signInWithGoogle();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    otoLoginGmail();
    otoLogin();
  }


  void otoLogin() async {
    SharedPreferences _girilenid = await SharedPreferences.getInstance();
    SharedPreferences _sifre = await SharedPreferences.getInstance();
    SharedPreferences _login = await SharedPreferences.getInstance();

    _email = _girilenid.getString("id");
    _password = _sifre.getString("sifre");
    login = _login.getBool("login");
    //firestore.collection("user").doc(_email).get().asStream().forEach((element) {print(element["adi"]);});
    try{
      await firestore.collection("users").doc(_email).get().then((value) {
        print("veriler alinmaya calişişrilişsid");
        setState(() {
          userName= value.data()["adi"].toString();
        });

        print(value.toString());

      });
    }catch(e){

    }

    if (_email != null && _password != null && login != false) {

      debugPrint("Giriş yapildi $_email  sifre: $_password");
      _emailOtoLogin();
    }

  }
void _emailOtoLogin() async{
  if (auth.currentUser == null) {
    //bu kullanıcının oturumu açık değilse oturum açar

    girisID(_email, _password);
    _oturumAcanUser = (await auth.signInWithEmailAndPassword(
    email: _email, password: _password))
      .user;
    userName=_oturumAcanUser.displayName.toString();
    userEMail=_email;
  if (_oturumAcanUser.photoURL.toString() != "null") {
  setState(() {
  userPicture = _oturumAcanUser.photoURL.toString();
  });
  }
  Navigator.pushNamed(context, "/testpage");
  } else {
  setState(() {
    userEMail=_email.toString();
    //userName= _oturumAcanUser.displayName.toString();
  });

  Navigator.pushNamed(context, "/testpage");
  debugPrint("oturum açmış kullanıcı zaten var $_email");
  }
}
  @override
  void dispose() {
    // TODO: implement dispose

    auth.signOut();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Giriş Yapınız",),
        ),
        body: pageBody());
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

  void _emailsifrgirisyap() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();

      if (auth.currentUser == null) {
        //bu kullanıcının oturumu açık değilse oturum açar
        girisID(_email, _password);
        User _oturumAcanUser = (await auth.signInWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        userEMail=_email;
        userName=_oturumAcanUser.displayName.toString();
        if (_oturumAcanUser.photoURL.toString() != "null") {
          setState(() {
            userPicture = _oturumAcanUser.photoURL.toString();
          });
        }
        Navigator.pushNamed(context, "/testpage");
      } else {
        auth.signOut();
        debugPrint("oturum açmış kullanıcı zaten var $_email");
      }
    }
  }

  Widget pageBody() {
    return Form(
      key: formkey,
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                //margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                alignment: Alignment.center,
                //color: Colors.amber,
                child: Expanded(child: Image.asset('assets/login_logo3.jpg')),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: _eMailKontrol,
                onSaved: (email) {
                  setState(() {
                    _email = email;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "Email",
                  labelText: "Email",
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
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true, //şifre girdisi
                onSaved: (sifre) {
                  setState(() {
                    _password = sifre;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Şifre",
                  //hintStyle: TextStyle(color: Colors.pink),
                  //fillColor: Colors.pink,
                  labelText: "şifre",
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
                validator: (String girilenDeger) {
                  if (girilenDeger.length < 8) {
                    return "Şifre 8 karekterden az olamaz";
                  } else
                    return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.all(10),
                    elevation: 12,
                    onPressed: _emailsifrgirisyap,
                    child: Text("Giriş Yap"),
                    color: Colors.white,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(10),
                    elevation: 6,
                    onPressed: () {
                      Navigator.pushNamed(context, '/SignInPage');
                    },
                    child: Text("Kaydol"),
                    color: Colors.white,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GoogleSignInButton(
                onPressed: signInWithGoogle,
                text: "Google ile giriş yap",
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      setState(() {
        userName = googleUser.displayName.toString();
        userEMail = googleUser.email.toString();
        userPicture = googleUser.photoUrl.toString();
      });

      addEmailAndName();
      googleLogin(userEMail, userName, userPicture);
      Navigator.pushNamed(context, '/testpage');
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString() + "Gmail Hatasııı");
      Fluttertoast.showToast(
          msg: "Gmail Giriş Hatası: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void addEmailAndName() {
    firestore.collection("users").doc(userEMail).set({
      'adi': '$userName',
    }).then((value) => debugPrint("Veriler Eklendi"));
  }
}
