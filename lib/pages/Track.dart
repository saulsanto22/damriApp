import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:damri/util/status_req.dart';
import 'package:damri/util/user_firebase.dart';
import 'dart:io';

import '../model/marker.dart';
import '../model/user_model.dart';

class Monitoring extends StatefulWidget {
  String idReq;

  Monitoring(this.idReq, {Key? key}) : super(key: key);

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  var clients = [];

  Map<String, dynamic>? _dataReq;
  //
  final CameraPosition _positionCamera = const CameraPosition(
    target: LatLng(-23.42087200129373, -51.93719096900213),
    zoom: 18,
  );
  String? _idReq;
  Position? _locationDriver;
  String _statusReq = StatusReq.aWaiting;

//Kontrol untuk tampilan di layar
  String _textBtn = "Terima";

  Color _colorBtn = const Color(0xff1ebbd8);
  Function? _funcBtn;
  String _messageStatus = "";
//   String? _idRequisicao;
//   Position? _localMotorista;
//   String _statusRequisicao = StatusRequisicao.AGUARDANDO;

// //Kontrol untuk tampilan di layar
//   String _textoBotao = "Terima";

//   Color _corBotao = const Color(0xff1ebbd8);
//   Function? _funcaoBotao;
//   String _mensagemStatus = "";

