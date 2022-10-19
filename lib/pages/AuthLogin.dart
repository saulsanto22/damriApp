// import 'package:flutter/material.dart';
// import '../model/User.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   TextEditingController _controllerEmail = TextEditingController(text: "Email");
//   TextEditingController _controllerPassword =
//       TextEditingController(text: "Password..");
//   String _errorMessage = "";
//   bool _loading = false;

//   _validateFields() {
//     _errorMessage = "";
//     //recuperar dados dos campos
//     String email = _controllerEmail.text;
//     String password = _controllerPassword.text;

//     //validar campos
//     if (email.isNotEmpty && email.contains("@")) {
//       if (password.isNotEmpty && password.length > 6) {
//         Users user = Users();
//         user.email = email;
//         user.senha = password;

//         _loginUser(usuario);
//       } else {
//         setState(() {
//           _errorMessage = "Isi kata sandi! ketik lebih dari 6 karakter";
//         });
//       }
//     } else {
//       setState(() {
//         _errorMessage = "Isi email yang valid!";
//       });
//     }
//   }

//   _loginUser(Users usuario) {
//     setState(() {
//       _loading = true;
//     });

//     FirebaseAuth auth = FirebaseAuth.instance;

//     auth
//         .signInWithEmailAndPassword(
//             email: usuario.email!, password: usuario.senha!)
//         .then((firebaseUser) {
//       _redirectPanelByUserType(firebaseUser.user!.uid);
//     }).catchError((error) {
//       setState(() {
//         _loading = false;
//         _errorMessage =
//             "Terjadi kesalahan saat mengautentikasi pengguna, periksa email dan sandi, lalu coba lagi!";
//       });
//     });
//   }

//   // validation
//   //  cek username ,email kalo sudah ada
//   //  cek jika semua kolom kosong atau salah satu kosong
//   // cek jika password terlalu lemah

//   _redirectPanelByUserType(String idUsuario) async {
//     FirebaseFirestore db = FirebaseFirestore.instance;

//     DocumentSnapshot snapshot =
//         await db.collection("usuarios").doc(idUsuario).get();

//     dynamic data = snapshot.data();

//     String typeUser = data["tipoUsuario"];
//     print("$data");

//     setState(() {
//       _loading = false;
//     });

//     switch (typeUser) {
//       case "motorista":
//         Navigator.pushReplacementNamed(context, "/painel-motorista");
//         break;
//       case "passageiro":
//         Navigator.pushReplacementNamed(context, "/painel-passageiro");
//         break;
//     }
//   }

//   _checkUserLoggedin() async {
//     FirebaseAuth auth = FirebaseAuth.instance;

//     User? userInLogged = await auth.currentUser;
//     if (userInLogged != null) {
//       String idUser = userInLogged.uid;
//       _redirectPanelByUserType(idUser);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _checkUserLoggedin();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 32),
//                   child: Image.asset(
//                     "imagens/logo1.png",
//                     width: 200,
//                     height: 150,
//                   ),
//                 ),
//                 TextField(
//                   controller: _controllerEmail,
//                   autofocus: true,
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
//                     padding: EdgeInsets.only(top: 16, bottom: 10),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromARGB(255, 20, 62, 97),
//                           padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
//                       onPressed: () {
//                         _validateFields();
//                       },
//                       child: Text(
//                         "Login",
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     )),
//                 Center(
//                   child: GestureDetector(
//                     child: Text(
//                       "Belum punya akun? Registrasi!",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     onTap: () {
//                       Navigator.pushNamed(context, "/cadastro");
//                     },
//                   ),
//                 ),
//                 _loading
//                     ? Padding(
//                         padding: EdgeInsets.only(top: 16),
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             backgroundColor: Colors.white,
//                           ),
//                         ))
//                     : Container(),
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

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController(text: "Email");
  TextEditingController _controllerPassword =
      TextEditingController(text: "Password..");
  String _errorMessage = "";
  bool _loading = false;

  _validateFields() {
    _errorMessage = "";
    //recuperar dados dos campos
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    //validar campos
    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length > 6) {
        Users user = Users();
        user.email = email;
        user.password = password;

        _loginUser(user);
      } else {
        setState(() {
          _errorMessage = "Isi kata sandi! ketik lebih dari 6 karakter";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Isi email yang valid!";
      });
    }
  }

  _loginUser(Users user) {
    setState(() {
      _loading = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: user.email!, password: user.password!)
        .then((firebaseUser) {
      _redirectPanelByUserType(firebaseUser.user!.uid);
    }).catchError((error) {
      setState(() {
        _loading = false;
        _errorMessage =
            "Terjadi kesalahan saat mengautentikasi pengguna, periksa email dan sandi, lalu coba lagi!";
      });
    });
  }

  // validation
  //  cek username ,email kalo sudah ada
  //  cek jika semua kolom kosong atau salah satu kosong
  // cek jika password terlalu lemah

  _redirectPanelByUserType(String idUser) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await db.collection("users").doc(idUser).get();

    dynamic data = snapshot.data();

    String typeUser = data["tipeUser"];
    print("$data");

    setState(() {
      _loading = false;
    });

    switch (typeUser) {
      case "pengemudi":
        Navigator.pushReplacementNamed(context, "/panel-pengemudi");
        break;
      case "penumpang":
        Navigator.pushReplacementNamed(context, "/panel-penumpang");
        break;
    }
  }

  _checkUserLoggedin() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? userInLogged = await auth.currentUser;
    if (userInLogged != null) {
      String idUser = userInLogged.uid;
      _redirectPanelByUserType(idUser);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserLoggedin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo1.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                TextField(
                  controller: _controllerEmail,
                  autofocus: true,
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
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 20, 62, 97),
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
                      onPressed: () {
                        _validateFields();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Belum punya akun? Registrasi!",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/SignUp");
                    },
                  ),
                ),
                _loading
                    ? Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ))
                    : Container(),
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
