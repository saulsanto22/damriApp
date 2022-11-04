// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:damri/model/UserModel.dart';

// class UsuarioFirebase {
//   static Future<User> getUsuarioAtual() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     return await auth.currentUser!;
//   }

//   static Future<Users> getDadosUsuarioLogado() async {
//     User firebaseUser = await getUsuarioAtual();
//     String idUsuario = firebaseUser.uid;

//     FirebaseFirestore db = FirebaseFirestore.instance;

//     DocumentSnapshot snapshot =
//         await db.collection("users").doc(idUsuario).get();

//     Map<String, dynamic> dados = snapshot.data() as Map<String, dynamic>;

//     String tipoUsuario = dados["typeUser"];
//     String email = dados["email"];
//     String nome = dados["name"];

//     Users usuario = Users();

//     usuario.idUser = idUsuario;
//     usuario.userType = tipoUsuario;
//     usuario.email = email;
//     usuario.name = nome;

//     return usuario;
//   }

//   static atualizarDadosLocalizacao(
//       String idRequisicao, double lat, double lon, String tipo) async {
//     FirebaseFirestore db = FirebaseFirestore.instance;

//     Users usuario = await getDadosUsuarioLogado();
//     usuario.latitude = lat;
//     usuario.longitude = lon;

//     db.collection("request").doc(idRequisicao).update({tipo: usuario.toMap()});
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:damri/model/user_model.dart';

// class UsuarioFirebase {
class UserFirebase {
  // static Future<User> getUsuarioAtual() async {
  static Future<User> getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.currentUser!;
  }
  // static Future<Users> getDadosUsuarioLogado() async {

  static Future<Users> getLoggedUserData() async {
    User firebaseUser = await getCurrentUser();
    String idUser = firebaseUser.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await db.collection("users").doc(idUser).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    String typeUser = data["typeUser"];
    String email = data["email"];
    String name = data["name"];

    Users users = Users();

    users.idUser = idUser;
    users.userType = typeUser;
    users.email = email;
    users.name = name;

    return users;
  }

  // static atualizarDadosLocalizacao(
  static updateDataLocation(
      String idReq, double lat, double lon, String type) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Users user = await getLoggedUserData();
    user.latitude = lat;
    user.longitude = lon;

    db.collection("request").doc(idReq).update({type: user.toMap()});
  }
}