  _changeMainButton(String text, Color color, Function func) {
    setState(() {
      _textBtn = text;
      _colorBtn = color;
      _funcBtn = func;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // populatePenumpang() {
  //   clients = [];
  //   FirebaseFirestore.instance.collection('markers').doc().then((docs) {
  //     if (docs.documents.isNotEmpty) {
  //       setState(() {
  //         clientsToggle = true;
  //       });
  //       for (int i = 0; i < docs.documents.length; ++i) {
  //         clients.add(docs.documents[i].data);
  //         initMarker(docs.documents[i].data);
  //       }
  //     }
  //   });
  // }

  // _recuperarUltimaLocalizacaoConhecida() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   if (position != null) {
  //     //Atualizar localização em tempo real do motorista
  //   }
  // }

  // _movimentarCamera(CameraPosition cameraPosition) async {

  _moveCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // _adicionarListenerLocalizacao() async {

  _addListenerLocation() async {
    LocationPermission permission;
    await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    var locationSetings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10);

    Geolocator.getPositionStream(locationSettings: locationSetings)
        .listen((Position? position) {
      if (position != null) {
        if (_idReq != null && _idReq!.isNotEmpty) {
          if (_statusReq != StatusReq.aWaiting) {
//Update passenger location
            UserFirebase.updateDataLocation(
                _idReq!, position.latitude, position.longitude, "pengemudi");
          }
        }
      } else {
        //aguardando
        setState(() {
          _locationDriver = position;
        });
        _statusWaiting();
      }
    });
  }

  // _exibirMarcador(Position local, String icone, String infoWindow) async {
  _showMarker(Position location, String icon, String infoWindow) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio), icon)
        .then((BitmapDescriptor bitmapDescriptor) {
      Marker marker = Marker(
          markerId: MarkerId(icon),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: infoWindow),
          icon: bitmapDescriptor);

      setState(() {
        _markers.add(marker);
      });
    });
  }

  // _recuperarRequisicao() async {
  //   String idRequisicao = widget.idRequisicao;

  //   FirebaseFirestore db = FirebaseFirestore.instance;
  //   DocumentSnapshot documentSnapshot =
  //       await db.collection("request").doc(idRequisicao).get();
  // }

  // _adicionarListenerRequisicao() {
  _addRequestListener() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("request").doc(_idReq).snapshots().listen((snapshot) {
      if (snapshot.data() != null) {
        _dataReq = snapshot.data()!;

        Map<String, dynamic>? data = snapshot.data();
        _statusReq = data?["status"];

        switch (_statusReq) {
          case StatusReq.aWaiting:
            _statusWaiting();
            break;
          case StatusReq.onTheWay:
            _statusOnTheWay();
            break;
          case StatusReq.travelling:
            _statusTravelling();
            break;
          case StatusReq.finished:
            _statusFinished();
            break;
          case StatusReq.confir:
            _statusConfirmed();
            break;
        }
      }
    });
  }

  _statusWaiting() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("request").doc(_idReq).snapshots().listen((snapshot) async {
      if (snapshot.data() != null) {
        Map<String, dynamic>? data = snapshot.data();
        _statusReq = data?["status"];

        switch (_statusReq) {
          case StatusReq.aWaiting:
            _changeMainButton("To Accept", const Color(0xff1ebbd8), () {
              _acceptRace();
            });

            // if(_localMotorista != null) {

            // double? motoristaLat = _localMotorista?.latitude;
            // double? motoristaLon = _localMotorista?.longitude;

            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);

            setState(() {
              _showMarker(position, "imagens/motorista.png", "pengemudi");
            });

            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18,
            );

            _moveCamera(cameraPosition);

            //}
            break;
          case StatusReq.cancel:
            Navigator.pushReplacementNamed(context, "/panel-pengemudi");
            break;
        }
      }
    });
  }

  _statusOnTheWay() async {
    _messageStatus = "on the way to the passenger";
    _changeMainButton(
      "Mulai Perjalanan ",
      const Color(0xff1ebbd8),
      () {
        _startRace();
      },
    );

    // double latitudePassageiro = _dadosRequisicao!["penumpang"]["latitude"];
    // double longitudePassageiro = _dadosRequisicao!["penumpang"]["longitude"];
    // double latitudeMotorista = _dadosRequisicao!["pengemudi"]["latitude"];
    // double longitudeMotorista = _dadosRequisicao!["pengemudi"]["longitude"];
    double latitudePassenger = _dataReq!["penumpang"]["latitude"];
    double longitudePassenger = _dataReq!["penumpang"]["longitude"];
    double latitudeDriver = _dataReq!["pengemudi"]["latitude"];
    double longitudeDriver = _dataReq!["pengemudi"]["longitude"];

    // Marcador marcadorMotorista = Marcador(
    //     LatLng(latitudeMotorista, longitudeMotorista),
    //     "imagens/motorista.png",
    //     "Lokasi Pengemudi");
    UserMarker markerDriver = UserMarker(
        LatLng(latitudeDriver, longitudeDriver),
        "imagens/motorista.png",
        "Lokasi Pengemudi");

    UserMarker markerPassenger = UserMarker(
        LatLng(latitudePassenger, longitudePassenger),
        "imagens/passageiro.png",
        "Lokasi Tujuan");

    _showCenterTwoMarkers(markerDriver, markerPassenger);
  }

  _statusTravelling() {
    _messageStatus = "Traveling";
    _changeMainButton(
      "Finish race",
      const Color(0xff1ebbd8),
      () {
        _finishRace();
      },
    );

    double latitudeDes = _dataReq!["tujuan"]["latitude"];
    double longitudeDes = _dataReq!["tujuan"]["longitude"];

    double latitudeOrigin = _dataReq!["pengemudi"]["latitude"];
    double longitudeOrigin = _dataReq!["pengemudi"]["longitude"];

    UserMarker markerOrigin = UserMarker(
        LatLng(latitudeOrigin, longitudeOrigin),
        "imagens/motorista.png",
        "Lokasi Pengemudi");
    UserMarker markerDes = UserMarker(LatLng(latitudeDes, longitudeDes),
        "imagens/destino.png", "Lokasi Tujuan");

    _showCenterTwoMarkers(markerOrigin, markerDes);
  }

  _showCenterTwoMarkers(UserMarker markerAsal, UserMarker markerTujuan) {
    double latitudeOrigin = markerAsal.lokasi.latitude;
    double longitudeOrigin = markerAsal.lokasi.longitude;

    double latitudeDes = markerTujuan.lokasi.latitude;
    double longitudeDes = markerTujuan.lokasi.longitude;

    showTwoMarkers(
      markerAsal,
      markerTujuan,
    );

    //'southwest.latitude <= northeast.latitude' : is not true
    double? nLat, nLon, sLat, sLon;

    if (latitudeOrigin <= latitudeDes) {
      sLat = latitudeOrigin;
      nLat = latitudeDes;
    } else {
      sLat = latitudeDes;
      nLat = latitudeOrigin;
    }

    if (longitudeOrigin <= longitudeDes) {
      sLon = longitudeOrigin;
      nLon = longitudeDes;
    } else {
      sLon = longitudeDes;
      nLon = longitudeOrigin;
    }

    _moveCameraBounds(LatLngBounds(
      northeast: LatLng(nLat, nLon),
      southwest: LatLng(sLat, sLon),
    ));
  }

  _finishRace() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("request").doc(_idReq).update({"status": StatusReq.finished});

    String idPassenger = _dataReq!["penumpang"]["idUser"];
    db
        .collection("active_requisition")
        .doc(idPassenger)
        .update({"status": StatusReq.finished});

    String idDriver = _dataReq!["pengemudi"]["idUser"];
    db
        .collection("driver_active_requisition")
        .doc(idDriver)
        .update({"status": StatusReq.finished});
  }

  _statusFinished() async {
    //Calcula valor da corrida
    double latitudeDestination = _dataReq!["tujuan"]["latitude"];
    double longitudeDestination = _dataReq!["tujuan"]["longitude"];

    double latitudeOrigin = _dataReq!["asal"]["latitude"];
    double longitudeOrigin = _dataReq!["asal"]["longitude"];

    //para calcular um valor mais exato basta consumir uma API do google
    // que calcula a distanciaconsiderando as ruas do percurso.
    double distanceInMeters = Geolocator.distanceBetween(latitudeOrigin,
        longitudeOrigin, latitudeDestination, longitudeDestination);

    //converte para KM
    double distanceInKM = distanceInMeters / 1000;
    double valuetrip = distanceInKM * 8;

    //8 é o valor cobrado por KM
    var f = NumberFormat('#,##0.00', 'pt_BR');
    var valueTravelFormatted = f.format(valuetrip);

    _messageStatus = "trip completed";
    _changeMainButton(
      "Confirmar - R\$ $valueTravelFormatted",
      const Color(0xff1ebbd8),
      () {
        _confirmRace();
      },
    );

    _markers = {};

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _showMarker(position, "imagens/destino.png", "Tujuan");

    //setState(() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    // });
    _moveCamera(cameraPosition);
  }

  _statusConfirmed() {
    Navigator.pushReplacementNamed(context, "/panel-pengemudi");
  }

  _confirmRace() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("request").doc(_idReq).update({"status": StatusReq.confir});

    String idPassenger = _dataReq!["penumpang"]["idUser"];
    db.collection("active_requisition").doc(idPassenger).delete();

    String idDriver = _dataReq!["pengemudi"]["idUser"];
    db.collection("driver_active_requisition").doc(idDriver).delete();
  }

  // _iniciarCorrida() {

  _startRace() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("request").doc(_idReq).update({
      "asal": {
        "latitude": _dataReq!["pengemudi"]["latitude"],
        "longitude": _dataReq!["pengemudi"]["longitude"],
      },
      "status": StatusReq.travelling
    });

    String idPassenger = _dataReq!["penumpang"]["idUser"];
    db
        .collection("active_requisition")
        .doc(idPassenger)
        .update({"status": StatusReq.travelling});

    String idDriver = _dataReq!["pengemudi"]["idUser"];
    db
        .collection("driver_active_requisition")
        .doc(idDriver)
        .update({"status": StatusReq.travelling});
  }

  _moveCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  showTwoMarkers(UserMarker markerAsal, UserMarker markerTujuan) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    LatLng latLngAsal = markerAsal.lokasi;
    LatLng latLngTujuan = markerTujuan.lokasi;

    Set<Marker> _listMarkers = {};
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            markerAsal.pathImage)
        .then((BitmapDescriptor icon) {
      Marker mOrigem = Marker(
          markerId: MarkerId(markerAsal.pathImage),
          position: LatLng(latLngAsal.latitude, latLngAsal.longitude),
          infoWindow: InfoWindow(title: markerAsal.title),
          icon: icon);
      _listMarkers.add(mOrigem);
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            markerTujuan.pathImage)
        .then((BitmapDescriptor icon) {
      Marker mDes = Marker(
          markerId: MarkerId(markerTujuan.pathImage),
          position: LatLng(latLngTujuan.latitude, latLngTujuan.longitude),
          infoWindow: InfoWindow(title: markerTujuan.title),
          icon: icon);
      _listMarkers.add(mDes);
    });

    setState(() {
      _markers = _listMarkers;
    });
  }

  // _aceitarCorrida() async {

  _acceptRace() async {
    //Ambil data pengemudi
    Users driver = await UserFirebase.getLoggedUserData();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    driver.latitude = position.latitude;
    driver.longitude = position.longitude;

    FirebaseFirestore db = FirebaseFirestore.instance;
    String idReq = _dataReq!["id"];

    db.collection("request").doc(idReq).update({
      "pengemudi": driver.toMap(),
      "status": StatusReq.onTheWay,
    }).then((_) {
      //atualiza requisicao ativa
      String? idPPassenger = _dataReq!["penumpang"]["idUser"];
      db.collection("active_requisition").doc(idPPassenger).update({
        "status": StatusReq.onTheWay,
      });

      //Salvar requisicao ativa para motorista
      String? idDriver = driver.idUser;
      db.collection("driver_active_requisition").doc(idDriver).set({
        "id_requst": idReq,
        "id_user": idDriver,
        "status": StatusReq.onTheWay,
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _idReq = widget.idReq;

    //adicionar listener para mudanças na requisição
    _addRequestListener();

    //_recuperarUltimaLocalizacaoConhecida();
    _addListenerLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Lacak- $_messageStatus"),
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _positionCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: Platform.isIOS
                    ? const EdgeInsets.fromLTRB(20, 10, 20, 25)
                    : const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _colorBtn,
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                  onPressed: () {
                    _funcBtn!();
                  },
                  child: Text(
                    _textBtn,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
