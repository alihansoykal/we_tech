import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    databaseReferenceTest
        .child('3566')
        .onValue.listen((event) {
      var snapshot = event.snapshot;
      String value = snapshot.value['RFID_TEMP'];
      print('Value is $value');
      databaseReferenceTest.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value["3566"]["WEIGHT_ADDED"]}');
      });

      //FirebaseFirestore.instance.collection("users").where("rfId",isEqualTo: value).get().then((QuerySnapshot querySnapshot ) => querySnapshot.docs.forEach((element) {print(element["name"]);}));
      print("*************************");
      // TODO: bileklik id sinin firestoreda kime ait olduğu kontrol edilip o kullanıcıya WEIGHT_ADDED datası ile ilgili işlemler yapılacak

    });
  }
  final databaseReferenceTest = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.blue),
    );
  }
}
