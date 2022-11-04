import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:damri/model/request.dart';
import 'package:damri/util/user_firebase.dart';
import 'dart:io';
import '../model/destination.dart';
import '../model/marker.dart';
import '../model/user_model.dart';
import '../util/status_req.dart';

class PenumpangPage extends StatefulWidget {
  const PenumpangPage({Key? key}) : super(key: key);

  @override
  State<PenumpangPage> createState() => _PenumpangPageState();
}

class _PenumpangPageState extends State<PenumpangPage> {
  final TextEditingController _controllerTujuan =
      TextEditingController(text: "");
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  // String? _idRequisicao;
  String? _idReq;
  // Position? _localPassageiro;
  Position? _passengerLocation;
  // Map<String, dynamic>? _dadosRequisicao;
  Map<String, dynamic>? _requestData;
  // StreamSubscription<DocumentSnapshot>? _streamSubscriptionRequisicoes;
  StreamSubscription<DocumentSnapshot>? _streamSubscriptionReq;

  // String active_requisition = "active_requisition";

  //Controles para exibição na tela
  bool _displayDestinationAddressBox = true;
  // String _textoBotao = "Panggil Bus";
  String textButton = "Panggil Bus";
  // Color _corBotao = const Color.fromARGB(255, 57, 154, 219);
  Color _colorBtn = const Color.fromARGB(255, 57, 154, 219);
  Function? _buttonFunction;
  CameraPosition _positionCamera = const CameraPosition(
    target: LatLng(-6.914864, 107.608238),
    zoom: 18,
  );

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _getLastKnownLocation() async {
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (position != null) {
      setState(() {
        _showMarkerPassengger(position);

        _positionCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
        _passengerLocation = position;
        _moveCamera(_positionCamera);
      });
    }
  }

  _moveCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // _adicionarListenerLocalizacao() async {

  _addListenerLocation() async {
    // dengarkan lokasi pengguna
    await Geolocator.checkPermission();
    LocationPermission permission = await Geolocator.requestPermission();

    var locationSetings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10);

    Geolocator.getPositionStream(locationSettings: locationSetings)
        .listen((Position position) {
      if (_idReq != null && _idReq!.isNotEmpty) {
//Update passenger location
        UserFirebase.updateDataLocation(
            _idReq!, position.latitude, position.longitude, "penumpang");
      } else {
        setState(() {
          _passengerLocation = position;
        });
        _statusBusNotCalled();
      }
    });
  }

  List<String> itemsMenu = ["Informasi", "Profile", "Logout"];

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

  _information() {
    setState(() {
      Navigator.pushReplacementNamed(context, "/information");
    });
  }

// choose MenuItem(String choose)
  _chooseMenuItem(String pilihan) {
    switch (pilihan) {
      case "Logout":
        _deslogarUsuario();
        break;
      case "Informasi":
        _information();
        break;
      case "Profile":
        _userProfile();
        break;
    }
  }

