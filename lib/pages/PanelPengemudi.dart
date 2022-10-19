import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:damri/util/StatusRequest.dart';
import 'package:damri/util/UserFirebase.dart';

class PanelPengemudi extends StatefulWidget {
  const PanelPengemudi({Key? key}) : super(key: key);

  @override
  State<PanelPengemudi> createState() => _PanelPengemudiState();
}

class _PanelPengemudiState extends State<PanelPengemudi> {
  List<String> itemsMenu = ["Profile", "Logout"];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;

  _logoutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _chooseMenuItem(String choose) {
    switch (choose) {
      case "Logout":
        _logoutUser();
        break;
      case "Profile":
        // userprofile
        break;
    }
  }

  Stream<QuerySnapshot>? _addListenerRequests() {
    final stream = db
        .collection("request")
        .where("status", isEqualTo: StatusRequisicao.AGUARDANDO)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
    return null;
  }

  _retrieveActiveDriverRequest() async {
    //Recupera dados do usuario logado
    User user = await UserFirebase.getCurrentUser();

    //Recupera requisicao ativa
    DocumentSnapshot documentSnapshot =
        await db.collection("requisicao_ativa_motorista").doc(user.uid).get();

    Map<String, dynamic>? dataRequst =
        documentSnapshot.data() as Map<String, dynamic>?;

    if (dataRequst == null) {
      _addListenerRequests();
    } else {
      String idRequest = dataRequst["id_requisicao"];
      Navigator.pushReplacementNamed(
        context,
        "/corrida",
        arguments: idRequest,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    /*
    Recuperar requisicao ativa para verificar se motorista está
    atendendo alguma requisição e envia ele para tela de corrida
    */
    _retrieveActiveDriverRequest();
  }

  @override
  Widget build(BuildContext context) {
    var messageLoading = Center(
      child: Column(
        children: const [
          Text("Memuat permintaan..."),
          CircularProgressIndicator()
        ],
      ),
    );

    var messageNoData = const Center(
        child: Text(
      "Anda tidak memiliki permintaan apa pun :( ",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Panel Pengemudi",
          style: TextStyle(color: Colors.black),
        ),
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
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text("Terjadi kesalahan saat memuat data!");
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
                        itemBuilder: (context, indice) {
                          List<DocumentSnapshot> requisicoes =
                              querySnapshot.docs.toList();
                          DocumentSnapshot item = requisicoes[indice];

                          String idRequisicao = item["id"];
                          String nomePassageiro = item["passageiro"]["nome"];
                          String rua = item["destino"]["rua"];
                          String numero = item["destino"]["numero"];

                          return ListTile(
                            title: Text(nomePassageiro),
                            subtitle: Text("Tujuan: $rua, $numero"),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/lacak",
                                arguments: idRequisicao,
                              );
                            },
                          );
                        });
                  }
                }

                break;
            }
          }),
    );
  }
}
