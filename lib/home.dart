import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/login.dart';
import 'package:flutter_chat/screens/tab_chat.dart';
import 'package:flutter_chat/screens/tab_contacts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> menuItem = ["Configurações", "Deslogar"];

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    _tabController = TabController(length: 2, vsync: this);
  }

  String? _emailUsuario;

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? loggedUser = await auth.currentUser;

    setState(() {
      _emailUsuario = loggedUser!.email;
    });
  }

  void _chooseMenuItem(String chooseItem) {
    switch(chooseItem){
      case "Configurações":
        Navigator.pushNamed(context, "/configurations");
        break;
      case "Deslogar":
        _userSignOut();
        break;
    }
  }

  void _userSignOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        bottom: TabBar(
          indicatorWeight: 4.0,
          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: "Conversas",
            ),
            Tab(
              text: "Contatos",
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _chooseMenuItem,
            itemBuilder: (context) {
              return menuItem.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TabChat(),
          TabContacts(),
        ],
      ),
    );
  }
}