// Call Uber
  // _chamarUber() async {

  _callBus() async {
    // String enderecoDestino = _controllerTujuan.text;
    String destinationAddress = _controllerTujuan.text;

    // List<Location> listaLocalizacoes =
    List<Location> listLocations = await GeocodingPlatform.instance
        .locationFromAddress(destinationAddress);

    if (listLocations.isNotEmpty) {
      Location localization = listLocations[0];
      List<Placemark> addressList = await GeocodingPlatform.instance
          .placemarkFromCoordinates(
              localization.latitude, localization.longitude);
      if (addressList.isNotEmpty) {
        Placemark address = addressList[0];

        Destination des = Destination();
        des.kota = address.subAdministrativeArea;
        des.kodePos = address.postalCode;
        des.daerah = address.subLocality;
        des.street = address.thoroughfare;
        des.number = address.subThoroughfare;

        des.latitude = localization.latitude;
        des.longitude = localization.longitude;

        String addressConfirmation;
        addressConfirmation = "\n Kota: ${des.kota}";
        addressConfirmation += "\n Jalan: ${des.street}, ${des.number}";
        addressConfirmation += "\n Daerah: ${des.daerah}";
        addressConfirmation += "\n Kode Pos: ${des.kodePos}";

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Konfirmasi alamat"),
                content: Text(addressConfirmation),
                contentPadding: const EdgeInsets.all(16),
                actions: [
                  TextButton(
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text(
                      "Konfirmasi",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      // simpan permintaan
                      _saveRequest(des);

                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    } else {
// beberapa kontrol/peringatan untuk mengisi semua bidang.
    }
  }

// tampilkan Bookmark Penumpang
  _showMarkerPassengger(Position location) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "imagens/passageiro.png")
        .then((BitmapDescriptor icon) {
      Marker markerPasngger = Marker(
          markerId: const MarkerId("passenger-marker"),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: const InfoWindow(title: "Lokasi Saya"),
          icon: icon);

      setState(() {
        _markers.add(markerPasngger);
      });
    });
  }

// simpan Permintaan(Tujuan tujuan)
  // _salvarRequisicao(Destination destino) async {
  _saveRequest(Destination des) async {
    /*
    + requisicao
       + ID_REQUISICAO
          + destino (rua, endereço, latitude...)
          + passageiro (nome, email ...)
          + motorista (nome, email ...)
          + status (aguardando, a caminho...finalizada)
     */

    Users passenger = await UserFirebase.getLoggedUserData();
    passenger.latitude = _passengerLocation?.latitude;
    passenger.longitude = _passengerLocation?.longitude;

    // Requisicao requisicao = Requisicao();
    Request req = Request();
    req.destina = des;
    req.passenger = passenger;
    req.status = StatusReq.aWaiting;

    FirebaseFirestore db = FirebaseFirestore.instance;

//Simpan permintaan aktif
    db.collection("request").doc(req.id).set(req.toMap());

//Simpan permintaan aktif
    // Map<String, dynamic> dadosRequisicaoAtiva = {};
    Map<String, dynamic> activeReqData = {};

    activeReqData["id_request"] = req.id;
    activeReqData["id_user"] = passenger.idUser;
    activeReqData["status"] = StatusReq.aWaiting;

    db
        .collection("active_requisition")
        .doc(passenger.idUser)
        .set(activeReqData);

//Tambahkan pendengar permintaan
    if (_streamSubscriptionReq == null) {
      _addRequestListener(req.id!);
    }
  }

// ubah Tombol Utama
  // _alterarBotaoPrincipal(String texto, Color cor, Function funcao) {
  _changeMainButton(String text, Color color, Function fun) {
    setState(() {
      textButton = text;
      _colorBtn = color;
      _buttonFunction = fun;
    });
  }

// Status Uber Tanpa Panggilan
  // _statusUberNaoChamado() async {
  _statusBusNotCalled() async {
    _displayDestinationAddressBox = true;
    _changeMainButton("Panggil Bus", const Color.fromARGB(255, 33, 109, 214),
        () {
      _callBus();
    });

    //if(_localPassageiro != null ){
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _showMarkerPassengger(position);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    _moveCamera(cameraPosition);
    //}
  }

// Menunggu
  _statusWaiting() async {
    _displayDestinationAddressBox = false;
    _changeMainButton("Batal", Colors.red, () {
      _cancelTrack();
    });

    // double passageiroLat = _dadosRequisicao?["passageiro"]["latitude"];
    // double passageiroLon = _dadosRequisicao?["passageiro"]["longitude"];
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _showMarkerPassengger(position);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    _moveCamera(cameraPosition);
  }

//status jalur
  _statusOnTheWay() {
    _displayDestinationAddressBox = false;
    _changeMainButton("Driver on the way", Colors.grey, () {});

    double latitudePassenger = _requestData?["penumpang"]["latitude"];
    double longitudePassenger = _requestData?["penumpang"]["longitude"];

    double latitudeDriver = _requestData?["pengemudi"]["latitude"];
    double longitudeDriver = _requestData?["pengemudi"]["longitude"];

    UserMarker markerOrigin = UserMarker(
        LatLng(latitudeDriver, longitudeDriver),
        "imagens/motorista.png",
        "Lokasi Pengemudi");

    UserMarker markerDes = UserMarker(
        LatLng(latitudePassenger, longitudePassenger),
        "imagens/passageiro.png",
        "Lokasi Tujuan");

    _showCenterTwoMarkers(markerOrigin, markerDes);
  }

//status Travelling
  _statusTravelling() {
    _displayDestinationAddressBox = false;

    _changeMainButton(
      "Traveling",
      Colors.grey,
      () {},
    );

    double latitudeDes = _requestData!["tujuan"]["latitude"];
    double longitudeDes = _requestData!["tujuan"]["longitude"];

    double latitudeOrigin = _requestData!["pengemudi"]["latitude"];
    double longitudeOrigin = _requestData!["pengemudi"]["longitude"];

    UserMarker markerOrigin = UserMarker(
        LatLng(latitudeOrigin, longitudeOrigin),
        "imagens/motorista.png",
        "Lokasi Pengemudi");

    UserMarker markerDes = UserMarker(LatLng(latitudeDes, longitudeDes),
        "imagens/destino.png", "Lokasi Tujuan");

    _showCenterTwoMarkers(markerOrigin, markerDes);
  }

//status finish
  _statusFinished() async {
    //Calcula valor da corrida
    double latitudeDes = _requestData!["tujuan"]["latitude"];
    double longitudeDes = _requestData!["tujuan"]["longitude"];

    double latitudeOrigin = _requestData!["asal"]["latitude"];
    double longitudeOrigin = _requestData!["asal"]["longitude"];

//untuk menghitung nilai yang lebih tepat, cukup gunakan Google API
// yang menghitung jarak dengan mempertimbangkan jalan-jalan dari rute tersebut.
// jarak dalam meter
    double distanceInMeters = Geolocator.distanceBetween(
        latitudeOrigin, longitudeOrigin, latitudeDes, longitudeDes);

    //converte para KM
    double distanceInKM = distanceInMeters / 1000;
    double valuetrip = distanceInKM * 8;

    //8 é o valor cobrado por KM
    var f = NumberFormat('#,##0.00', 'pt_BR');
    var valueTravelFormatted = f.format(valuetrip);

    _changeMainButton(
      "Total - R\$ $valueTravelFormatted",
      Colors.green,
      () {},
    );

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

  _statusConfirmed() async {
    if (_streamSubscriptionReq != null) {
      _streamSubscriptionReq!.cancel();
      _streamSubscriptionReq = null;
    }

    _displayDestinationAddressBox = true;

    _changeMainButton("Panggil Bus", const Color(0xff1ebbd8), () {
      _callBus();
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

// tampilkan marker Penumpang
    _showMarkerPassengger(position);
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );
    _moveCamera(cameraPosition);

    _requestData = {};

    _addListenerLocation();
  }

  // _exibirMarcador(Position local, String icone, String infoWindow) async {

  _showMarker(Position location, String icon, String infoWindow) async {
    // showBookmark
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

// showTwhoMarkers
  // _exibirDoisMArcadores(UserMarker marcadorOrigem, UserMarker marcadorDestino) {

  _showTwoMarkers(UserMarker markerOrigin, UserMarker destinationMarker) {
    //  tampilkan Dua Bookmark

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    LatLng latLngAsal = markerOrigin.lokasi;
    LatLng latLngDes = destinationMarker.lokasi;

    Set<Marker> listMarkers = {};
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            markerOrigin.pathImage)
        .then((BitmapDescriptor icon) {
      Marker mOrigin = Marker(
          markerId: MarkerId(markerOrigin.pathImage),
          position: LatLng(latLngAsal.latitude, latLngAsal.longitude),
          infoWindow: InfoWindow(title: markerOrigin.title),
          icon: icon);
      listMarkers.add(mOrigin);
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            destinationMarker.pathImage)
        .then((BitmapDescriptor icone) {
      Marker mDes = Marker(
          markerId: MarkerId(destinationMarker.pathImage),
          position: LatLng(latLngDes.latitude, latLngDes.longitude),
          infoWindow: InfoWindow(title: destinationMarker.title),
          icon: icone);
      listMarkers.add(mDes);
    });

    setState(() {
      _markers = listMarkers;
    });
  }

// _showCenterTwoMarkers
  _showCenterTwoMarkers(UserMarker markerOrigin, UserMarker markerDes) {
    double latitudeOrigin = markerOrigin.lokasi.latitude;
    double longitudeOrigin = markerOrigin.lokasi.longitude;

    double latitudeDes = markerDes.lokasi.latitude;
    double longitudeDes = markerDes.lokasi.longitude;

//  show Two Markers
    _showTwoMarkers(
      markerOrigin,
      markerDes,
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

  _moveCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  _cancelTrack() async {
    User firebaseUser = await UserFirebase.getCurrentUser();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("request")
        .doc(_idReq)
        .update({"status": StatusReq.cancel}).then((_) {
      db.collection("active_requisition").doc(firebaseUser.uid).delete();

      _statusBusNotCalled();

      if (_streamSubscriptionReq != null) {
        _streamSubscriptionReq!.cancel();
        _streamSubscriptionReq = null;
      }
    });
  }

  // _recuperarRequisicaoAtiva() async {
  _getActiveRequest() async {
    User firebaseUser = await UserFirebase.getCurrentUser();

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await db.collection("active_requisition").doc(firebaseUser.uid).get();

    if (documentSnapshot.data() != null) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      _idReq = data["id_request"];

      _addRequestListener(_idReq!);
    } else {
      _statusBusNotCalled();
    }
  }

  // _adicionarListenerRequisicao(String idReq) async {
  _addRequestListener(String idReq) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    _streamSubscriptionReq = await db
        .collection("request")
        .doc(idReq)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        // Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
        Map<String, dynamic>? data = snapshot.data();
        _requestData = data;
        String status = data?["status"];
        _idReq = data?["id"];

        switch (status) {
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

  @override
  void initState() {
    super.initState();
    //_recuperarUltimaLocalizacaoConhecida();

    // _addListenerLocation();
    _addListenerLocation();

// _retrieveLastKnownLocation
    _getLastKnownLocation();

//tambahkan pendengar untuk permintaan aktif
    _getActiveRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel Penumpang"),
        actions: [
          PopupMenuButton<String>(
              onSelected: _chooseMenuItem,
              itemBuilder: (context) {
                return itemsMenu.map((String item) {
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
              initialCameraPosition: _positionCamera,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
            ),
            Visibility(
                visible: _displayDestinationAddressBox,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
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
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                    ),
                                    width: 10,
                                    height: 40,
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.green,
                                    ),
                                  ),
                                  hintText: "Lokasi Saya",
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.only(left: 15)),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 55,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white),
                            child: TextField(
                              controller: _controllerTujuan,
                              decoration: InputDecoration(
                                  icon: Container(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                    ),
                                    width: 10,
                                    height: 40,
                                    child: const Icon(
                                      Icons.local_taxi,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Tujuan",
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.only(left: 15)),
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
                padding: Platform.isAndroid
                    ? const EdgeInsets.fromLTRB(20, 10, 20, 25)
                    : const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _colorBtn,
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                  onPressed: () {
                    _buttonFunction!();
                  },
                  child: Text(
                    textButton,
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

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptionReq?.cancel();
    _streamSubscriptionReq = null;
  }
}
