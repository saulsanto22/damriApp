// // import 'dart:async';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:intl/intl.dart';
// // import 'package:damri/model/Requisicao.dart';
// // import 'package:damri/util/UsuarioFirebase.dart';
// // import 'dart:io';
// // import '../model/Destino.dart';
// // import '../model/Marcador.dart';
// // import '../model/Usuario.dart';
// // import '../util/StatusRequisicao.dart';

// // class PainelPassageiro extends StatefulWidget {
// //   const PainelPassageiro({Key? key}) : super(key: key);

// //   @override
// //   State<PainelPassageiro> createState() => _PainelPassageiroState();
// // }

// // class _PainelPassageiroState extends State<PainelPassageiro> {
// //   TextEditingController _controllerDestino = TextEditingController(text: "");
// //   Completer<GoogleMapController> _controller = Completer();
// //   Set<Marker> _markers = {};
// //   String? _idRequest;
// //   Position? _locationPassenger;
// //   Map<String, dynamic>? _dataRequest;
// //   StreamSubscription<DocumentSnapshot>? _streamSubscriptionRequests;

// //   //Controles para exibição na tela
// //   bool _displayDestinationAddressBox = true;
// //   String _textButton = "Cari Bus";
// //   Color _colorButton = Color.fromARGB(255, 11, 57, 94);
// //   Function? _functionButton;

// //   CameraPosition _positionCamera = CameraPosition(
// //     target: LatLng(-6.914864, 107.608238),
// //     zoom: 18,
// //   );

// //   _onMapCreated(GoogleMapController controller) {
// //     _controller.complete(controller);
// //   }

// //   _retrieveLastKnownLocation() async {
// //     Position? position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);

// //     if (position != null) {
// //       setState(() {
// //         _displaymarkPassenger(position);

// //         _positionCamera = CameraPosition(
// //             target: LatLng(position.latitude, position.longitude), zoom: 19);
// //         _locationPassenger = position;
// //         _moveCamera(_positionCamera);
// //       });
// //     }
// //   }

// //   _moveCamera(CameraPosition cameraPosition) async {
// //     GoogleMapController googleMapController = await _controller.future;
// //     googleMapController
// //         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
// //   }

// //   _addListenerLocation() async {
// //     LocationPermission permission;
// //     await Geolocator.checkPermission();
// //     permission = await Geolocator.requestPermission();

// //     var locationSetings =
// //         LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

// //     Geolocator.getPositionStream(locationSettings: locationSetings)
// //         .listen((Position position) {
// //       if (_idRequest != null && _idRequest!.isNotEmpty) {
// //         //Atualiza local do passageiro
// //         UsuarioFirebase.updateDataLocation(
// //             _idRequest!, position.latitude, position.longitude, "passageiro");
// //       } else {
// //         setState(() {
// //           _locationPassenger = position;
// //         });
// //         _uberNotCalledstatus();
// //       }
// //     });
// //   }

// //   List<String> itemsMenu = ["Informasi", "Profile", "Logout"];

// //   _logoutUser() {
// //     FirebaseAuth auth = FirebaseAuth.instance;

// //     auth.signOut();
// //     Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
// //   }

// //   _userProfile() {
// //     setState(() {
// //       Navigator.pushReplacementNamed(context, "/userProfile");
// //     });
// //   }

// //   _info() {
// //     Navigator.pushReplacementNamed(context, "/informasi");
// //   }

// //   _chooseMenuItem(String choice) {
// //     switch (choice) {
// //       case "Logout":
// //         _logoutUser();
// //         break;
// //       case "Konfigurasi":
// //         break;
// //       case "Profile":
// //         _userProfile();
// //         break;
// //       case "Informasi":
// //         _info();
// //         break;
// //     }
// //   }

// //   _callBus() async {
// //     String enderecoDestino = _controllerDestino.text;

// //     List<Location> listaLocalizacoes =
// //         await GeocodingPlatform.instance.locationFromAddress(enderecoDestino);

// //     if (listaLocalizacoes.isNotEmpty) {
// //       Location localizacao = listaLocalizacoes[0];
// //       List<Placemark> listaEnderecos = await GeocodingPlatform.instance
// //           .placemarkFromCoordinates(
// //               localizacao.latitude, localizacao.longitude);
// //       if (listaEnderecos.isNotEmpty) {
// //         Placemark endereco = listaEnderecos[0];

// //         Destino destino = Destino();
// //         destino.cidade = endereco.subAdministrativeArea;
// //         destino.cep = endereco.postalCode;
// //         destino.bairro = endereco.subLocality;
// //         destino.rua = endereco.thoroughfare;
// //         destino.numero = endereco.subThoroughfare;

// //         destino.latitude = localizacao.latitude;
// //         destino.longitude = localizacao.longitude;

// //         String enderecoConfirmacao;
// //         enderecoConfirmacao = "\n Kota: ${destino.cidade}";
// //         enderecoConfirmacao += "\n Jalan ${destino.rua}, ${destino.numero}";
// //         enderecoConfirmacao += "\n Lingkungan: ${destino.bairro}";
// //         enderecoConfirmacao += "\n Kode Pos: ${destino.cep}";

// //         showDialog(
// //             context: context,
// //             builder: (context) {
// //               return AlertDialog(
// //                 title: Text("Konfirmasi alamat"),
// //                 content: Text(enderecoConfirmacao),
// //                 contentPadding: EdgeInsets.all(16),
// //                 actions: [
// //                   TextButton(
// //                     child: Text(
// //                       "Cancel",
// //                       style: TextStyle(color: Colors.red),
// //                     ),
// //                     onPressed: () => Navigator.pop(context),
// //                   ),
// //                   TextButton(
// //                     child: Text(
// //                       "Konfirmasi",
// //                       style: TextStyle(color: Colors.green),
// //                     ),
// //                     onPressed: () {
// //                       //salvar requisicao
// //                       _saveRequisition(destino);

// //                       Navigator.pop(context);
// //                     },
// //                   ),
// //                 ],
// //               );
// //             });
// //       }
// //     } else {
// //       //algum controle/aviso para preencher todos os campos.
// //     }
// //   }

// //   _displaymarkPassenger(Position local) async {
// //     double pixelRatio = MediaQuery.of(context).devicePixelRatio;

// //     BitmapDescriptor.fromAssetImage(
// //             ImageConfiguration(devicePixelRatio: pixelRatio),
// //             "imagens/passageiro.png")
// //         .then((BitmapDescriptor icone) {
// //       Marker marcadorPassageiro = Marker(
// //           markerId: MarkerId("marcador-passageiro"),
// //           position: LatLng(local.latitude, local.longitude),
// //           infoWindow: InfoWindow(title: "Lokasi Sayal"),
// //           icon: icone);

// //       setState(() {
// //         _markers.add(marcadorPassageiro);
// //       });
// //     });
// //   }

// //   _saveRequisition(Destino destino) async {
// //     /*
// //     + requisicao
// //        + ID_REQUISICAO
// //           + destino (rua, endereço, latitude...)
// //           + passageiro (nome, email ...)
// //           + motorista (nome, email ...)
// //           + status (aguardando, a caminho...finalizada)
// //      */

// //     Usuario passageiro = await UsuarioFirebase.getLoginUserData();
// //     passageiro.latitude = _locationPassenger?.latitude;
// //     passageiro.longitude = _locationPassenger?.longitude;

// //     Requisicao requisicao = Requisicao();
// //     requisicao.destino = destino;
// //     requisicao.passageiro = passageiro;
// //     requisicao.status = StatusRequisicao.AGUARDANDO;

// //     FirebaseFirestore db = FirebaseFirestore.instance;

// //     //Salvar requisição ativa
// //     db.collection("requisicoes").doc(requisicao.id).set(requisicao.toMap());

// //     //Salvar requisição ativa
// //     Map<String, dynamic> dadosRequisicaoAtiva = {};
// //     dadosRequisicaoAtiva["id_requisicao"] = requisicao.id;
// //     dadosRequisicaoAtiva["id_usuario"] = passageiro.idUsuario;
// //     dadosRequisicaoAtiva["status"] = StatusRequisicao.AGUARDANDO;

// //     db
// //         .collection("requisicao_ativa")
// //         .doc(passageiro.idUsuario)
// //         .set(dadosRequisicaoAtiva);

// //     //Adicionar listener requisicao
// //     if (_streamSubscriptionRequests == null) {
// //       _addRequisitionListener(requisicao.id!);
// //     }
// //   }

// //   _changeMainButton(String text, Color color, Function func) {
// //     setState(() {
// //       _textButton = text;
// //       _colorButton = color;
// //       _functionButton = func;
// //     });
// //   }

// //   _uberNotCalledstatus() async {
// //     _displayDestinationAddressBox = true;
// //     _changeMainButton("Cari Damri", Color(0xff1ebbd8), () {
// //       _callBus();
// //     });

// //     //if(_localPassageiro != null ){
// //     Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);

// //     _displaymarkPassenger(position);
// //     CameraPosition cameraPosition = CameraPosition(
// //       target: LatLng(position.latitude, position.longitude),
// //       zoom: 18,
// //     );
// //     _moveCamera(cameraPosition);
// //     //}
// //   }

// //   _statusWaiting() async {
// //     _displayDestinationAddressBox = false;
// //     _changeMainButton("Cancel", Colors.red, () {
// //       _cancelBus();
// //     });

// //     // double passageiroLat = _dadosRequisicao?["passageiro"]["latitude"];
// //     // double passageiroLon = _dadosRequisicao?["passageiro"]["longitude"];
// //     Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);

// //     _displaymarkPassenger(position);
// //     CameraPosition cameraPosition = CameraPosition(
// //       target: LatLng(position.latitude, position.longitude),
// //       zoom: 18,
// //     );
// //     _moveCamera(cameraPosition);
// //   }

// //   _statusOnTheWay() {
// //     _displayDestinationAddressBox = false;
// //     _changeMainButton("Bus di jalan", Colors.grey, () {});

// //     double latitudePassageiro = _dataRequest?["passageiro"]["latitude"];
// //     double longitudePassageiro = _dataRequest?["passageiro"]["longitude"];

// //     double latitudeMotorista = _dataRequest?["motorista"]["latitude"];
// //     double longitudeMotorista = _dataRequest?["motorista"]["longitude"];

