// import 'package:flutter/material.dart';
// import '../model/Usuario.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _controllerEmail =
//       TextEditingController(text: "user@gmail.com");
//   final TextEditingController _controllerPassword =
//       TextEditingController(text: "1234567");
//   String _mensagemErro = "";
//   bool _carregando = false;

//   _validarCampos() {
//     _mensagemErro = "";
//     //recuperar dados dos campos
//     String email = _controllerEmail.text;
//     String password = _controllerPassword.text;

//     //validar campos
//     if (email.isNotEmpty && email.contains("@")) {
//       if (password.isNotEmpty && password.length > 6) {
//         Usuario usuario = Usuario();
//         usuario.email = email;
//         usuario.senha = password;

//         _logarUsuario(usuario);
//       } else {
//         setState(() {
//           _mensagemErro = "Isi kata sandi! ketik lebih dari 6 karakter";
//         });
//       }
//     } else {
//       setState(() {
//         _mensagemErro = "Isi email yang valid!";
//         ;
//       });
//     }
//   }

//   _logarUsuario(Usuario usuario) {
//     setState(() {
//       _carregando = true;
//     });

//     FirebaseAuth auth = FirebaseAuth.instance;

//     auth
//         .signInWithEmailAndPassword(
//             email: usuario.email!, password: usuario.senha!)
//         .then((firebaseUser) {
//       _redirecionaPainelPorTipoUsuario(firebaseUser.user!.uid);
//     }).catchError((error) {
//       setState(() {
//         _carregando = false;
//         _mensagemErro =
//             "Terjadi kesalahan saat mengautentikasi pengguna, periksa email dan sandi, lalu coba lagi!";
//       });
//     });
//   }

//   _redirecionaPainelPorTipoUsuario(String idUsuario) async {
//     FirebaseFirestore db = FirebaseFirestore.instance;

//     DocumentSnapshot snapshot =
//         await db.collection("users").doc(idUsuario).get();

//     dynamic dados = snapshot.data();

//     String tipoUsuario = dados["typeUser"];
//     print("$dados");

//     setState(() {
//       _carregando = false;
//     });

//     switch (tipoUsuario) {
//       case "pengemudi":
//         Navigator.pushReplacementNamed(context, "/painel-motorista");
//         break;
//       case "penumpang":
//         Navigator.pushReplacementNamed(context, "/painel-passageiro");
//         break;
//     }
//   }

//   _verificaUsuarioLogado() async {
//     FirebaseAuth auth = FirebaseAuth.instance;

//     User? usuarioLogado = await auth.currentUser;
//     if (usuarioLogado != null) {
//       String idUsuario = usuarioLogado.uid;
//       _redirecionaPainelPorTipoUsuario(idUsuario);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _verificaUsuarioLogado();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //   body: Container(
//     //     decoration: BoxDecoration(
//     //         image: DecorationImage(
//     //             image: AssetImage("imagens/fundo.png"), fit: BoxFit.cover)),
//     //     padding: EdgeInsets.all(16),
//     //     child: Center(
//     //       child: SingleChildScrollView(
//     //         child: Column(
//     //           crossAxisAlignment: CrossAxisAlignment.stretch,
//     //           children: [
//     //             Padding(
//     //               padding: EdgeInsets.only(bottom: 32),
//     //               child: Image.asset(
//     //                 "imagens/logo.png",
//     //                 width: 200,
//     //                 height: 150,
//     //               ),
//     //             ),
//     //             TextField(
//     //               controller: _controllerEmail,
//     //               autofocus: true,
//     //               keyboardType: TextInputType.emailAddress,
//     //               style: TextStyle(fontSize: 20),
//     //               decoration: InputDecoration(
//     //                   contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
//     //                   hintText: "e-mail",
//     //                   filled: true,
//     //                   fillColor: Colors.white,
//     //                   border: OutlineInputBorder(
//     //                     borderRadius: BorderRadius.circular(6),
//     //                   )),
//     //             ),
//     //             TextField(
//     //               controller: _controllerSenha,
//     //               obscureText: true,
//     //               keyboardType: TextInputType.emailAddress,
//     //               style: TextStyle(fontSize: 20),
//     //               decoration: InputDecoration(
//     //                   contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
//     //                   hintText: "senha",
//     //                   filled: true,
//     //                   fillColor: Colors.white,
//     //                   border: OutlineInputBorder(
//     //                     borderRadius: BorderRadius.circular(6),
//     //                   )),
//     //             ),
//     //             Padding(
//     //                 padding: EdgeInsets.only(top: 16, bottom: 10),
//     //                 child: ElevatedButton(
//     //                   style: ElevatedButton.styleFrom(
//     //                       primary: Color(0xff1ebbd8),
//     //                       padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
//     //                   onPressed: () {
//     //                     _validarCampos();
//     //                   },
//     //                   child: Text(
//     //                     "Entrar",
//     //                     style: TextStyle(color: Colors.white, fontSize: 20),
//     //                   ),
//     //                 )),
//     //             Center(
//     //               child: GestureDetector(
//     //                 child: Text(
//     //                   "Não tem conta? cadastre-se!",
//     //                   style: TextStyle(color: Colors.white),
//     //                 ),
//     //                 onTap: () {
//     //                   Navigator.pushNamed(context, "/cadastro");
//     //                 },
//     //               ),
//     //             ),
//     //             _carregando
//     //                 ? Padding(
//     //                     padding: EdgeInsets.only(top: 16),
//     //                     child: Center(
//     //                       child: CircularProgressIndicator(
//     //                         backgroundColor: Colors.white,
//     //                       ),
//     //                     ))
//     //                 : Container(),
//     //             Padding(
//     //               padding: EdgeInsets.only(top: 16),
//     //               child: Center(
//     //                 child: Text(
//     //                   _mensagemErro,
//     //                   style: TextStyle(color: Colors.red, fontSize: 20),
//     //                 ),
//     //               ),
//     //             )
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 32),
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
//                   style: const TextStyle(fontSize: 20),
//                   decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
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
//                   style: const TextStyle(fontSize: 20),
//                   decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
//                       hintText: "Password",
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       )),
//                 ),
//                 Padding(
//                     padding: const EdgeInsets.only(top: 16, bottom: 10),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               const Color.fromARGB(255, 20, 62, 97),
//                           padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
//                       onPressed: () {
//                         _validarCampos();
//                       },
//                       child: const Text(
//                         "Login",
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     )),
//                 Center(
//                   child: GestureDetector(
//                     child: const Text(
//                       "Belum punya akun? Registrasi!",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     onTap: () {
//                       Navigator.pushNamed(context, "/SignUp");
//                     },
//                   ),
//                 ),
//                 _carregando
//                     ? const Padding(
//                         padding: EdgeInsets.only(top: 16),
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             backgroundColor: Colors.white,
//                           ),
//                         ))
//                     : Container(),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16),
//                   child: Center(
//                     child: Text(
//                       _mensagemErro,
//                       style: const TextStyle(color: Colors.red, fontSize: 20),
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
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerEmail =
      TextEditingController(text: "user@gmail.com");
  final TextEditingController _controllerPassword =
      TextEditingController(text: "1234567");

  String _messageError = "";
  bool _loading = false;

  _validateFields() {
    _messageError = "";
    //recuperar dados dos campos
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    //validar campos
    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length > 6) {
        Users user = Users();
        user.email = email;
        // user.senha = password;
        user.password = password;

        _loginUser(user);
      } else {
        setState(() {
          _messageError = "Isi kata sandi! ketik lebih dari 6 karakter";
        });
      }
    } else {
      setState(() {
        _messageError = "Isi email yang valid!";
        ;
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
        _messageError =
            "Terjadi kesalahan saat mengautentikasi pengguna, periksa email dan sandi, lalu coba lagi!";
      });
    });
  }

  _redirectPanelByUserType(String idUser) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await db.collection("users").doc(idUser).get();

    dynamic data = snapshot.data();

    String userType = data["typeUser"];
    print("$data");

    setState(() {
      _loading = false;
    });

    switch (userType) {
      case "pengemudi":
        Navigator.pushReplacementNamed(context, "/panel-pengemudi");
        break;
      case "penumpang":
        Navigator.pushReplacementNamed(context, "/panel-penumpang");
        break;
    }
  }

