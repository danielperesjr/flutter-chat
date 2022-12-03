import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Configurations extends StatefulWidget {
  const Configurations({Key? key}) : super(key: key);

  @override
  State<Configurations> createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  dynamic _image;
  bool _isUploading = false;
  String? _idLoggedUser;
  String? _imageUrl;
  TextEditingController controllerName = TextEditingController();

  Future _recoverImage(String sourceImage) async {
    final ImagePicker picker = ImagePicker();
    XFile? selectedImage;

    switch (sourceImage) {
      case "camera":
        selectedImage = await picker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        selectedImage = await picker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _image = File(selectedImage!.path);
      if (_image != null) {
        _isUploading = true;
        _imageUpload();
      }
    });
  }

  Future _imageUpload() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference rootFolder = storage.ref();
    Reference file = rootFolder.child("profile").child("$_idLoggedUser.jpg");

    UploadTask task = file.putFile(_image);

    task.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.running) {
        setState(() {
          _isUploading = true;
        });
      } else if (taskSnapshot.state == TaskState.success) {
        _recoverImageUrl(taskSnapshot);
        setState(() {
          _isUploading = false;
        });
      }
    });
  }

  void _recoverUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? loggedUser = auth.currentUser;
    _idLoggedUser = loggedUser!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("users")
        .doc(_idLoggedUser)
        .get();

    dynamic userData = await snapshot.data();
    controllerName.text = userData["name"];

    setState(() {
      _imageUrl = userData["url"];
    });
  }

  Future _recoverImageUrl(TaskSnapshot taskSnapshot) async {
    String url = await taskSnapshot.ref.getDownloadURL();
    _updateImageUrlFirestore(url);

    setState(() {
      _imageUrl = url;
    });
  }

  void _updateImageUrlFirestore(String imageUrl) {
    Map<String, dynamic> updateData = {
      "url": imageUrl
    };

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("users").doc(_idLoggedUser).update(updateData);
  }

  @override
  void initState() {
    super.initState();
    _recoverUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(16.0),
                    child: _isUploading
                        ? CircularProgressIndicator()
                        : Container(),
                ),
                CircleAvatar(
                  radius: 100.0,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                  _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () => _recoverImage("camera"),
                      child: Text("Câmera"),
                    ),
                    MaterialButton(
                      onPressed: () => _recoverImage("galeria"),
                      child: Text("Galeria"),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: controllerName,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 10.0),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "Salvar",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