// //     Marcador marcadorOrigem = Marcador(
// //         LatLng(latitudeMotorista, longitudeMotorista),
// //         "imagens/motorista.png",
// //         "Location Driver");

// //     Marcador marcadorDestino = Marcador(
// //         LatLng(latitudePassageiro, longitudePassageiro),
// //         "imagens/passageiro.png",
// //         "local destino");

// //     _displayCenterTwoBookmarks(marcadorOrigem, marcadorDestino);
// //   }

// //   _statusTravel() {
// //     _displayDestinationAddressBox = false;

// //     _changeMainButton(
// //       "Berpergian",
// //       Colors.grey,
// //       () {},
// //     );

// //     double latitudeDestino = _dataRequest!["destino"]["latitude"];
// //     double longitudeDestino = _dataRequest!["destino"]["longitude"];

// //     double latitudeOrigem = _dataRequest!["motorista"]["latitude"];
// //     double longitudeOrigem = _dataRequest!["motorista"]["longitude"];

// //     Marcador marcadorOrigem = Marcador(LatLng(latitudeOrigem, longitudeOrigem),
// //         "imagens/motorista.png", "local motorista");

// //     Marcador marcadorDestino = Marcador(
// //         LatLng(latitudeDestino, longitudeDestino),
// //         "imagens/destino.png",
// //         "local destino");

// //     _displayCenterTwoBookmarks(marcadorOrigem, marcadorDestino);
// //   }

// //   _statusFinished() async {
// //     //Calcula valor da corrida
// //     double latitudeDestino = _dataRequest!["destino"]["latitude"];
// //     double longitudeDestino = _dataRequest!["destino"]["longitude"];

// //     double latitudeOrigem = _dataRequest!["origem"]["latitude"];
// //     double longitudeOrigem = _dataRequest!["origem"]["longitude"];

// //     //para calcular um valor mais exato basta consumir uma API do google
// //     // que calcula a distanciaconsiderando as ruas do percurso.
// //     double distanciaEmMetros = Geolocator.distanceBetween(
// //         latitudeOrigem, longitudeOrigem, latitudeDestino, longitudeDestino);

// //     //converte para KM
// //     double distanciaKM = distanciaEmMetros / 1000;
// //     double valorViagem = distanciaKM * 8;

// //     //8 é o valor cobrado por KM
// //     var f = NumberFormat('#,##0.00', 'pt_BR');
// //     var valorViagemFormatado = f.format(valorViagem);

// //     _changeMainButton(
// //       "Total - R\$ $valorViagemFormatado",
// //       Colors.green,
// //       () {},
// //     );

// //     Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);

// //     _displayMark(position, "imagens/destino.png", "Tujuan");

// //     //setState(() {
// //     CameraPosition cameraPosition = CameraPosition(
// //       target: LatLng(position.latitude, position.longitude),
// //       zoom: 18,
// //     );
// //     // });
// //     _moveCamera(cameraPosition);
// //   }

// //   _statusConfirmation() async {
// //     if (_streamSubscriptionRequests != null) {
// //       _streamSubscriptionRequests!.cancel();
// //       _streamSubscriptionRequests = null;
// //     }

// //     _displayDestinationAddressBox = true;

// //     _changeMainButton("Cari Bus", Color(0xff1ebbd8), () {
// //       _callBus();
// //     });

// //     Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);

// //     _displaymarkPassenger(position);
// //     CameraPosition cameraPosition = CameraPosition(
// //       target: LatLng(position.latitude, position.longitude),
// //       zoom: 18,
// //     );
// //     _moveCamera(cameraPosition);

// //     _dataRequest = {};

// //     _addListenerLocation();
// //   }

// //   _displayMark(Position local, String icone, String infoWindow) async {
// //     double pixelRatio = MediaQuery.of(context).devicePixelRatio;

// //     BitmapDescriptor.fromAssetImage(
// //             ImageConfiguration(devicePixelRatio: pixelRatio), icone)
// //         .then((BitmapDescriptor bitmapDescriptor) {
// //       Marker marcador = Marker(
// //           markerId: MarkerId(icone),
// //           position: LatLng(local.latitude, local.longitude),
// //           infoWindow: InfoWindow(title: infoWindow),
// //           icon: bitmapDescriptor);

// //       setState(() {
// //         _markers.add(marcador);
// //       });
// //     });
// //   }

// //   _displayTwoMarkers(Marcador marcadorOrigem, Marcador marcadorDestino) {
// //     double pixelRatio = MediaQuery.of(context).devicePixelRatio;

// //     LatLng latLngOrigem = marcadorOrigem.local;
// //     LatLng latLngDestino = marcadorDestino.local;

// //     Set<Marker> _listaMarcadores = {};
// //     BitmapDescriptor.fromAssetImage(
// //             ImageConfiguration(devicePixelRatio: pixelRatio),
// //             marcadorOrigem.caminhoImagem)
// //         .then((BitmapDescriptor icone) {
// //       Marker mOrigem = Marker(
// //           markerId: MarkerId(marcadorOrigem.caminhoImagem),
// //           position: LatLng(latLngOrigem.latitude, latLngOrigem.longitude),
// //           infoWindow: InfoWindow(title: marcadorOrigem.titulo),
// //           icon: icone);
// //       _listaMarcadores.add(mOrigem);
// //     });

// //     BitmapDescriptor.fromAssetImage(
// //             ImageConfiguration(devicePixelRatio: pixelRatio),
// //             marcadorDestino.caminhoImagem)
// //         .then((BitmapDescriptor icone) {
// //       Marker mDestino = Marker(
// //           markerId: MarkerId(marcadorDestino.caminhoImagem),
// //           position: LatLng(latLngDestino.latitude, latLngDestino.longitude),
// //           infoWindow: InfoWindow(title: marcadorDestino.titulo),
// //           icon: icone);
// //       _listaMarcadores.add(mDestino);
// //     });

// //     setState(() {
// //       _markers = _listaMarcadores;
// //     });
// //   }

// //   _displayCenterTwoBookmarks(
// //       Marcador marcadorOrigem, Marcador marcadorDestino) {
// //     double latitudeOrigem = marcadorOrigem.local.latitude;
// //     double longitudeOrigem = marcadorOrigem.local.longitude;

// //     double latitudeDestino = marcadorDestino.local.latitude;
// //     double longitudeDestino = marcadorDestino.local.longitude;

// //     _displayTwoMarkers(
// //       marcadorOrigem,
// //       marcadorDestino,
// //     );

// //     //'southwest.latitude <= northeast.latitude' : is not true
// //     double? nLat, nLon, sLat, sLon;

// //     if (latitudeOrigem <= latitudeDestino) {
// //       sLat = latitudeOrigem;
// //       nLat = latitudeDestino;
// //     } else {
// //       sLat = latitudeDestino;
// //       nLat = latitudeOrigem;
// //     }

// //     if (longitudeOrigem <= longitudeDestino) {
// //       sLon = longitudeOrigem;
// //       nLon = longitudeDestino;
// //     } else {
// //       sLon = longitudeDestino;
// //       nLon = longitudeOrigem;
// //     }

// //     _movimentarCameraBounds(LatLngBounds(
// //       northeast: LatLng(nLat, nLon),
// //       southwest: LatLng(sLat, sLon),
// //     ));
// //   }

// //   _movimentarCameraBounds(LatLngBounds latLngBounds) async {
// //     GoogleMapController googleMapController = await _controller.future;
// //     googleMapController
// //         .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
// //   }

// //   _cancelBus() async {
// //     User firebaseUser = await UsuarioFirebase.getCurrentUser();
// //     FirebaseFirestore db = FirebaseFirestore.instance;
// //     db
// //         .collection("requisicoes")
// //         .doc(_idRequest)
// //         .update({"status": StatusRequisicao.CANCELADA}).then((_) {
// //       db.collection("requisicao_ativa").doc(firebaseUser.uid).delete();

// //       _uberNotCalledstatus();

// //       if (_streamSubscriptionRequests != null) {
// //         _streamSubscriptionRequests!.cancel();
// //         _streamSubscriptionRequests = null;
// //       }
// //     });
// //   }

// //   _retrieveActiveRequest() async {
// //     User firebaseUser = await UsuarioFirebase.getCurrentUser();

// //     FirebaseFirestore db = FirebaseFirestore.instance;
// //     DocumentSnapshot documentSnapshot =
// //         await db.collection("requisicao_ativa").doc(firebaseUser.uid).get();

// //     if (documentSnapshot.data() != null) {
// //       Map<String, dynamic> dados =
// //           documentSnapshot.data() as Map<String, dynamic>;
// //       _idRequest = dados["id_requisicao"];

// //       _addRequisitionListener(_idRequest!);
// //     } else {
// //       _uberNotCalledstatus();
// //     }
// //   }

// //   _addRequisitionListener(String idRequest) async {
// //     FirebaseFirestore db = FirebaseFirestore.instance;
// //     _streamSubscriptionRequests = await db
// //         .collection("requisicoes")
// //         .doc(idRequest)
// //         .snapshots()
// //         .listen((snapshot) {
// //       if (snapshot.data() != null) {
// //         Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
// //         _dataRequest = data;
// //         String status = data?["status"];
// //         _idRequest = data?["id"];

// //         switch (status) {
// //           case StatusRequisicao.AGUARDANDO:
// //             _statusWaiting();
// //             break;
// //           case StatusRequisicao.A_CAMINHO:
// //             _statusOnTheWay();
// //             break;
// //           case StatusRequisicao.VIAGEM:
// //             _statusTravel();
// //             break;
// //           case StatusRequisicao.FINALIZADA:
// //             _statusFinished();
// //             break;
// //           case StatusRequisicao.CONFIRMADA:
// //             _statusConfirmation();
// //             break;
// //         }
// //       }
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     //_recuperarUltimaLocalizacaoConhecida();
// //     _addListenerLocation();
// //     _retrieveLastKnownLocation();

