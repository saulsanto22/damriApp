class Users {
//   String? _idUsuario;
//   String? _nome;
//   String? _email;
//   String? _senha;
//   String? _tipoUsuario;
// // id user

//   double? _latitude;
//   double? _longitude;

  String? _idUser;
  String? _name;
  String? _email;
  String? _password;
  String? _userType;

  double? _latitude;
  double? _longitude;

  Users();

  // Map<String, dynamic> toMap() {
  //   Map<String, dynamic> map = {
  //     "idUser": this.idUsuario,
  //     "name": this.nome,
  //     "email": this.email,
  //     "typeUser": this.tipoUsuario,
  //     "latitude": this.latitude,
  //     "longitude": this.longitude,
  //   };

  //   return map;
  // }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": this.idUser,
      "name": this.name,
      "email": this.email,
      "typeUser": this.userType,
      "latitude": this.latitude,
      "longitude": this.longitude,
    };

    return map;
  }

  // String verificaTipoUsuario(bool tipoUsuario) {
  //   return tipoUsuario ? "pengemudi" : "penumpang";
  // }

  String verifyUserTyoe(bool userType) {
    return userType ? "pengemudi" : "penumpang";
  }

  String? get userType => _userType;

  set userType(String? value) {
    _userType = value;
  }

  // String? get senha => _senha;

  // set senha(String? value) {
  //   _senha = value;
  // }

  String? get password => _password;

  set password(String? value) {
    _password = value;
  }

  // String? get email => _email;

  // set email(String? value) {
  //   _email = value;
  // }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  // String? get nome => _nome;

  // set nome(String? value) {
  //   _nome = value;
  // }

  String? get name => _name;

  set name(String? value) {
    _name = value;
  }

  // String? get idUsuario => _idUsuario;

  // set idUsuario(String? value) {
  //   _idUsuario = value;
  // }

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