// jika sudah login , maka diarahkan ke halaman sesuai type user
  _checkUserLoggedin() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? loggedInUser = await auth.currentUser;
    if (loggedInUser != null) {
      String idUser = loggedInUser.uid;
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
    //   body: Container(
    //     decoration: BoxDecoration(
    //         image: DecorationImage(
    //             image: AssetImage("imagens/fundo.png"), fit: BoxFit.cover)),
    //     padding: EdgeInsets.all(16),
    //     child: Center(
    //       child: SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             Padding(
    //               padding: EdgeInsets.only(bottom: 32),
    //               child: Image.asset(
    //                 "imagens/logo.png",
    //                 width: 200,
    //                 height: 150,
    //               ),
    //             ),
    //             TextField(
    //               controller: _controllerEmail,
    //               autofocus: true,
    //               keyboardType: TextInputType.emailAddress,
    //               style: TextStyle(fontSize: 20),
    //               decoration: InputDecoration(
    //                   contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
    //                   hintText: "e-mail",
    //                   filled: true,
    //                   fillColor: Colors.white,
    //                   border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(6),
    //                   )),
    //             ),
    //             TextField(
    //               controller: _controllerSenha,
    //               obscureText: true,
    //               keyboardType: TextInputType.emailAddress,
    //               style: TextStyle(fontSize: 20),
    //               decoration: InputDecoration(
    //                   contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
    //                   hintText: "senha",
    //                   filled: true,
    //                   fillColor: Colors.white,
    //                   border: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(6),
    //                   )),
    //             ),
    //             Padding(
    //                 padding: EdgeInsets.only(top: 16, bottom: 10),
    //                 child: ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                       primary: Color(0xff1ebbd8),
    //                       padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
    //                   onPressed: () {
    //                     _validarCampos();
    //                   },
    //                   child: Text(
    //                     "Entrar",
    //                     style: TextStyle(color: Colors.white, fontSize: 20),
    //                   ),
    //                 )),
    //             Center(
    //               child: GestureDetector(
    //                 child: Text(
    //                   "Não tem conta? cadastre-se!",
    //                   style: TextStyle(color: Colors.white),
    //                 ),
    //                 onTap: () {
    //                   Navigator.pushNamed(context, "/cadastro");
    //                 },
    //               ),
    //             ),
    //             _carregando
    //                 ? Padding(
    //                     padding: EdgeInsets.only(top: 16),
    //                     child: Center(
    //                       child: CircularProgressIndicator(
    //                         backgroundColor: Colors.white,
    //                       ),
    //                     ))
    //                 : Container(),
    //             Padding(
    //               padding: EdgeInsets.only(top: 16),
    //               child: Center(
    //                 child: Text(
    //                   _mensagemErro,
    //                   style: TextStyle(color: Colors.red, fontSize: 20),
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
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
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
                Center(
                  child: GestureDetector(
                    child: const Text(
                      "Belum punya akun? Registrasi!",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/SignUp");
                    },
                  ),
                ),
                _loading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ))
                    : Container(),
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