// //     //adicionar listener para requisicao ativa
// //     _retrieveActiveRequest();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         title: Text("Panel Penumpang", style: TextStyle(color: Colors.black)),
// //         actions: [
// //           PopupMenuButton<String>(
// //               onSelected: _chooseMenuItem,
// //               itemBuilder: (context) {
// //                 return itemsMenu.map((String item) {
// //                   return PopupMenuItem<String>(
// //                     value: item,
// //                     child: Text(item),
// //                   );
// //                 }).toList();
// //               })
// //         ],
// //       ),
// //       body: Container(
// //         child: Stack(
// //           children: [
// //             GoogleMap(
// //               mapType: MapType.normal,
// //               initialCameraPosition: _positionCamera,
// //               onMapCreated: _onMapCreated,
// //               //myLocationEnabled: true,
// //               myLocationButtonEnabled: true,
// //               markers: _markers,
// //             ),
// //             Visibility(
// //                 visible: _displayDestinationAddressBox,
// //                 child: Stack(
// //                   children: [
// //                     Positioned(
// //                         top: 0,
// //                         left: 0,
// //                         right: 0,
// //                         child: Padding(
// //                           padding: EdgeInsets.all(10),
// //                           child: Container(
// //                             height: 50,
// //                             width: double.infinity,
// //                             decoration: BoxDecoration(
// //                                 border: Border.all(color: Colors.grey),
// //                                 borderRadius: BorderRadius.circular(3),
// //                                 color: Colors.white),
// //                             child: TextField(
// //                               readOnly: true,
// //                               decoration: InputDecoration(
// //                                   icon: Container(
// //                                     margin: EdgeInsets.only(
// //                                       left: 20,
// //                                     ),
// //                                     width: 10,
// //                                     height: 40,
// //                                     child: Icon(
// //                                       Icons.location_on,
// //                                       color: Colors.green,
// //                                     ),
// //                                   ),
// //                                   hintText: "Lokasi Saya",
// //                                   border: InputBorder.none,
// //                                   contentPadding: EdgeInsets.only(left: 15)),
// //                             ),
// //                           ),
// //                         )),
// //                     Positioned(
// //                         top: 55,
// //                         left: 0,
// //                         right: 0,
// //                         child: Padding(
// //                           padding: EdgeInsets.all(10),
// //                           child: Container(
// //                             height: 50,
// //                             width: double.infinity,
// //                             decoration: BoxDecoration(
// //                                 border: Border.all(color: Colors.grey),
// //                                 borderRadius: BorderRadius.circular(3),
// //                                 color: Colors.white),
// //                             child: TextField(
// //                               controller: _controllerDestino,
// //                               decoration: InputDecoration(
// //                                   icon: Container(
// //                                     margin: EdgeInsets.only(
// //                                       left: 20,
// //                                     ),
// //                                     width: 10,
// //                                     height: 40,
// //                                     child: Icon(
// //                                       Icons.local_taxi,
// //                                       color: Colors.black,
// //                                     ),
// //                                   ),
// //                                   hintText: "Masukkan tujuan",
// //                                   border: InputBorder.none,
// //                                   contentPadding: EdgeInsets.only(left: 15)),
// //                             ),
// //                           ),
// //                         ))
// //                   ],
// //                 )),
// //             Positioned(
// //               right: 0,
// //               left: 0,
// //               bottom: 0,
// //               child: Padding(
// //                 padding: Platform.isIOS
// //                     ? EdgeInsets.fromLTRB(20, 10, 20, 25)
// //                     : EdgeInsets.all(10),
// //                 child: ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                       backgroundColor: _colorButton,
// //                       padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
// //                   onPressed: () {
// //                     _functionButton!();
// //                   },
// //                   child: Text(
// //                     _textButton,
// //                     style: TextStyle(color: Colors.white, fontSize: 20),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     _streamSubscriptionRequests?.cancel();
// //     _streamSubscriptionRequests = null;
// //   }
// // }

// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:damri/model/Request.dart';
// import 'package:damri/util/UserFirebase.dart';
// import 'dart:io';
// import '../model/Destination.dart';
// import '../model/Marker.dart';
// import '../model/User.dart';
// import '../util/StatusRequest.dart';

// class PainelPassageiro extends StatefulWidget {
//   const PainelPassageiro({Key? key}) : super(key: key);

//   @override
//   State<PainelPassageiro> createState() => _PainelPassageiroState();
// }

// class _PainelPassageiroState extends State<PainelPassageiro> {
//   TextEditingController _controllerDestino =
//       TextEditingController(text: "av. tiradentes, 380 - Maringa PR");
//   Completer<GoogleMapController> _controller = Completer();
//   Set<Marker> _marcadores = {};
//   String? _idRequisicao;
//   Position? _localPassageiro;
//   Map<String, dynamic>? _dadosRequisicao;
//   StreamSubscription<DocumentSnapshot>? _streamSubscriptionRequisicoes;

//   //Controles para exibição na tela
//   bool _exibirCaixaEnderecoDestino = true;
//   String _textoBotao = "Cari Bus";
//   Color _corBotao = Color.fromARGB(255, 32, 19, 80);
//   Function? _funcaoBotao;

//   CameraPosition _posicaoCamera = CameraPosition(
//     target: LatLng(-6.914864, 107.608238),
//     zoom: 18,
//   );

//   _onMapCreated(GoogleMapController controller) {
//     _controller.complete(controller);
//   }

//   _recuperarUltimaLocalizacaoConhecida() async {
//     Position? position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     if (position != null) {
//       setState(() {
//         _exibirMarcadorPassageiro(position);

//         _posicaoCamera = CameraPosition(
//             target: LatLng(position.latitude, position.longitude), zoom: 19);
//         _localPassageiro = position;
//         _movimentarCamera(_posicaoCamera);
//       });
//     }
//   }

//   _movimentarCamera(CameraPosition cameraPosition) async {
//     GoogleMapController googleMapController = await _controller.future;
//     googleMapController
//         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//   }

//   _adicionarListenerLocalizacao() async {
//     LocationPermission permission;
//     await Geolocator.checkPermission();
//     permission = await Geolocator.requestPermission();

//     var locationSetings =
//         LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

//     Geolocator.getPositionStream(locationSettings: locationSetings)
//         .listen((Position position) {
//       if (_idRequisicao != null && _idRequisicao!.isNotEmpty) {
//         //Atualiza local do passageiro
//         UsuarioFirebase.updateDataLocation(_idRequisicao!, position.latitude,
//             position.longitude, "passageiro");
//       } else {
//         setState(() {
//           _localPassageiro = position;
//         });
//         _statusUberNaoChamado();
//       }
//     });
//   }

//   List<String> itensMenu = ["Informasi", "Profile", "Logout"];

//   _deslogarUsuario() {
//     FirebaseAuth auth = FirebaseAuth.instance;

//     auth.signOut();
//     Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
//   }

//   _userProfile() {
//     setState(() {
//       Navigator.pushReplacementNamed(context, "/userProfile");
//     });
//   }

//   _info() {
//     Navigator.pushReplacementNamed(context, "/informasi");
//   }

//   _escolhaMenuItem(String escolha) {
//     switch (escolha) {
//       case "Logout":
//         _deslogarUsuario();
//         break;
//       case "Profile":
//         _userProfile();
//         break;
//       case "Informasi":
//         _info();
//         break;
//     }
//   }

//   _chamarUber() async {
//     String enderecoDestino = _controllerDestino.text;

//     List<Location> listaLocalizacoes =
//         await GeocodingPlatform.instance.locationFromAddress(enderecoDestino);

//     if (listaLocalizacoes.isNotEmpty) {
//       Location localizacao = listaLocalizacoes[0];
//       List<Placemark> listaEnderecos = await GeocodingPlatform.instance
//           .placemarkFromCoordinates(
//               localizacao.latitude, localizacao.longitude);
//       if (listaEnderecos.isNotEmpty) {
//         Placemark endereco = listaEnderecos[0];

//         Destino destino = Destino();
//         destino.cidade = endereco.subAdministrativeArea;
//         destino.cep = endereco.postalCode;
//         destino.bairro = endereco.subLocality;
//         destino.rua = endereco.thoroughfare;
//         destino.numero = endereco.subThoroughfare;

//         destino.latitude = localizacao.latitude;
//         destino.longitude = localizacao.longitude;

//         String enderecoConfirmacao;
//         enderecoConfirmacao = "\n Kota: ${destino.cidade}";
//         enderecoConfirmacao += "\n Jalan ${destino.rua}, ${destino.numero}";
//         enderecoConfirmacao += "\n Lingkungan: ${destino.bairro}";
//         enderecoConfirmacao += "\n Kode Pos: ${destino.cep}";

