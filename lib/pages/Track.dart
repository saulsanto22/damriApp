import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:damri/util/StatusRequest.dart';
import 'package:damri/util/UserFirebase.dart';
import 'dart:io';

import '../model/Marker.dart';
import '../model/User.dart';

class Track extends StatefulWidget {
  final String idRequest;

  Track(this.idRequest, {Key? key}) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Map<String, dynamic>? _requisitionData;
  CameraPosition _positionCamera = CameraPosition(
    target: LatLng(-23.42087200129373, -51.93719096900213),
    zoom: 18,
  );
  String? _idRequest;
  Position? _locationDriver;
  String _statusRequisition = StatusRequisicao.AGUARDANDO;

  //Controles para exibição na tela
  String _textButton = "Terima ras";
  Color _colorButton = Color(0xff1ebbd8);
  Function? _buttonFunction;
  String _messageStatus = "";

  _changeMainButton(String text, Color color, Function func) {
    setState(() {
      _textButton = text;
      _colorButton = color;
      _buttonFunction = func;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // _retrieveLastKnownLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   if (position != null) {
  //     //Atualizar localização em tempo real do motorista
  //     // Perbarui lokasi real-time pengemudi
  //   }
  // }

  _moveCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _addListenerLocation() async {
    LocationPermission permission;
    await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    var locationSetings =
        LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

    Geolocator.getPositionStream(locationSettings: locationSetings)
        .listen((Position? position) {
      if (position != null) {
        if (_idRequest != null && _idRequest!.isNotEmpty) {
          if (_statusRequisition != StatusRequisicao.AGUARDANDO) {
            //Atualiza local do passageiro
            UserFirebase.updateDataLocation(_idRequest!, position.latitude,
                position.longitude, "motorista");
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

  _displayMarker(Position location, String icon, String infoWindow) async {
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

  _retrieveRequisition() async {
    String idReq = widget.idRequest;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await db.collection("request").doc(idReq).get();
  }

  _addRequestListener() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("request").doc(_idRequest).snapshots().listen((snapshot) {
      if (snapshot.data() != null) {
        _requisitionData = snapshot.data()!;

        Map<String, dynamic>? data = snapshot.data();
        _statusRequisition = data?["status"];

        switch (_statusRequisition) {
          case StatusRequisicao.AGUARDANDO:
            _statusWaiting();
            break;
          case StatusRequisicao.A_CAMINHO:
            _statusOnTheWay();
            break;
          case StatusRequisicao.VIAGEM:
            _statusTravelling();
            break;
          case StatusRequisicao.FINALIZADA:
            _statusFinished();

            break;
          case StatusRequisicao.CONFIRMADA:
            _statusConfirmed();
            break;
        }
      }
    });
  }

  _statusWaiting() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db
        .collection("request")
        .doc(_idRequest)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.data() != null) {
        Map<String, dynamic>? data = snapshot.data();
        _statusRequisition = data?["status"];

        switch (_statusRequisition) {
          case StatusRequisicao.AGUARDANDO:
            _changeMainButton("Terima ras", Color(0xff1ebbd8), () {
              _acceptRacing();
            });

            // if(_localMotorista != null) {

            double? motoristaLat = _locationDriver?.latitude;
            double? motoristaLon = _locationDriver?.longitude;

            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);

            setState(() {
              _displayMarker(position, "imagens/motorista.png", "motorista");
            });

            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18,
            );

            _moveCamera(cameraPosition);

            //}
            break;
          case StatusRequisicao.CANCELADA:
            Navigator.pushReplacementNamed(context, "/painel-motorista");
            break;
        }
      }
    });
  }

  _statusOnTheWay() async {
    _messageStatus = "dalam perjalanan ke Penumpang";
    _changeMainButton(
      "Mulai Jalan",
      Color(0xff1ebbd8),
      () {
        _iniciarCorrida();
      },
    );

    double latitudePassageiro = _requisitionData!["passageiro"]["latitude"];
    double longitudePassageiro = _requisitionData!["passageiro"]["longitude"];
    double latitudeMotorista = _requisitionData!["motorista"]["latitude"];
    double longitudeMotorista = _requisitionData!["motorista"]["longitude"];

    UserMarker marcadorMotorista = UserMarker(
        LatLng(latitudeMotorista, longitudeMotorista),
        "imagens/motorista.png",
        "Lokasi Pengemudi");

    UserMarker marcadorPassageiro = UserMarker(
        LatLng(latitudePassageiro, longitudePassageiro),
        "imagens/passageiro.png",
        "lokasi tujuan");

    _displayCenterTwoMarkers(marcadorMotorista, marcadorPassageiro);
  }

  _statusTravelling() {
    _messageStatus = "Bepergian";
    _changeMainButton(
      "menyelesaikan perjalanan",
      Color(0xff1ebbd8),
      () {
        _finishRace();
      },
    );

    double latitudeDestino = _requisitionData!["destino"]["latitude"];
    double longitudeDestino = _requisitionData!["destino"]["longitude"];

    double latitudeOrigem = _requisitionData!["motorista"]["latitude"];
    double longitudeOrigem = _requisitionData!["motorista"]["longitude"];

    UserMarker marcadorOrigem = UserMarker(
        LatLng(latitudeOrigem, longitudeOrigem),
        "imagens/motorista.png",
        "Lokasi Pengemudi");

    UserMarker marcadorDestino = UserMarker(
        LatLng(latitudeDestino, longitudeDestino),
        "imagens/destino.png",
        "Lokasi Tujuan");

    _displayCenterTwoMarkers(marcadorOrigem, marcadorDestino);
  }

  _displayCenterTwoMarkers(
      UserMarker marcadorOrigem, UserMarker marcadorDestino) {
    double latitudeOrigem = marcadorOrigem.lokasi.latitude;
    double longitudeOrigem = marcadorOrigem.lokasi.longitude;

    double latitudeDestino = marcadorDestino.lokasi.latitude;
    double longitudeDestino = marcadorDestino.lokasi.longitude;
    // nampilin lokasi asal ke tujuan
    _displayTwoMarks(
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

    _moveCameraBounds(LatLngBounds(
      northeast: LatLng(nLat, nLon),
      southwest: LatLng(sLat, sLon),
    ));
  }

  _finishRace() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("request")
        .doc(_idRequest)
        .update({"status": StatusRequisicao.FINALIZADA});

    String idPassageiro = _requisitionData!["passageiro"]["idUsuario"];
    db
        .collection("requisicao_ativa")
        .doc(idPassageiro)
        .update({"status": StatusRequisicao.FINALIZADA});

    String idMotorista = _requisitionData!["motorista"]["idUsuario"];
    db
        .collection("requisicao_ativa_motorista")
        .doc(idMotorista)
        .update({"status": StatusRequisicao.FINALIZADA});
  }

  _statusFinished() async {
    //Calcula valor da corrida
    double latitudeDestino = _requisitionData!["destino"]["latitude"];
    double longitudeDestino = _requisitionData!["destino"]["longitude"];

    double latitudeOrigem = _requisitionData!["origem"]["latitude"];
    double longitudeOrigem = _requisitionData!["origem"]["longitude"];

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

    _messageStatus = "perjalanan selesai";
    _changeMainButton(
      "Confirmasi - R\$ $valorViagemFormatado",
      Color(0xff1ebbd8),
      () {
        _confirmarCorrida();
      },
    );

    _markers = {};

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _displayMarker(position, "imagens/destino.png", "Tujuan");

    //setState(() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    // });
    _moveCamera(cameraPosition);
  }

  _statusConfirmed() {
    Navigator.pushReplacementNamed(context, "/painel-motorista");
  }

  _confirmarCorrida() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("request")
        .doc(_idRequest)
        .update({"status": StatusRequisicao.CONFIRMADA});

    String idPassageiro = _requisitionData!["passageiro"]["idUsuario"];
    db.collection("requisicao_ativa").doc(idPassageiro).delete();

    String idMotorista = _requisitionData!["motorista"]["idUsuario"];
    db.collection("requisicao_ativa_motorista").doc(idMotorista).delete();
  }

  _iniciarCorrida() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("request").doc(_idRequest).update({
      "origem": {
        "latitude": _requisitionData!["motorista"]["latitude"],
        "longitude": _requisitionData!["motorista"]["longitude"],
      },
      "status": StatusRequisicao.VIAGEM
    });

    String idPassageiro = _requisitionData!["passageiro"]["idUsuario"];
    db
        .collection("requisicao_ativa")
        .doc(idPassageiro)
        .update({"status": StatusRequisicao.VIAGEM});

    String idMotorista = _requisitionData!["motorista"]["idUsuario"];

    db
        .collection("requisicao_ativa_motorista")
        .doc(idMotorista)
        .update({"status": StatusRequisicao.VIAGEM});
  }

  _moveCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  _displayTwoMarks(UserMarker marcadorOrigem, UserMarker marcadorDestino) {
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
      _markers = _listaMarcadores;
    });
  }

  _acceptRacing() async {
    //Recuperar dados do motorista
    Users motorista = await UserFirebase.getLoginUserData();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    motorista.latitude = position.latitude;
    motorista.longitude = position.longitude;

    FirebaseFirestore db = FirebaseFirestore.instance;
    String idRequisicao = _requisitionData!["id"];

    db.collection("request").doc(idRequisicao).update({
      "motorista": motorista.toMap(),
      "status": StatusRequisicao.A_CAMINHO,
    }).then((_) {
      //atualiza requisicao ativa
      String? idPassageiro = _requisitionData!["passageiro"]["idUsuario"];
      db.collection("requisicao_ativa").doc(idPassageiro).update({
        "status": StatusRequisicao.A_CAMINHO,
      });

      //
      // Save active requisition for drive
      String? idMotorista = motorista.idUser;
      db.collection("requisicao_ativa_motorista").doc(idMotorista).set({
        "id_requisicao": idRequisicao,
        "id_usuario": idMotorista,
        "status": StatusRequisicao.A_CAMINHO,
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _idRequest = widget.idRequest;

    //adicionar listener para mudanças na requisição
    _addRequestListener();

    //_recuperarUltimaLocalizacaoConhecida();
    _addListenerLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Pelacakan - $_messageStatus"),
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _positionCamera,
              onMapCreated: _onMapCreated,
              //myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
            ),
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
                      backgroundColor: _colorButton,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
                  onPressed: () {
                    _buttonFunction!();
                  },
                  child: Text(
                    _textButton,
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
}
