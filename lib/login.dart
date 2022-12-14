import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/register.dart';

import 'home.dart';
import 'model/chat_user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  String msgError = "";

  void _validarCampos() {
    String email = controllerEmail.text;
    String pass = controllerPass.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (pass.isNotEmpty) {
        setState(() {
          msgError = "";
        });
        ChatUser user = ChatUser();
        user.email = email;
        user.pass = pass;
        _loginUser(user);
      } else {
        setState(() {
          msgError = "Preencha a senha!";
        });
      }
    } else {
      setState(() {
        msgError = "Preencha o e-mail corretamente!";
      });
    }
  }

  void _loginUser(ChatUser user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: user.email, password: user.pass)
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, "/home");
    }).catchError((error) {
      setState(() {
        msgError =
            "Erro ao autenticar o usuário, verifique os dados e tente novamente.";
      });
    });
  }

  Future _verifyLoggedUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? loggedUser = await auth.currentUser;
    if (loggedUser != null) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  void initState() {
    _verifyLoggedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffe1f5fe),
        ),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FlutterLogo(
                  size: 145,
                  style: FlutterLogoStyle.markOnly,
                  curve: Curves.bounceInOut,
                  duration: Duration(seconds: 5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                      child: Text(
                        "Flutter Chat",
                        style: TextStyle(fontSize: 36, color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: controllerPass,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                    hintText: "Senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 10.0),
                  child: MaterialButton(
                    onPressed: () => _validarCampos(),
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    color: Colors.lightBlue,
                    padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: GestureDetector(
                      child: Text(
                        "Ainda não possui conta? Cadastre-se!",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Text(
                      msgError,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