//         showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text("Konfirmasi alamat"),
//                 content: Text(enderecoConfirmacao),
//                 contentPadding: EdgeInsets.all(16),
//                 actions: [
//                   TextButton(
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.red),
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   TextButton(
//                     child: Text(
//                       "Konfirmasi",
//                       style: TextStyle(color: Colors.green),
//                     ),
//                     onPressed: () {
//                       //salvar requisicao
//                       _salvarRequisicao(destino);

//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               );
//             });
//       }
//     } else {
//       //algum controle/aviso para preencher todos os campos.
//     }
//   }

//   _exibirMarcadorPassageiro(Position local) async {
//     double pixelRatio = MediaQuery.of(context).devicePixelRatio;

//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: pixelRatio),
//             "imagens/passageiro.png")
//         .then((BitmapDescriptor icone) {
//       Marker marcadorPassageiro = Marker(
//           markerId: MarkerId("marcador-passageiro"),
//           position: LatLng(local.latitude, local.longitude),
//           infoWindow: InfoWindow(title: "Location Saya"),
//           icon: icone);

//       setState(() {
//         _marcadores.add(marcadorPassageiro);
//       });
//     });
//   }

//   _salvarRequisicao(Destino destino) async {
//     /*
//     + requisicao
//        + ID_REQUISICAO
//           + destino (rua, endereço, latitude...)
//           + passageiro (nome, email ...)
//           + motorista (nome, email ...)
//           + status (aguardando, a caminho...finalizada)
//      */

//     Users passageiro = await UsuarioFirebase.getLoginUserData();
//     passageiro.latitude = _localPassageiro?.latitude;
//     passageiro.longitude = _localPassageiro?.longitude;

//     Requisicao requisicao = Requisicao();
//     requisicao.destination = destino;
//     requisicao.penumpang = passageiro;
//     requisicao.status = StatusRequisicao.AGUARDANDO;

//     FirebaseFirestore db = FirebaseFirestore.instance;

//     //Salvar requisição ativa
//     db.collection("requisicoes").doc(requisicao.id).set(requisicao.toMap());

//     //Salvar requisição ativa
//     Map<String, dynamic> dadosRequisicaoAtiva = {};
//     dadosRequisicaoAtiva["id_requisicao"] = requisicao.id;
//     dadosRequisicaoAtiva["id_usuario"] = passageiro.idUser;
//     dadosRequisicaoAtiva["status"] = StatusRequisicao.AGUARDANDO;

//     db
//         .collection("requisicao_ativa")
//         .doc(passageiro.idUser)
//         .set(dadosRequisicaoAtiva);

//     //Adicionar listener requisicao
//     if (_streamSubscriptionRequisicoes == null) {
//       _adicionarListenerRequisicao(requisicao.id!);
//     }
//   }

//   _alterarBotaoPrincipal(String texto, Color cor, Function funcao) {
//     setState(() {
//       _textoBotao = texto;
//       _corBotao = cor;
//       _funcaoBotao = funcao;
//     });
//   }

//   _statusUberNaoChamado() async {
//     _exibirCaixaEnderecoDestino = true;
//     _alterarBotaoPrincipal("Cari Bus", Color.fromARGB(255, 28, 20, 82), () {
//       _chamarUber();
//     });

//     //if(_localPassageiro != null ){
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _exibirMarcadorPassageiro(position);
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 18,
//     );
//     _movimentarCamera(cameraPosition);
//     //}
//   }

//   _statusAguardando() async {
//     _exibirCaixaEnderecoDestino = false;
//     _alterarBotaoPrincipal("Cancel", Colors.red, () {
//       _cancelarUber();
//     });

//     // double passageiroLat = _dadosRequisicao?["passageiro"]["latitude"];
//     // double passageiroLon = _dadosRequisicao?["passageiro"]["longitude"];
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _exibirMarcadorPassageiro(position);
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 18,
//     );
//     _movimentarCamera(cameraPosition);
//   }

//   _statusACaminho() {
//     _exibirCaixaEnderecoDestino = false;
//     _alterarBotaoPrincipal("Motorista a caminho", Colors.grey, () {});

//     double latitudePassageiro = _dadosRequisicao?["passageiro"]["latitude"];
//     double longitudePassageiro = _dadosRequisicao?["passageiro"]["longitude"];

//     double latitudeMotorista = _dadosRequisicao?["motorista"]["latitude"];
//     double longitudeMotorista = _dadosRequisicao?["motorista"]["longitude"];

//     Marcador marcadorOrigem = Marcador(
//         LatLng(latitudeMotorista, longitudeMotorista),
//         "imagens/motorista.png",
//         "Lokasi Bus");

//     Marcador marcadorDestino = Marcador(
//         LatLng(latitudePassageiro, longitudePassageiro),
//         "imagens/passageiro.png",
//         "Lokasi Tujuan");

//     _exibirCentralizarDoisMarcadores(marcadorOrigem, marcadorDestino);
//   }

//   _statusEmViagem() {
//     _exibirCaixaEnderecoDestino = false;

//     _alterarBotaoPrincipal(
//       "bepergian",
//       Colors.grey,
//       () {},
//     );

//     double latitudeDestino = _dadosRequisicao!["destino"]["latitude"];
//     double longitudeDestino = _dadosRequisicao!["destino"]["longitude"];

//     double latitudeOrigem = _dadosRequisicao!["motorista"]["latitude"];
//     double longitudeOrigem = _dadosRequisicao!["motorista"]["longitude"];

//     Marcador marcadorOrigem = Marcador(LatLng(latitudeOrigem, longitudeOrigem),
//         "imagens/motorista.png", "Lokasi bus");

//     Marcador marcadorDestino = Marcador(
//         LatLng(latitudeDestino, longitudeDestino),
//         "imagens/destino.png",
//         "Lokasi Tujuan");

//     _exibirCentralizarDoisMarcadores(marcadorOrigem, marcadorDestino);
//   }

//   _statusFinalizada() async {
//     //Calcula valor da corrida
//     double latitudeDestino = _dadosRequisicao!["destino"]["latitude"];
//     double longitudeDestino = _dadosRequisicao!["destino"]["longitude"];

//     double latitudeOrigem = _dadosRequisicao!["origem"]["latitude"];
//     double longitudeOrigem = _dadosRequisicao!["origem"]["longitude"];

//     //para calcular um valor mais exato basta consumir uma API do google
//     // que calcula a distanciaconsiderando as ruas do percurso.
//     double distanciaEmMetros = Geolocator.distanceBetween(
//         latitudeOrigem, longitudeOrigem, latitudeDestino, longitudeDestino);

//     //converte para KM
//     double distanciaKM = distanciaEmMetros / 1000;
//     double valorViagem = distanciaKM * 8;

//     //8 é o valor cobrado por KM
//     var f = NumberFormat('#,##0.00', 'pt_BR');
//     var valorViagemFormatado = f.format(valorViagem);

//     _alterarBotaoPrincipal(
//       "Total - R\$ $valorViagemFormatado",
//       Colors.green,
//       () {},
//     );

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _exibirMarcador(position, "imagens/destino.png", "Destino");

//     //setState(() {
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 18,
//     );
//     // });
//     _movimentarCamera(cameraPosition);
//   }

//   _statusConfirmada() async {
//     if (_streamSubscriptionRequisicoes != null) {
//       _streamSubscriptionRequisicoes!.cancel();
//       _streamSubscriptionRequisicoes = null;
//     }

//     _exibirCaixaEnderecoDestino = true;

//     _alterarBotaoPrincipal("Cari Bus", Color.fromARGB(255, 21, 47, 130), () {
//       _chamarUber();
//     });

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _exibirMarcadorPassageiro(position);
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 18,
//     );
//     _movimentarCamera(cameraPosition);

//     _dadosRequisicao = {};

//     _adicionarListenerLocalizacao();
//   }

//   _exibirMarcador(Position local, String icone, String infoWindow) async {
//     double pixelRatio = MediaQuery.of(context).devicePixelRatio;

//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: pixelRatio), icone)
//         .then((BitmapDescriptor bitmapDescriptor) {
//       Marker marcador = Marker(
//           markerId: MarkerId(icone),
//           position: LatLng(local.latitude, local.longitude),
//           infoWindow: InfoWindow(title: infoWindow),
//           icon: bitmapDescriptor);

//       setState(() {
//         _marcadores.add(marcador);
//       });
//     });
//   }

//   _exibirDoisMArcadores(Marcador marcadorOrigem, Marcador marcadorDestino) {
//     double pixelRatio = MediaQuery.of(context).devicePixelRatio;

//     LatLng latLngOrigem = marcadorOrigem.local;
//     LatLng latLngDestino = marcadorDestino.local;

//     Set<Marker> _listaMarcadores = {};
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: pixelRatio),
//             marcadorOrigem.caminhoImagem)
//         .then((BitmapDescriptor icone) {
//       Marker mOrigem = Marker(
//           markerId: MarkerId(marcadorOrigem.caminhoImagem),
//           position: LatLng(latLngOrigem.latitude, latLngOrigem.longitude),
//           infoWindow: InfoWindow(title: marcadorOrigem.titulo),
//           icon: icone);
//       _listaMarcadores.add(mOrigem);
//     });

//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: pixelRatio),
//             marcadorDestino.caminhoImagem)
//         .then((BitmapDescriptor icone) {
//       Marker mDestino = Marker(
//           markerId: MarkerId(marcadorDestino.caminhoImagem),
//           position: LatLng(latLngDestino.latitude, latLngDestino.longitude),
//           infoWindow: InfoWindow(title: marcadorDestino.titulo),
//           icon: icone);
//       _listaMarcadores.add(mDestino);
//     });

//     setState(() {
//       _marcadores = _listaMarcadores;
//     });
//   }

//   _exibirCentralizarDoisMarcadores(
//       Marcador marcadorOrigem, Marcador marcadorDestino) {
//     double latitudeOrigem = marcadorOrigem.local.latitude;
//     double longitudeOrigem = marcadorOrigem.local.longitude;

//     double latitudeDestino = marcadorDestino.local.latitude;
//     double longitudeDestino = marcadorDestino.local.longitude;

//     _exibirDoisMArcadores(
//       marcadorOrigem,
//       marcadorDestino,
//     );

//     //'southwest.latitude <= northeast.latitude' : is not true
//     double? nLat, nLon, sLat, sLon;

//     if (latitudeOrigem <= latitudeDestino) {
//       sLat = latitudeOrigem;
//       nLat = latitudeDestino;
//     } else {
//       sLat = latitudeDestino;
//       nLat = latitudeOrigem;
//     }

//     if (longitudeOrigem <= longitudeDestino) {
//       sLon = longitudeOrigem;
//       nLon = longitudeDestino;
//     } else {
//       sLon = longitudeDestino;
//       nLon = longitudeOrigem;
//     }

//     _movimentarCameraBounds(LatLngBounds(
//       northeast: LatLng(nLat, nLon),
//       southwest: LatLng(sLat, sLon),
//     ));
//   }

//   _movimentarCameraBounds(LatLngBounds latLngBounds) async {
//     GoogleMapController googleMapController = await _controller.future;
//     googleMapController
//         .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
//   }

//   _cancelarUber() async {
//     User firebaseUser = await UsuarioFirebase.getCurrentUser();
//     FirebaseFirestore db = FirebaseFirestore.instance;
//     db
//         .collection("requisicoes")
//         .doc(_idRequisicao)
//         .update({"status": StatusRequisicao.CANCELADA}).then((_) {
//       db.collection("requisicao_ativa").doc(firebaseUser.uid).delete();

//       _statusUberNaoChamado();

//       if (_streamSubscriptionRequisicoes != null) {
//         _streamSubscriptionRequisicoes!.cancel();
//         _streamSubscriptionRequisicoes = null;
//       }
//     });
//   }

//   _recuperarRequisicaoAtiva() async {
//     User firebaseUser = await UsuarioFirebase.getCurrentUser();

//     FirebaseFirestore db = FirebaseFirestore.instance;
//     DocumentSnapshot documentSnapshot =
//         await db.collection("requisicao_ativa").doc(firebaseUser.uid).get();

