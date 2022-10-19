// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:damri/model/User.dart';

// class UsuarioFirebase {
//   static Future<User> getCurrentUser() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     return await auth.currentUser!;
//   }

//   static Future<Users> getLoginUserData() async {
//     User firebaseUser = await getCurrentUser();
//     String idUser = firebaseUser.uid;
//     print(idUser);

//     FirebaseFirestore db = FirebaseFirestore.instance;

//     DocumentSnapshot snapshot =
//         await db.collection("usuarios").doc(idUser).get();

//     Map<String, dynamic> dados = snapshot.data() as Map<String, dynamic>;

//     String tipoUsuario = dados["tipoUsuario"];
//     String email = dados["email"];
//     String nome = dados["nome"];

//     Users user = Users();

//     user.idUsuario = idUser;
//     user.tipoUsuario = tipoUsuario;
//     user.email = email;
//     user.nome = nome;

//     return user;
//   }

//   static updateDataLocation(
//       String idRequest, double lat, double lon, String tipo) async {
//     FirebaseFirestore db = FirebaseFirestore.instance;

//     Users user = await getLoginUserData();
//     user.latitude = lat;
//     user.longitude = lon;

//     db.collection("requisicoes").doc(idRequest).update({tipo: user.toMap()});
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:damri/model/User.dart';

class UserFirebase {
  static Future<User> getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.currentUser!;
  }

  static Future<Users> getLoginUserData() async {
    User firebaseUser = await getCurrentUser();
    String idUser = firebaseUser.uid;
    print(idUser);

    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await db.collection("users").doc(idUser).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    String tipeUser = data["tipeUser"];
    String email = data["email"];
    String nama = data["name"];

    Users user = Users();

    user.idUser = idUser;
    user.userType = tipeUser;
    user.email = email;
    user.nama = nama;

    return user;
  }

  static updateDataLocation(
      String idRequest, double lat, double lon, String tipo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Users user = await getLoginUserData();
    user.latitude = lat;
    user.longitude = lon;

    db.collection("request").doc(idRequest).update({tipo: user.toMap()});
  }
}
