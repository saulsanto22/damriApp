import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:damri/util/status_req.dart';
import 'package:damri/util/user_firebase.dart';

class PanelSupir extends StatefulWidget {
  const PanelSupir({Key? key}) : super(key: key);

  @override
  State<PanelSupir> createState() => _PanelSupirState();
}

class _PanelSupirState extends State<PanelSupir> {
  List<String> itemsMenu = ["Profile", "Logout"];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;

  _logoutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _userProfile() {
    setState(() {
      Navigator.pushReplacementNamed(context, "/userProfile");
    });
  }

  _chooseMenuItem(String pilihan) {
    switch (pilihan) {
      case "Logout":
        _logoutUser();
        break;

      case "Profile":
        _userProfile();
        break;
    }
  }

// tambahkan Permintaan Pendengar
  // Stream<QuerySnapshot>? _adicionarListenerRequisicoes() {
  Stream<QuerySnapshot>? _addListenerRequests() {
    final stream = db
        .collection("request")
        .where("status", isEqualTo: StatusReq.aWaiting)
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
    return null;
  }

// ambil permintaan Driver Aktif
  // _recuperaRequisicaoAtivaMotorista() async {

  _getActiveDriverRequest() async {
//Mengambil data dari pengguna yang login
    User user = await UserFirebase.getCurrentUser();

//Ambil permintaan aktif
    DocumentSnapshot documentSnapshot =
        await db.collection("driver_active_requisition").doc(user.uid).get();

    Map<String, dynamic>? dataReq =
        documentSnapshot.data() as Map<String, dynamic>?;

    if (dataReq == null) {
      _addListenerRequests();
    } else {
      String idReq = dataReq["id_request"];
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
        context,
        "/corrida",
        arguments: idReq,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    /*
    Ambil permintaan aktif untuk memeriksa apakah pengemudi
    memenuhi beberapa permintaan dan mengirimkannya ke layar yang sedang berjalan
    */
    _getActiveDriverRequest();
  }

  @override
  Widget build(BuildContext context) {
    var messageLoading = Center(
      child: Column(
        children: const [
          Text("Loading requests..."),
          CircularProgressIndicator()
        ],
      ),
    );

    var messageNoData = const Center(
        child: Text(
      "You don't have any requests :(",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel Pengemudi"),
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
      body: StreamBuilder<QuerySnapshot>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return messageLoading;

              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return const Text("Error loading data!");
                } else {
                  QuerySnapshot? querySnapshot = snapshot.data;
                  if (querySnapshot?.docs.length == 0) {
                    return messageNoData;
                  } else {
                    return ListView.separated(
                        itemCount: querySnapshot!.docs.length,
                        separatorBuilder: (context, indice) => const Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                        itemBuilder: (context, index) {
                          List<DocumentSnapshot> req =
                              querySnapshot.docs.toList();
                          DocumentSnapshot item = req[index];

                          String idRequest = item["id"];
                          String namaPenumpang = item["penumpang"]["name"];
                          String jalan = item["tujuan"]["jalan"];
                          String number = item["tujuan"]["nomor"];

                          return ListTile(
                            title: Text(namaPenumpang),
                            subtitle: Text("Tujuan: $jalan, $number"),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/corrida",
                                arguments: idRequest,
                              );
                            },
                          );
                        });
                  }
                }
            }
          }),
    );
  }
}
