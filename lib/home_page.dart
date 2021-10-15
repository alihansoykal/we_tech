import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List uids = [];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final CollectionReference users =
        await FirebaseFirestore.instance.collection('users');
    final databaseReferenceTest = FirebaseDatabase.instance.reference();

    databaseReferenceTest.child('3566').onValue.listen((event) async {
      var snapshot = event.snapshot;
      String value = snapshot.value['RFID_TEMP'];
      print('Value is $value');
      databaseReferenceTest.once().then((DataSnapshot snapshot) {
        var data = snapshot.value["3566"]["WEIGHT_ADDED"];
        print('Data : ${snapshot.value["3566"]["WEIGHT_ADDED"]}');
        users
            .where("rfId", isEqualTo: value)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((element) {
            uids.add(element["uid"]);
            users.doc(element["uid"]).get().then((val) {
              users.doc(element["uid"]).update({
                "coins": val["coins"] + 2 * data,
                "recycled": val["recycled"] + data
              });
            });
          });
        });
      });
      uids.clear();
    });
    await databaseReferenceTest.child('/3566/RFID_TEMP').set('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(uids);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
      body: Container(color: Colors.blue),
    );
  }
}
