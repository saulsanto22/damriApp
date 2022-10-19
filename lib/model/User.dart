// class Users {
//   String? _idUser;
//   String? _nama;
//   String? _email;
//   String? _password;
//   String? _userType;

//   double? _latitude;
//   double? _longitude;

//   Users();

//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> map = {
//       "idUser": this.idUsuario,
//       "nama": this.nome,
//       "email": this.email,
//       "tipeUser": this.tipoUsuario,
//       "latitude": this.latitude,
//       "longitude": this.longitude,
//     };

//     return map;
//   }

//   String verificaTipoUsuario(bool tipoUsuario) {
//     return tipoUsuario ? "motorista" : "passageiro";
//   }

//   String? get tipoUsuario => _userType;

//   set tipoUsuario(String? value) {
//     _userType = value;
//   }

//   String? get senha => _password;

//   set senha(String? value) {
//     _password = value;
//   }

//   String? get email => _email;

//   set email(String? value) {
//     _email = value;
//   }

//   String? get nome => _nama;

//   set nome(String? value) {
//     _nama = value;
//   }

//   String? get idUsuario => _idUser;

//   set idUsuario(String? value) {
//     _idUser = value;
//   }

//   double? get longitude => _longitude;

//   set longitude(double? value) {
//     _longitude = value;
//   }

//   double? get latitude => _latitude;

//   set latitude(double? value) {
//     _latitude = value;
//   }

// }
class Users {
  String? _idUser;
  String? _nama;
  String? _email;
  String? _password;
  String? _userType;

  double? _latitude;
  double? _longitude;

  Users();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": this.idUser,
      "nama": this.nama,
      "email": this.email,
      "tipeUser": this.userType,
      "latitude": this.latitude,
      "longitude": this.longitude,
    };

    return map;
  }

  String checkUserType(bool userType) {
    return userType ? "pengemudi" : "penumpang";
  }

  String? get userType => _userType;

  set userType(String? value) {
    _userType = value;
  }

  String? get password => _password;

  set password(String? value) {
    _password = value;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? get nama => _nama;

  set nama(String? value) {
    _nama = value;
  }

  String? get idUser => _idUser;

  set idUser(String? value) {
    _idUser = value;
  }

  double? get longitude => _longitude;

  set longitude(double? value) {
    _longitude = value;
  }

  double? get latitude => _latitude;

  set latitude(double? value) {
    _latitude = value;
  }
}
