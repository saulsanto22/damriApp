// class Destino {
//   String? _rua;
//   String? _numero;
//   String? _cidade;
//   String? _bairro;
//   String? _cep;
//   double? _latitude;
//   double? _longitude;

//   Destino();

//   double? get longitude => _longitude;

//   set longitude(double? value) {
//     _longitude = value;
//   }

//   double? get latitude => _latitude;

//   set latitude(double? value) {
//     _latitude = value;
//   }

//   String? get cep => _cep;

//   set cep(String? value) {
//     _cep = value;
//   }

//   String? get bairro => _bairro;

//   set bairro(String? value) {
//     _bairro = value;
//   }

//   String? get cidade => _cidade;

//   set cidade(String? value) {
//     _cidade = value;
//   }

//   String? get numero => _numero;

//   set numero(String? value) {
//     _numero = value;
//   }

//   String? get rua => _rua;

//   set rua(String? value) {
//     _rua = value;
//   }
// }

class Destination {
  String? _street;
  String? _number;
  String? _kota;
  String? _daerah;
  String? _kodePos;
  double? _latitude;
  double? _longitude;

  Destination();

  double? get longitude => _longitude;

  set longitude(double? value) {
    _longitude = value;
  }

  double? get latitude => _latitude;

  set latitude(double? value) {
    _latitude = value;
  }

  String? get kodePos => _kodePos;

  set kodePos(String? value) {
    _kodePos = value;
  }

  String? get daerah => _daerah;

  set daerah(String? value) {
    _daerah = value;
  }

  String? get kota => _kota;

  set kota(String? value) {
    _kota = value;
  }

  String? get number => _number;

  set number(String? value) {
    _number = value;
  }

  String? get street => _street;

  set street(String? value) {
    _street = value;
  }
}
