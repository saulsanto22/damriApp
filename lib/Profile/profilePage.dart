import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:damri/Profile/edit_profile_page.dart';
import 'package:damri/Profile/widget/appbar_widget.dart';
import 'package:damri/Profile/widget/button_widget.dart';
import 'package:damri/Profile/widget/numbers_widget.dart';
import 'package:damri/Profile/widget/profile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damri/shared/loading.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late String name;
  late String userType;
  late String imageUrl;

  Future<void> setUserData() async {
    final String uid = _auth.currentUser!.uid;
    DocumentSnapshot ds = await users.doc(uid).get();

    name = ds.get('name');
    userType = ds.get('typeUser');
    // imageUrl = ds.get('imageUrl');
  }

  void setData(String name, String imageUrl) {
    setState(() {
      this.name = name;
      this.imageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Loading(message: 'Loading...');
        }
        return Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                            name: name, imageUrl: imageUrl, setData: setData)),
                  );
                },
              ),
              const SizedBox(height: 24),
              buildName(),
              // const SizedBox(height: 24),
              // Center(child: buildUpgradeButton()),
              // const SizedBox(height: 24),
              // NumbersWidget(),
              const SizedBox(height: 48),
              buildAbout(),
            ],
          ),
        );
      },
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            _auth.currentUser!.email!,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(userType,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade To PRO',
        onClicked: () {},
      );

  Widget buildAbout() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'You can edit your profile here.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