//     if (documentSnapshot.data() != null) {
//       Map<String, dynamic> dados =
//           documentSnapshot.data() as Map<String, dynamic>;
//       _idRequisicao = dados["id_requisicao"];

//       _adicionarListenerRequisicao(_idRequisicao!);
//     } else {
//       _statusUberNaoChamado();
//     }
//   }

//   _adicionarListenerRequisicao(String idRequisicao) async {
//     FirebaseFirestore db = FirebaseFirestore.instance;
//     _streamSubscriptionRequisicoes = await db
//         .collection("requisicoes")
//         .doc(idRequisicao)
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.data() != null) {
//         Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
//         _dadosRequisicao = dados;
//         String status = dados?["status"];
//         _idRequisicao = dados?["id"];

//         switch (status) {
//           case StatusRequisicao.AGUARDANDO:
//             _statusAguardando();
//             break;
//           case StatusRequisicao.A_CAMINHO:
//             _statusACaminho();
//             break;
//           case StatusRequisicao.VIAGEM:
//             _statusEmViagem();
//             break;
//           case StatusRequisicao.FINALIZADA:
//             _statusFinalizada();
//             break;
//           case StatusRequisicao.CONFIRMADA:
//             _statusConfirmada();
//             break;
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     //_recuperarUltimaLocalizacaoConhecida();
//     _adicionarListenerLocalizacao();
//     _recuperarUltimaLocalizacaoConhecida();

//     //adicionar listener para requisicao ativa
//     _recuperarRequisicaoAtiva();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Panel Penumpang"),
//         actions: [
//           PopupMenuButton<String>(
//               onSelected: _escolhaMenuItem,
//               itemBuilder: (context) {
//                 return itensMenu.map((String item) {
//                   return PopupMenuItem<String>(
//                     value: item,
//                     child: Text(item),
//                   );
//                 }).toList();
//               })
//         ],
//       ),
//       body: Container(
//         child: Stack(
//           children: [
//             GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: _posicaoCamera,
//               onMapCreated: _onMapCreated,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//               markers: _marcadores,
//             ),
//             Visibility(
//                 visible: _exibirCaixaEnderecoDestino,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                         top: 0,
//                         left: 0,
//                         right: 0,
//                         child: Padding(
//                           padding: EdgeInsets.all(10),
//                           child: Container(
//                             height: 50,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey),
//                                 borderRadius: BorderRadius.circular(3),
//                                 color: Colors.white),
//                             child: TextField(
//                               readOnly: true,
//                               decoration: InputDecoration(
//                                   icon: Container(
//                                     margin: EdgeInsets.only(
//                                       left: 20,
//                                     ),
//                                     width: 10,
//                                     height: 40,
//                                     child: Icon(
//                                       Icons.location_on,
//                                       color: Colors.green,
//                                     ),
//                                   ),
//                                   hintText: "Meu local",
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.only(left: 15)),
//                             ),
//                           ),
//                         )),
//                     Positioned(
//                         top: 55,
//                         left: 0,
//                         right: 0,
//                         child: Padding(
//                           padding: EdgeInsets.all(10),
//                           child: Container(
//                             height: 50,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey),
//                                 borderRadius: BorderRadius.circular(3),
//                                 color: Colors.white),
//                             child: TextField(
//                               controller: _controllerDestino,
//                               decoration: InputDecoration(
//                                   icon: Container(
//                                     margin: EdgeInsets.only(
//                                       left: 20,
//                                     ),
//                                     width: 10,
//                                     height: 40,
//                                     child: Icon(
//                                       Icons.local_taxi,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   hintText: "Digite o destino",
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.only(left: 15)),
//                             ),
//                           ),
//                         ))
//                   ],
//                 )),
//             Positioned(
//               right: 0,
//               left: 0,
//               bottom: 0,
//               child: Padding(
//                 padding: Platform.isIOS
//                     ? EdgeInsets.fromLTRB(20, 10, 20, 25)
//                     : EdgeInsets.all(10),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       primary: _corBotao,
//                       padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
//                   onPressed: () {
//                     _funcaoBotao!();
//                   },
//                   child: Text(
//                     _textoBotao,
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _streamSubscriptionRequisicoes?.cancel();
//     _streamSubscriptionRequisicoes = null;
//   }
// }
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:damri/model/Requisicao.dart';
// import 'package:damri/util/UsuarioFirebase.dart';
// import 'dart:io';
// import '../model/Destino.dart';
// import '../model/Marcador.dart';
// import '../model/Usuario.dart';
// import '../util/StatusRequisicao.dart';

// class PainelPassageiro extends StatefulWidget {
//   const PainelPassageiro({Key? key}) : super(key: key);

//   @override
//   State<PainelPassageiro> createState() => _PainelPassageiroState();
// }

// class _PainelPassageiroState extends State<PainelPassageiro> {
//   TextEditingController _controllerDestino = TextEditingController(text: "");
//   Completer<GoogleMapController> _controller = Completer();
//   Set<Marker> _markers = {};
//   String? _idRequest;
//   Position? _locationPassenger;
//   Map<String, dynamic>? _dataRequest;
//   StreamSubscription<DocumentSnapshot>? _streamSubscriptionRequests;

//   //Controles para exibição na tela
//   bool _displayDestinationAddressBox = true;
//   String _textButton = "Cari Bus";
//   Color _colorButton = Color.fromARGB(255, 11, 57, 94);
//   Function? _functionButton;

//   CameraPosition _positionCamera = CameraPosition(
//     target: LatLng(-6.914864, 107.608238),
//     zoom: 18,
//   );

//   _onMapCreated(GoogleMapController controller) {
//     _controller.complete(controller);
//   }

//   _retrieveLastKnownLocation() async {
//     Position? position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     if (position != null) {
//       setState(() {
//         _displaymarkPassenger(position);

//         _positionCamera = CameraPosition(
//             target: LatLng(position.latitude, position.longitude), zoom: 19);
//         _locationPassenger = position;
//         _moveCamera(_positionCamera);
//       });
//     }
//   }

//   _moveCamera(CameraPosition cameraPosition) async {
//     GoogleMapController googleMapController = await _controller.future;
//     googleMapController
//         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//   }

//   _addListenerLocation() async {
//     LocationPermission permission;
//     await Geolocator.checkPermission();
//     permission = await Geolocator.requestPermission();

//     var locationSetings =
//         LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

//     Geolocator.getPositionStream(locationSettings: locationSetings)
//         .listen((Position position) {
//       if (_idRequest != null && _idRequest!.isNotEmpty) {
//         //Atualiza local do passageiro
//         UsuarioFirebase.updateDataLocation(
//             _idRequest!, position.latitude, position.longitude, "passageiro");
//       } else {
//         setState(() {
//           _locationPassenger = position;
//         });
//         _uberNotCalledstatus();
//       }
//     });
//   }

//   List<String> itemsMenu = ["Informasi", "Profile", "Logout"];

//   _logoutUser() {
//     FirebaseAuth auth = FirebaseAuth.instance;

//     auth.signOut();
//     Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
//   }

//   _userProfile() {
//     setState(() {
//       Navigator.pushReplacementNamed(context, "/userProfile");
//     });
//   }

//   _info() {
//     Navigator.pushReplacementNamed(context, "/informasi");
//   }

//   _chooseMenuItem(String choice) {
//     switch (choice) {
//       case "Logout":
//         _logoutUser();
//         break;
//       case "Konfigurasi":
//         break;
//       case "Profile":
//         _userProfile();
//         break;
//       case "Informasi":
//         _info();
//         break;
//     }
//   }

//   _callBus() async {
//     String enderecoDestino = _controllerDestino.text;

//     List<Location> listaLocalizacoes =
//         await GeocodingPlatform.instance.locationFromAddress(enderecoDestino);

//     if (listaLocalizacoes.isNotEmpty) {
//       Location localizacao = listaLocalizacoes[0];
//       List<Placemark> listaEnderecos = await GeocodingPlatform.instance
//           .placemarkFromCoordinates(
//               localizacao.latitude, localizacao.longitude);
//       if (listaEnderecos.isNotEmpty) {
//         Placemark endereco = listaEnderecos[0];

//         Destino destino = Destino();
//         destino.cidade = endereco.subAdministrativeArea;
//         destino.cep = endereco.postalCode;
//         destino.bairro = endereco.subLocality;
//         destino.rua = endereco.thoroughfare;
//         destino.numero = endereco.subThoroughfare;

//         destino.latitude = localizacao.latitude;
//         destino.longitude = localizacao.longitude;

//         String enderecoConfirmacao;
//         enderecoConfirmacao = "\n Kota: ${destino.cidade}";
//         enderecoConfirmacao += "\n Jalan ${destino.rua}, ${destino.numero}";
//         enderecoConfirmacao += "\n Lingkungan: ${destino.bairro}";
//         enderecoConfirmacao += "\n Kode Pos: ${destino.cep}";

