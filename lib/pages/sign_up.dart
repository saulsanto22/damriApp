import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerNoBus = TextEditingController();

  // bool _tipoUsuario = false;
  // String _mensagemErro = "";
  bool _userType = false;
  String _messageError = "";

  Position? pos;

  _validateFields() {
    //recuperar dados dos campos
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    //validar campos
    if (name.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (password.isNotEmpty && password.length > 6) {
          FirebaseAuth auth = FirebaseAuth.instance;

          Users user = Users();
          // user.nome = name;
          // user.email = email;
          // user.senha = password;
          // user.tipoUsuario = user.verificaTipoUsuario(_userType);
          user.name = name;
          // user.idUser = auth.currentUser!.uid;

          user.email = email;
          user.password = password;
          user.userType = user.verifyUserTyoe(_userType);

          // user.latitude = getLocation();
          // user.longitude = pos.longitude;

          _registerUser(user);
        } else {
          setState(() {
            _messageError = "Isi kata sandi! masukkan lebih dari 6 karakter";
//           });
          });
        }
      } else {
        setState(() {
          _messageError = "Isi email yang valid";
        });
      }
    } else {
      setState(() {
        _messageError = "Isi Nama";
      });
    }
  }

  _registerUser(Users user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    auth
        .createUserWithEmailAndPassword(
      email: user.email!,
      password: user.password!,
    )
        .then((firebaseUser) {
      db.collection("users").doc(firebaseUser.user?.uid).set(user.toMap());

      //redireciona para o painel, de acordo com o tipoUsuario
      switch (user.userType) {
        case "pengemudi":
          Navigator.pushNamedAndRemoveUntil(
              context, "/panel-pengemudi", (_) => false);
          break;
        case "penumpang":
          Navigator.pushNamedAndRemoveUntil(
              context, "/panel-penumpang", (_) => false);
          break;
      }
    }).catchError((error) {
      _messageError =
          "Kesalahan mengautentikasi pengguna, periksa bidang dan coba lagi!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pendaftaran"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controllerName,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nama Lengkap",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                ),
                TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "e-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                ),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                ),
                TextField(
                  controller: _controllerNoBus,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nomor BUS",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Text("Penumpang"),
                      Switch(
                          value: _userType,
                          onChanged: (bool val) {
                            setState(() {
                              _userType = val;
                            });
                          }),
                      const Text("Pengemudi"),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 20, 62, 97),
                          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                      onPressed: () {
                        _validateFields();
                      },
                      child: const Text(
                        "Singn Up",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _messageError,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
