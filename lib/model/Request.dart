// // ignore: file_names
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:damri/model/Destino.dart';
// import 'UserModel.dart';

// class Requisicao {
//   String? _id;
//   String? _status;
//   Usuario? _passageiro;
//   Usuario? _motorista;
//   Destination? _destino;

//   Requisicao() {
//     FirebaseFirestore db = FirebaseFirestore.instance;

//     DocumentReference ref = db.collection("request").doc();
//     this.id = ref.id;
//   }

//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> dadosPassageiro = {
//       "name": this.passageiro?.name,
//       "email": this.passageiro?.email,
//       "typeUser": this.passageiro?.userType,
//       "idUser": this.passageiro?.idUser,
//       "latitude": this.passageiro?.latitude,
//       "longitude": this.passageiro?.longitude,
//     };

//     Map<String, dynamic> dadosDestino = {
//       "jalan": this.destino?.street,
//       "nomor": this.destino?.number,
//       "daerah": this.destino?.daerah,
//       "kodePos": this.destino?.kodePos,
//       "latitude": this.destino?.latitude,
//       "longitude": this.destino?.longitude,
//     };

//     Map<String, dynamic> dadosRequisicao = {
//       "id": this.id,
//       "status": this.status,
//       "penumpang": dadosPassageiro,
//       "pengemudi": null,
//       "tujuan": dadosDestino,
//     };

//     return dadosRequisicao;
//   }

//   Destination? get destino => _destino;

//   set destino(Destination? value) {
//     _destino = value;
//   }

//   Usuario? get motorista => _motorista;

//   set motorista(Usuario? value) {
//     _motorista = value;
//   }

//   Usuario? get passageiro => _passageiro;

//   set passageiro(Usuario? value) {
//     _passageiro = value;
//   }

//   String? get status => _status;

//   set status(String? value) {
//     _status = value;
//   }

//   String? get id => _id;

//   set id(String? value) {
//     _id = value;
//   }
// }

// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damri/model/destination.dart';
import 'user_model.dart';

class Request {
  String? _id;
  String? _status;
  // Users? _passageiro;
  Users? _passenger;
  // Users? _motorista;
  Users? _driver;
  Destination? _destina;

  Request() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentReference ref = db.collection("request").doc();
    this.id = ref.id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> passengerData = {
      "name": this.passenger?.name,
      "email": this.passenger?.email,
      "typeUser": this.passenger?.userType,
      "idUser": this.passenger?.idUser,
      "latitude": this.passenger?.latitude,
      "longitude": this.passenger?.longitude,
    };

    Map<String, dynamic> dataDes = {
      "jalan": this.destina?.street,
      "nomor": this.destina?.number,
      "daerah": this.destina?.daerah,
      "kodePos": this.destina?.kodePos,
      "latitude": this.destina?.latitude,
      "longitude": this.destina?.longitude,
    };

    Map<String, dynamic> dataReq = {
      "id": this.id,
      "status": this.status,
      "penumpang": passengerData,
      "pengemudi": null,
      "tujuan": dataDes,
    };

    return dataReq;
  }

  Destination? get destina => _destina;

  set destina(Destination? value) {
    _destina = value;
  }

  Users? get driver => _driver;

  set driver(Users? value) {
    _driver = value;
  }

  Users? get passenger => _passenger;

  set passenger(Users? value) {
    _passenger = value;
  }

  String? get status => _status;

  set status(String? value) {
    _status = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }
}