//         showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text("Konfirmasi alamat"),
//                 content: Text(enderecoConfirmacao),
//                 contentPadding: EdgeInsets.all(16),
//                 actions: [
//                   TextButton(
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.red),
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   TextButton(
//                     child: Text(
//                       "Konfirmasi",
//                       style: TextStyle(color: Colors.green),
//                     ),
//                     onPressed: () {
//                       //salvar requisicao
//                       _saveRequisition(destino);

//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               );
//             });
//       }
//     } else {
//       //algum controle/aviso para preencher todos os campos.
//     }
//   }

//   _displaymarkPassenger(Position local) async {
//     double pixelRatio = MediaQuery.of(context).devicePixelRatio;

//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: pixelRatio),
//             "imagens/passageiro.png")
//         .then((BitmapDescriptor icone) {
//       Marker marcadorPassageiro = Marker(
//           markerId: MarkerId("marcador-passageiro"),
//           position: LatLng(local.latitude, local.longitude),
//           infoWindow: InfoWindow(title: "Lokasi Sayal"),
//           icon: icone);

//       setState(() {
//         _markers.add(marcadorPassageiro);
//       });
//     });
//   }

//   _saveRequisition(Destino destino) async {
//     /*
//     + requisicao
//        + ID_REQUISICAO
//           + destino (rua, endereço, latitude...)
//           + passageiro (nome, email ...)
//           + motorista (nome, email ...)
//           + status (aguardando, a caminho...finalizada)
//      */

//     Usuario passageiro = await UsuarioFirebase.getLoginUserData();
//     passageiro.latitude = _locationPassenger?.latitude;
//     passageiro.longitude = _locationPassenger?.longitude;

//     Requisicao requisicao = Requisicao();
//     requisicao.destino = destino;
//     requisicao.passageiro = passageiro;
//     requisicao.status = StatusRequisicao.AGUARDANDO;

//     FirebaseFirestore db = FirebaseFirestore.instance;

//     //Salvar requisição ativa
//     db.collection("requisicoes").doc(requisicao.id).set(requisicao.toMap());

//     //Salvar requisição ativa
//     Map<String, dynamic> dadosRequisicaoAtiva = {};
//     dadosRequisicaoAtiva["id_requisicao"] = requisicao.id;
//     dadosRequisicaoAtiva["id_usuario"] = passageiro.idUsuario;
//     dadosRequisicaoAtiva["status"] = StatusRequisicao.AGUARDANDO;

//     db
//         .collection("requisicao_ativa")
//         .doc(passageiro.idUsuario)
//         .set(dadosRequisicaoAtiva);

//     //Adicionar listener requisicao
//     if (_streamSubscriptionRequests == null) {
//       _addRequisitionListener(requisicao.id!);
//     }
//   }

//   _changeMainButton(String text, Color color, Function func) {
//     setState(() {
//       _textButton = text;
//       _colorButton = color;
//       _functionButton = func;
//     });
//   }

//   _uberNotCalledstatus() async {
//     _displayDestinationAddressBox = true;
//     _changeMainButton("Cari Damri", Color(0xff1ebbd8), () {
//       _callBus();
//     });

//     //if(_localPassageiro != null ){
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _displaymarkPassenger(position);
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 18,
//     );
//     _moveCamera(cameraPosition);
//     //}
//   }

//   _statusWaiting() async {
//     _displayDestinationAddressBox = false;
//     _changeMainButton("Cancel", Colors.red, () {
//       _cancelBus();
//     });

//     // double passageiroLat = _dadosRequisicao?["passageiro"]["latitude"];
//     // double passageiroLon = _dadosRequisicao?["passageiro"]["longitude"];
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _displaymarkPassenger(position);
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 18,
//     );
//     _moveCamera(cameraPosition);
//   }

//   _statusOnTheWay() {
//     _displayDestinationAddressBox = false;
//     _changeMainButton("Bus di jalan", Colors.grey, () {});

//     double latitudePassageiro = _dataRequest?["passageiro"]["latitude"];
//     double longitudePassageiro = _dataRequest?["passageiro"]["longitude"];

//     double latitudeMotorista = _dataRequest?["motorista"]["latitude"];
//     double longitudeMotorista = _dataRequest?["motorista"]["longitude"];

//     Marcador marcadorOrigem = Marcador(
//         LatLng(latitudeMotorista, longitudeMotorista),
//         "imagens/motorista.png",
//         "Location Driver");

//     Marcador marcadorDestino = Marcador(
//         LatLng(latitudePassageiro, longitudePassageiro),
//         "imagens/passageiro.png",
//         "local destino");

//     _displayCenterTwoBookmarks(marcadorOrigem, marcadorDestino);
//   }

//   _statusTravel() {
//     _displayDestinationAddressBox = false;

//     _changeMainButton(
//       "Berpergian",
//       Colors.grey,
//       () {},
//     );

//     double latitudeDestino = _dataRequest!["destino"]["latitude"];
//     double longitudeDestino = _dataRequest!["destino"]["longitude"];

//     double latitudeOrigem = _dataRequest!["motorista"]["latitude"];
//     double longitudeOrigem = _dataRequest!["motorista"]["longitude"];

//     Marcador marcadorOrigem = Marcador(LatLng(latitudeOrigem, longitudeOrigem),
//         "imagens/motorista.png", "local motorista");

//     Marcador marcadorDestino = Marcador(
//         LatLng(latitudeDestino, longitudeDestino),
//         "imagens/destino.png",
//         "local destino");

//     _displayCenterTwoBookmarks(marcadorOrigem, marcadorDestino);
//   }

//   _statusFinished() async {
//     //Calcula valor da corrida
//     double latitudeDestino = _dataRequest!["destino"]["latitude"];
//     double longitudeDestino = _dataRequest!["destino"]["longitude"];

//     double latitudeOrigem = _dataRequest!["origem"]["latitude"];
//     double longitudeOrigem = _dataRequest!["origem"]["longitude"];

//     //para calcular um valor mais exato basta consumir uma API do google
//     // que calcula a distanciaconsiderando as ruas do percurso.
//     double distanciaEmMetros = Geolocator.distanceBetween(
//         latitudeOrigem, longitudeOrigem, latitudeDestino, longitudeDestino);

//     //converte para KM
//     double distanciaKM = distanciaEmMetros / 1000;
//     double valorViagem = distanciaKM * 8;

//     //8 é o valor cobrado por KM
//     var f = NumberFormat('#,##0.00', 'pt_BR');
//     var valorViagemFormatado = f.format(valorViagem);

//     _changeMainButton(
//       "Total - R\$ $valorViagemFormatado",
//       Colors.green,
//       () {},
//     );

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _displayMark(position, "imagens/destino.png", "Tujuan");

//     //setState(() {
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 18,
//     );
//     // });
//     _moveCamera(cameraPosition);
//   }

//   _statusConfirmation() async {
//     if (_streamSubscriptionRequests != null) {
//       _streamSubscriptionRequests!.cancel();
//       _streamSubscriptionRequests = null;
//     }

//     _displayDestinationAddressBox = true;

//     _changeMainButton("Cari Bus", Color(0xff1ebbd8), () {
//       _callBus();
//     });

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _displaymarkPassenger(position);
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(position.latitude, position.longitude),
//       zoom: 18,
//     );
//     _moveCamera(cameraPosition);

//     _dataRequest = {};

//     _addListenerLocation();
//   }

//   _displayMark(Position local, String icone, String infoWindow) async {
//     double pixelRatio = MediaQuery.of(context).devicePixelRatio;

//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: pixelRatio), icone)
//         .then((BitmapDescriptor bitmapDescriptor) {
//       Marker marcador = Marker(
//           markerId: MarkerId(icone),
//           position: LatLng(local.latitude, local.longitude),
//           infoWindow: InfoWindow(title: infoWindow),
//           icon: bitmapDescriptor);

//       setState(() {
//         _markers.add(marcador);
//       });
//     });
//   }

//   _displayTwoMarkers(Marcador marcadorOrigem, Marcador marcadorDestino) {
//     double pixelRatio = MediaQuery.of(context).devicePixelRatio;

//     LatLng latLngOrigem = marcadorOrigem.local;
//     LatLng latLngDestino = marcadorDestino.local;

//     Set<Marker> _listaMarcadores = {};
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: pixelRatio),
//             marcadorOrigem.caminhoImagem)
//         .then((BitmapDescriptor icone) {
//       Marker mOrigem = Marker(
//           markerId: MarkerId(marcadorOrigem.caminhoImagem),
//           position: LatLng(latLngOrigem.latitude, latLngOrigem.longitude),
//           infoWindow: InfoWindow(title: marcadorOrigem.titulo),
//           icon: icone);
//       _listaMarcadores.add(mOrigem);
//     });

//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: pixelRatio),
//             marcadorDestino.caminhoImagem)
//         .then((BitmapDescriptor icone) {
//       Marker mDestino = Marker(
//           markerId: MarkerId(marcadorDestino.caminhoImagem),
//           position: LatLng(latLngDestino.latitude, latLngDestino.longitude),
//           infoWindow: InfoWindow(title: marcadorDestino.titulo),
//           icon: icone);
//       _listaMarcadores.add(mDestino);
//     });

//     setState(() {
//       _markers = _listaMarcadores;
//     });
//   }

//   _displayCenterTwoBookmarks(
//       Marcador marcadorOrigem, Marcador marcadorDestino) {
//     double latitudeOrigem = marcadorOrigem.local.latitude;
//     double longitudeOrigem = marcadorOrigem.local.longitude;

//     double latitudeDestino = marcadorDestino.local.latitude;
//     double longitudeDestino = marcadorDestino.local.longitude;

//     _displayTwoMarkers(
//       marcadorOrigem,
//       marcadorDestino,
//     );

//     //'southwest.latitude <= northeast.latitude' : is not true
//     double? nLat, nLon, sLat, sLon;

//     if (latitudeOrigem <= latitudeDestino) {
//       sLat = latitudeOrigem;
//       nLat = latitudeDestino;
//     } else {
//       sLat = latitudeDestino;
//       nLat = latitudeOrigem;
//     }

//     if (longitudeOrigem <= longitudeDestino) {
//       sLon = longitudeOrigem;
//       nLon = longitudeDestino;
//     } else {
//       sLon = longitudeDestino;
//       nLon = longitudeOrigem;
//     }

//     _movimentarCameraBounds(LatLngBounds(
//       northeast: LatLng(nLat, nLon),
//       southwest: LatLng(sLat, sLon),
//     ));
//   }

//   _movimentarCameraBounds(LatLngBounds latLngBounds) async {
//     GoogleMapController googleMapController = await _controller.future;
//     googleMapController
//         .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
//   }

//   _cancelBus() async {
//     User firebaseUser = await UsuarioFirebase.getCurrentUser();
//     FirebaseFirestore db = FirebaseFirestore.instance;
//     db
//         .collection("requisicoes")
//         .doc(_idRequest)
//         .update({"status": StatusRequisicao.CANCELADA}).then((_) {
//       db.collection("requisicao_ativa").doc(firebaseUser.uid).delete();

//       _uberNotCalledstatus();

//       if (_streamSubscriptionRequests != null) {
//         _streamSubscriptionRequests!.cancel();
//         _streamSubscriptionRequests = null;
//       }
//     });
//   }

//   _retrieveActiveRequest() async {
//     User firebaseUser = await UsuarioFirebase.getCurrentUser();

//     FirebaseFirestore db = FirebaseFirestore.instance;
//     DocumentSnapshot documentSnapshot =
//         await db.collection("requisicao_ativa").doc(firebaseUser.uid).get();

