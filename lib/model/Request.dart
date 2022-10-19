// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:damri/model/Destination.dart';
// import 'User.dart';

// class Requisicao {
//   String? _id;
//   String? _status;
//   Users? _passageiro;
//   Users? _motorista;
//   Destino? _destino;

//   Requisicao() {
//     FirebaseFirestore db = FirebaseFirestore.instance;

//     DocumentReference ref = db.collection("requisicoes").doc();
//     this.id = ref.id;
//   }

//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> dadosPassageiro = {
//       "nome": this.passageiro?.nome,
//       "email": this.passageiro?.email,
//       "tipoUsuario": this.passageiro?.tipoUsuario,
//       "idUsuario": this.passageiro?.idUsuario,
//       "latitude": this.passageiro?.latitude,
//       "longitude": this.passageiro?.longitude,
//     };

//     Map<String, dynamic> dadosDestino = {
//       "rua": this.destino?.rua,
//       "numero": this.destino?.numero,
//       "bairro": this.destino?.bairro,
//       "cep": this.destino?.cep,
//       "latitude": this.destino?.latitude,
//       "longitude": this.destino?.longitude,
//     };

//     Map<String, dynamic> dadosRequisicao = {
//       "id": this.id,
//       "status": this.status,
//       "passageiro": dadosPassageiro,
//       "motorista": null,
//       "destino": dadosDestino,
//     };

//     return dadosRequisicao;
//   }

//   Destino? get destino => _destino;

//   set destino(Destino? value) {
//     _destino = value;
//   }

//   Users? get motorista => _motorista;

//   set motorista(Users? value) {
//     _motorista = value;
//   }

//   Users? get passageiro => _passageiro;

//   set passageiro(Users? value) {
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damri/model/Destination.dart';
import 'User.dart';

class Requisicao {
  String? _id;
  String? _status;
  Users? _penumpang;
  Users? _pengemudi;
  Destination? _destination;

  Requisicao() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentReference ref = db.collection("requisicoes").doc();
    this.id = ref.id;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dataPenumpang = {
      "nama": this.penumpang?.nama,
      "email": this.penumpang?.email,
      "tipeUser": this.penumpang?.userType,
      "idUser": this.penumpang?.idUser,
      "latitude": this.penumpang?.latitude,
      "longitude": this.penumpang?.longitude,
    };

    Map<String, dynamic> dataDestination = {
      "street": this.destination?.street,
      "number": this.destination?.number,
      "daerah": this.destination?.daerah,
      "kode_pos": this.destination?.kodePos,
      "latitude": this.destination?.latitude,
      "longitude": this.destination?.longitude,
    };

    Map<String, dynamic> dataRequest = {
      "id": this.id,
      "status": this.status,
      "penumpang": dataPenumpang,
      "pengemudi": null,
      "destination": dataDestination,
    };

    return dataRequest;
  }

  Destination? get destination => _destination;

  set destination(Destination? value) {
    _destination = value;
  }

  Users? get pengemudi => _pengemudi;

  set pengemudi(Users? value) {
    _pengemudi = value;
  }

  Users? get penumpang => _penumpang;

  set penumpang(Users? value) {
    _penumpang = value;
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
