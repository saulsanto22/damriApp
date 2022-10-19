// import 'package:flutter/material.dart';
// import '../model/User.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class Cadastro extends StatefulWidget {
//   const Cadastro({Key? key}) : super(key: key);

//   @override
//   State<Cadastro> createState() => _CadastroState();
// }

// class _CadastroState extends State<Cadastro> {
//   TextEditingController _controllerName = TextEditingController();
//   TextEditingController _controllerEmail = TextEditingController();
//   TextEditingController _controllerPassword = TextEditingController();
//   bool _typeUser = false;
//   String _errorMessage = "";

//   _validateFields() {
//     //recuperar dados dos campos
//     String nome = _controllerName.text;
//     String email = _controllerEmail.text;
//     String senha = _controllerPassword.text;

//     //validar campos
//     if (nome.isNotEmpty) {
//       if (email.isNotEmpty && email.contains("@")) {
//         if (senha.isNotEmpty && senha.length > 6) {
//           Users usuario = Users();
//           usuario.nome = nome;
//           usuario.email = email;
//           usuario.senha = senha;
//           usuario.tipoUsuario = usuario.verificaTipoUsuario(_typeUser);

//           _cadastrarUsuario(usuario);
//         } else {
//           setState(() {
//             _errorMessage = "Isi kata sandi! masukkan lebih dari 6 karakter";
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = "Isi email yang valid";
//         });
//       }
//     } else {
//       setState(() {
//         _errorMessage = "Isi Nama";
//       });
//     }
//   }

//   _cadastrarUsuario(Users usuario) {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     FirebaseFirestore db = FirebaseFirestore.instance;

//     try {
//       //kondisi true
//       auth
//           .createUserWithEmailAndPassword(
//         email: usuario.email!,
//         password: usuario.senha!,
//       )
//           .then((firebaseUser) {
//         db
//             .collection("usuarios")
//             .doc(firebaseUser.user?.uid)
//             .set(usuario.toMap());

//         //redireciona para o painel, de acordo com o tipoUsuario
//         switch (usuario.tipoUsuario) {
//           case "motorista":
//             Navigator.pushNamedAndRemoveUntil(
//                 context, "/painel-motorista", (_) => false);
//             break;
//           case "passageiro":
//             Navigator.pushNamedAndRemoveUntil(
//                 context, "/painel-passageiro", (_) => false);
//             break;
//         }
//       });
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         // print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Pendaftaran"),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextField(
//                   controller: _controllerName,
//                   autofocus: true,
//                   keyboardType: TextInputType.text,
//                   style: TextStyle(fontSize: 20),
//                   decoration: InputDecoration(
//                       contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
//                       hintText: "Nama Lengkap",
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       )),
//                 ),
//                 TextField(
//                   controller: _controllerEmail,
//                   keyboardType: TextInputType.emailAddress,
//                   style: TextStyle(fontSize: 20),
//                   decoration: InputDecoration(
//                       contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
//                       hintText: "e-mail",
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       )),
//                 ),
//                 TextField(
//                   controller: _controllerPassword,
//                   obscureText: true,
//                   keyboardType: TextInputType.emailAddress,
//                   style: TextStyle(fontSize: 20),
//                   decoration: InputDecoration(
//                       contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
//                       hintText: "Password",
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       )),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 10),
//                   child: Row(
//                     children: [
//                       Text("Penumpang"),
//                       Switch(
//                           value: _typeUser,
//                           onChanged: (bool valor) {
//                             setState(() {
//                               _typeUser = valor;
//                             });
//                           }),
//                       Text("Pengemudi"),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                     padding: EdgeInsets.only(top: 16, bottom: 10),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromARGB(255, 20, 62, 97),
//                           padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
//                       onPressed: () {
//                         _validateFields();
//                       },
//                       child: Text(
//                         "Singn Up",
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     )),
//                 Padding(
//                   padding: EdgeInsets.only(top: 16),
//                   child: Center(
//                     child: Text(
//                       _errorMessage,
//                       style: TextStyle(color: Colors.red, fontSize: 20),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool _typeUser = false;
  String _errorMessage = "";

  _validateFields() {
    //recuperar dados dos campos
    String nome = _controllerName.text;
    String email = _controllerEmail.text;
    String senha = _controllerPassword.text;

    //validar campos
    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length > 6) {
          Users user = Users();
          user.nama = nome;
          user.email = email;
          user.password = senha;
          user.userType = user.checkUserType(_typeUser);

          _registerUser(user);
        } else {
          setState(() {
            _errorMessage = "Isi kata sandi! masukkan lebih dari 6 karakter";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Isi email yang valid";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Isi Nama";
      });
    }
  }

  _registerUser(Users user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      //kondisi true
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
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pendaftaran"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controllerName,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text("Penumpang"),
                      Switch(
                          value: _typeUser,
                          onChanged: (bool valor) {
                            setState(() {
                              _typeUser = valor;
                            });
                          }),
                      Text("Pengemudi"),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 20, 62, 97),
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
                      onPressed: () {
                        _validateFields();
                      },
                      child: Text(
                        "Singn Up",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 20),
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