//     if (documentSnapshot.data() != null) {
//       Map<String, dynamic> dados =
//           documentSnapshot.data() as Map<String, dynamic>;
//       _idRequest = dados["id_requisicao"];

//       _addRequisitionListener(_idRequest!);
//     } else {
//       _uberNotCalledstatus();
//     }
//   }

//   _addRequisitionListener(String idRequest) async {
//     FirebaseFirestore db = FirebaseFirestore.instance;
//     _streamSubscriptionRequests = await db
//         .collection("requisicoes")
//         .doc(idRequest)
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.data() != null) {
//         Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
//         _dataRequest = data;
//         String status = data?["status"];
//         _idRequest = data?["id"];

//         switch (status) {
//           case StatusRequisicao.AGUARDANDO:
//             _statusWaiting();
//             break;
//           case StatusRequisicao.A_CAMINHO:
//             _statusOnTheWay();
//             break;
//           case StatusRequisicao.VIAGEM:
//             _statusTravel();
//             break;
//           case StatusRequisicao.FINALIZADA:
//             _statusFinished();
//             break;
//           case StatusRequisicao.CONFIRMADA:
//             _statusConfirmation();
//             break;
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     //_recuperarUltimaLocalizacaoConhecida();
//     _addListenerLocation();
//     _retrieveLastKnownLocation();

//     //adicionar listener para requisicao ativa
//     _retrieveActiveRequest();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text("Panel Penumpang", style: TextStyle(color: Colors.black)),
//         actions: [
//           PopupMenuButton<String>(
//               onSelected: _chooseMenuItem,
//               itemBuilder: (context) {
//                 return itemsMenu.map((String item) {
//                   return PopupMenuItem<String>(
//                     value: item,
//                     child: Text(item),
//                   );
//                 }).toList();
//               })
//         ],
//       ),
//       body: Container(
//         child: Stack(
//           children: [
//             GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: _positionCamera,
//               onMapCreated: _onMapCreated,
//               //myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//               markers: _markers,
//             ),
//             Visibility(
//                 visible: _displayDestinationAddressBox,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                         top: 0,
//                         left: 0,
//                         right: 0,
//                         child: Padding(
//                           padding: EdgeInsets.all(10),
//                           child: Container(
//                             height: 50,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey),
//                                 borderRadius: BorderRadius.circular(3),
//                                 color: Colors.white),
//                             child: TextField(
//                               readOnly: true,
//                               decoration: InputDecoration(
//                                   icon: Container(
//                                     margin: EdgeInsets.only(
//                                       left: 20,
//                                     ),
//                                     width: 10,
//                                     height: 40,
//                                     child: Icon(
//                                       Icons.location_on,
//                                       color: Colors.green,
//                                     ),
//                                   ),
//                                   hintText: "Lokasi Saya",
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.only(left: 15)),
//                             ),
//                           ),
//                         )),
//                     Positioned(
//                         top: 55,
//                         left: 0,
//                         right: 0,
//                         child: Padding(
//                           padding: EdgeInsets.all(10),
//                           child: Container(
//                             height: 50,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey),
//                                 borderRadius: BorderRadius.circular(3),
//                                 color: Colors.white),
//                             child: TextField(
//                               controller: _controllerDestino,
//                               decoration: InputDecoration(
//                                   icon: Container(
//                                     margin: EdgeInsets.only(
//                                       left: 20,
//                                     ),
//                                     width: 10,
//                                     height: 40,
//                                     child: Icon(
//                                       Icons.local_taxi,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   hintText: "Masukkan tujuan",
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.only(left: 15)),
//                             ),
//                           ),
//                         ))
//                   ],
//                 )),
//             Positioned(
//               right: 0,
//               left: 0,
//               bottom: 0,
//               child: Padding(
//                 padding: Platform.isIOS
//                     ? EdgeInsets.fromLTRB(20, 10, 20, 25)
//                     : EdgeInsets.all(10),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: _colorButton,
//                       padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
//                   onPressed: () {
//                     _functionButton!();
//                   },
//                   child: Text(
//                     _textButton,
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _streamSubscriptionRequests?.cancel();
//     _streamSubscriptionRequests = null;
//   }
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:damri/model/Request.dart';
import 'package:damri/util/UserFirebase.dart';
import 'dart:io';
import '../model/Destination.dart';
import '../model/Marker.dart';
import '../model/User.dart';
import '../util/StatusRequest.dart';

class PanelPenumpang extends StatefulWidget {
  const PanelPenumpang({Key? key}) : super(key: key);

  @override
  State<PanelPenumpang> createState() => _PanelPenumpangState();
}

class _PanelPenumpangState extends State<PanelPenumpang> {
  TextEditingController _controllerDestino = TextEditingController(text: "");
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};
  String? _idRequisicao;
  Position? _localPassageiro;
  Map<String, dynamic>? _dadosRequisicao;
  StreamSubscription<DocumentSnapshot>? _streamSubscriptionRequisicoes;

  //Controles para exibição na tela
  bool _exibirCaixaEnderecoDestino = true;
  String _textoBotao = "Cari Bus";
  Color _corBotao = Color.fromARGB(255, 32, 19, 80);
  Function? _funcaoBotao;

  CameraPosition _posicaoCamera = CameraPosition(
    target: LatLng(-6.914864, 107.608238),
    zoom: 18,
  );

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _recuperarUltimaLocalizacaoConhecida() async {
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (position != null) {
      setState(() {
        _exibirMarcadorPassageiro(position);

        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
        _localPassageiro = position;
        _movimentarCamera(_posicaoCamera);
      });
    }
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _adicionarListenerLocalizacao() async {
    LocationPermission permission;
    await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    var locationSetings =
        LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

    Geolocator.getPositionStream(locationSettings: locationSetings)
        .listen((Position position) {
      if (_idRequisicao != null && _idRequisicao!.isNotEmpty) {
        //Atualiza local do passageiro
        UserFirebase.updateDataLocation(_idRequisicao!, position.latitude,
            position.longitude, "passageiro");
      } else {
        setState(() {
          _localPassageiro = position;
        });
        _statusUberNaoChamado();
      }
    });
  }

  List<String> itensMenu = ["Informasi", "Profile", "Logout"];

  _deslogarUsuario() {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
  }

  _userProfile() {
    setState(() {
      Navigator.pushReplacementNamed(context, "/userProfile");
    });
  }

  _info() {
    Navigator.pushReplacementNamed(context, "/informasi");
  }

  _escolhaMenuItem(String escolha) {
    switch (escolha) {
      case "Logout":
        _deslogarUsuario();
        break;
      case "Profile":
        _userProfile();
        break;
      case "Informasi":
        _info();
        break;
    }
  }

  _chamarUber() async {
    String enderecoDestino = _controllerDestino.text;

    List<Location> listaLocalizacoes =
        await GeocodingPlatform.instance.locationFromAddress(enderecoDestino);

    if (listaLocalizacoes.isNotEmpty) {
      Location localizacao = listaLocalizacoes[0];
      List<Placemark> listaEnderecos = await GeocodingPlatform.instance
          .placemarkFromCoordinates(
              localizacao.latitude, localizacao.longitude);
      if (listaEnderecos.isNotEmpty) {
        Placemark endereco = listaEnderecos[0];

        Destination destino = Destination();
        destino.kota = endereco.subAdministrativeArea;
        destino.kodePos = endereco.postalCode;
        destino.daerah = endereco.subLocality;
        destino.street = endereco.thoroughfare;
        destino.number = endereco.subThoroughfare;

        destino.latitude = localizacao.latitude;
        destino.longitude = localizacao.longitude;

        String enderecoConfirmacao;
        enderecoConfirmacao = "\n Kota: ${destino.kota}";
        enderecoConfirmacao += "\n Jalan ${destino.street}, ${destino.number}";
        enderecoConfirmacao += "\n Lingkungan: ${destino.daerah}";
        enderecoConfirmacao += "\n Kode Pos: ${destino.kodePos}";

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Konfirmasi alamat"),
                content: Text(enderecoConfirmacao),
                contentPadding: EdgeInsets.all(16),
                actions: [
                  TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text(
                      "Konfirmasi",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      //salvar requisicao
                      _salvarRequisicao(destino);

                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    } else {
      //algum controle/aviso para preencher todos os campos.
    }
  }

  _exibirMarcadorPassageiro(Position local) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/passageiro.png")
        .then((BitmapDescriptor icone) {
      Marker marcadorPassageiro = Marker(
          markerId: MarkerId("marcador-passageiro"),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: "Location Saya"),
          icon: icone);

      setState(() {
        _marcadores.add(marcadorPassageiro);
      });
    });
  }

  _salvarRequisicao(Destination destino) async {
    /*
    + requisicao
       + ID_REQUISICAO
          + destino (rua, endereço, latitude...)
          + passageiro (nome, email ...)
          + motorista (nome, email ...)
          + status (aguardando, a caminho...finalizada)
     */

    Users passageiro = await UserFirebase.getLoginUserData();
    passageiro.latitude = _localPassageiro?.latitude;
    passageiro.longitude = _localPassageiro?.longitude;

    Requisicao requisicao = Requisicao();
    requisicao.destination = destino;
    requisicao.penumpang = passageiro;
    requisicao.status = StatusRequisicao.AGUARDANDO;

    FirebaseFirestore db = FirebaseFirestore.instance;

    //Salvar requisição ativa
    db.collection("request").doc(requisicao.id).set(requisicao.toMap());

    //Salvar requisição ativa
    Map<String, dynamic> dadosRequisicaoAtiva = {};
    dadosRequisicaoAtiva["id_requisicao"] = requisicao.id;
    dadosRequisicaoAtiva["id_usuario"] = passageiro.idUser;
    dadosRequisicaoAtiva["status"] = StatusRequisicao.AGUARDANDO;

    db
        .collection("requisicao_ativa")
        .doc(passageiro.idUser)
        .set(dadosRequisicaoAtiva);

    //Adicionar listener requisicao
    if (_streamSubscriptionRequisicoes == null) {
      _adicionarListenerRequisicao(requisicao.id!);
    }
  }

  _alterarBotaoPrincipal(String texto, Color cor, Function funcao) {
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });
  }

  _statusUberNaoChamado() async {
    _exibirCaixaEnderecoDestino = true;
    _alterarBotaoPrincipal("Cari Bus", Color.fromARGB(255, 28, 20, 82), () {
      _chamarUber();
    });

    //if(_localPassageiro != null ){
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _exibirMarcadorPassageiro(position);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    _movimentarCamera(cameraPosition);
    //}
  }

  _statusAguardando() async {
    _exibirCaixaEnderecoDestino = false;
    _alterarBotaoPrincipal("Cancel", Colors.red, () {
      _cancelarUber();
    });

    // double passageiroLat = _dadosRequisicao?["passageiro"]["latitude"];
    // double passageiroLon = _dadosRequisicao?["passageiro"]["longitude"];
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _exibirMarcadorPassageiro(position);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    _movimentarCamera(cameraPosition);
  }

  _statusACaminho() {
    _exibirCaixaEnderecoDestino = false;
    _alterarBotaoPrincipal("Motorista a caminho", Colors.grey, () {});

    double latitudePassageiro = _dadosRequisicao?["passageiro"]["latitude"];
    double longitudePassageiro = _dadosRequisicao?["passageiro"]["longitude"];

    double latitudeMotorista = _dadosRequisicao?["motorista"]["latitude"];
    double longitudeMotorista = _dadosRequisicao?["motorista"]["longitude"];

    UserMarker marcadorOrigem = UserMarker(
        LatLng(latitudeMotorista, longitudeMotorista),
        "imagens/motorista.png",
        "Lokasi Bus");

    UserMarker marcadorDestino = UserMarker(
        LatLng(latitudePassageiro, longitudePassageiro),
        "imagens/passageiro.png",
        "Lokasi Tujuan");

    _exibirCentralizarDoisMarcadores(marcadorOrigem, marcadorDestino);
  }

  _statusEmViagem() {
    _exibirCaixaEnderecoDestino = false;

    _alterarBotaoPrincipal(
      "bepergian",
      Colors.grey,
      () {},
    );

    double latitudeDestino = _dadosRequisicao!["destino"]["latitude"];
    double longitudeDestino = _dadosRequisicao!["destino"]["longitude"];

    double latitudeOrigem = _dadosRequisicao!["motorista"]["latitude"];
    double longitudeOrigem = _dadosRequisicao!["motorista"]["longitude"];

    UserMarker marcadorOrigem = UserMarker(
        LatLng(latitudeOrigem, longitudeOrigem),
        "imagens/motorista.png",
        "Lokasi bus");

    UserMarker marcadorDestino = UserMarker(
        LatLng(latitudeDestino, longitudeDestino),
        "imagens/destino.png",
        "Lokasi Tujuan");

    _exibirCentralizarDoisMarcadores(marcadorOrigem, marcadorDestino);
  }

  _statusFinalizada() async {
    //Calcula valor da corrida
    double latitudeDestino = _dadosRequisicao!["destino"]["latitude"];
    double longitudeDestino = _dadosRequisicao!["destino"]["longitude"];

    double latitudeOrigem = _dadosRequisicao!["origem"]["latitude"];
    double longitudeOrigem = _dadosRequisicao!["origem"]["longitude"];

    //para calcular um valor mais exato basta consumir uma API do google
    // que calcula a distanciaconsiderando as ruas do percurso.
    double distanciaEmMetros = Geolocator.distanceBetween(
        latitudeOrigem, longitudeOrigem, latitudeDestino, longitudeDestino);

    //converte para KM
    double distanciaKM = distanciaEmMetros / 1000;
    double valorViagem = distanciaKM * 8;

    //8 é o valor cobrado por KM
    var f = NumberFormat('#,##0.00', 'pt_BR');
    var valorViagemFormatado = f.format(valorViagem);

    _alterarBotaoPrincipal(
      "Total - R\$ $valorViagemFormatado",
      Colors.green,
      () {},
    );

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _exibirMarcador(position, "imagens/destino.png", "Destino");

    //setState(() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    // });
    _movimentarCamera(cameraPosition);
  }

  _statusConfirmada() async {
    if (_streamSubscriptionRequisicoes != null) {
      _streamSubscriptionRequisicoes!.cancel();
      _streamSubscriptionRequisicoes = null;
    }

    _exibirCaixaEnderecoDestino = true;

    _alterarBotaoPrincipal("Cari Bus", Color.fromARGB(255, 21, 47, 130), () {
      _chamarUber();
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _exibirMarcadorPassageiro(position);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    _movimentarCamera(cameraPosition);

    _dadosRequisicao = {};

    _adicionarListenerLocalizacao();
  }

  _exibirMarcador(Position local, String icone, String infoWindow) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio), icone)
        .then((BitmapDescriptor bitmapDescriptor) {
      Marker marcador = Marker(
          markerId: MarkerId(icone),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: infoWindow),
          icon: bitmapDescriptor);

      setState(() {
        _marcadores.add(marcador);
      });
    });
  }

  _exibirDoisMArcadores(UserMarker marcadorOrigem, UserMarker marcadorDestino) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    LatLng latLngOrigem = marcadorOrigem.lokasi;
    LatLng latLngDestino = marcadorDestino.lokasi;

    Set<Marker> _listaMarcadores = {};
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            marcadorOrigem.pathImage)
        .then((BitmapDescriptor icone) {
      Marker mOrigem = Marker(
          markerId: MarkerId(marcadorOrigem.pathImage),
          position: LatLng(latLngOrigem.latitude, latLngOrigem.longitude),
          infoWindow: InfoWindow(title: marcadorOrigem.title),
          icon: icone);
      _listaMarcadores.add(mOrigem);
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            marcadorDestino.pathImage)
        .then((BitmapDescriptor icone) {
      Marker mDestino = Marker(
          markerId: MarkerId(marcadorDestino.pathImage),
          position: LatLng(latLngDestino.latitude, latLngDestino.longitude),
          infoWindow: InfoWindow(title: marcadorDestino.title),
          icon: icone);
      _listaMarcadores.add(mDestino);
    });

    setState(() {
      _marcadores = _listaMarcadores;
    });
  }

  _exibirCentralizarDoisMarcadores(
      UserMarker marcadorOrigem, UserMarker marcadorDestino) {
    double latitudeOrigem = marcadorOrigem.lokasi.latitude;
    double longitudeOrigem = marcadorOrigem.lokasi.longitude;

    double latitudeDestino = marcadorDestino.lokasi.latitude;
    double longitudeDestino = marcadorDestino.lokasi.longitude;

    _exibirDoisMArcadores(
      marcadorOrigem,
      marcadorDestino,
    );

    //'southwest.latitude <= northeast.latitude' : is not true
    double? nLat, nLon, sLat, sLon;

    if (latitudeOrigem <= latitudeDestino) {
      sLat = latitudeOrigem;
      nLat = latitudeDestino;
    } else {
      sLat = latitudeDestino;
      nLat = latitudeOrigem;
    }

    if (longitudeOrigem <= longitudeDestino) {
      sLon = longitudeOrigem;
      nLon = longitudeDestino;
    } else {
      sLon = longitudeDestino;
      nLon = longitudeOrigem;
    }

    _movimentarCameraBounds(LatLngBounds(
      northeast: LatLng(nLat, nLon),
      southwest: LatLng(sLat, sLon),
    ));
  }

  _movimentarCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  _cancelarUber() async {
    User firebaseUser = await UserFirebase.getCurrentUser();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("request")
        .doc(_idRequisicao)
        .update({"status": StatusRequisicao.CANCELADA}).then((_) {
      db.collection("requisicao_ativa").doc(firebaseUser.uid).delete();

      _statusUberNaoChamado();

      if (_streamSubscriptionRequisicoes != null) {
        _streamSubscriptionRequisicoes!.cancel();
        _streamSubscriptionRequisicoes = null;
      }
    });
  }

  _recuperarRequisicaoAtiva() async {
    User firebaseUser = await UserFirebase.getCurrentUser();

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await db.collection("requisicao_ativa").doc(firebaseUser.uid).get();

    if (documentSnapshot.data() != null) {
      Map<String, dynamic> dados =
          documentSnapshot.data() as Map<String, dynamic>;
      _idRequisicao = dados["id_requisicao"];

      _adicionarListenerRequisicao(_idRequisicao!);
    } else {
      _statusUberNaoChamado();
    }
  }

  _adicionarListenerRequisicao(String idRequisicao) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    _streamSubscriptionRequisicoes = await db
        .collection("request")
        .doc(idRequisicao)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
        _dadosRequisicao = dados;
        String status = dados?["status"];
        _idRequisicao = dados?["id"];

        switch (status) {
          case StatusRequisicao.AGUARDANDO:
            _statusAguardando();
            break;
          case StatusRequisicao.A_CAMINHO:
            _statusACaminho();
            break;
          case StatusRequisicao.VIAGEM:
            _statusEmViagem();
            break;
          case StatusRequisicao.FINALIZADA:
            _statusFinalizada();
            break;
          case StatusRequisicao.CONFIRMADA:
            _statusConfirmada();
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //_recuperarUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();
    _recuperarUltimaLocalizacaoConhecida();

    //adicionar listener para requisicao ativa
    _recuperarRequisicaoAtiva();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Penumpang"),
        actions: [
          PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              })
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _posicaoCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _marcadores,
            ),
            Visibility(
                visible: _exibirCaixaEnderecoDestino,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white),
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  icon: Container(
                                    margin: EdgeInsets.only(
                                      left: 20,
                                    ),
                                    width: 10,
                                    height: 40,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.green,
                                    ),
                                  ),
                                  hintText: "My Location",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15)),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 55,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white),
                            child: TextField(
                              controller: _controllerDestino,
                              decoration: InputDecoration(
                                  icon: Container(
                                    margin: EdgeInsets.only(
                                      left: 20,
                                    ),
                                    width: 10,
                                    height: 40,
                                    child: Icon(
                                      Icons.local_taxi,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Destination",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15)),
                            ),
                          ),
                        ))
                  ],
                )),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: Platform.isIOS
                    ? EdgeInsets.fromLTRB(20, 10, 20, 25)
                    : EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _corBotao,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
                  onPressed: () {
                    _funcaoBotao!();
                  },
                  child: Text(
                    _textoBotao,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptionRequisicoes?.cancel();
    _streamSubscriptionRequisicoes = null;
  }
}
