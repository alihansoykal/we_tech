import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final List<StreamModel>? liste;

  const HomePage({Key? key, this.liste}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final databaseReferenceTest = FirebaseDatabase.instance.reference();
  late SharedPreferences sharedPreferences;
  List<StreamModel> liste = [];
  String tempRf = '';
  int tempWeight = 0;

  @override
  void initState() {
    initShared();
    if (widget.liste != null) {
      liste.addAll(widget.liste!);
    }
    super.initState();
  }

  initShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
    tempRf = sharedPreferences.getString('tempRf') ?? '';
    tempWeight = sharedPreferences.getInt('tempWeight') ?? 0;
  }

  Future saveTemp({required String rf, required int weight}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    tempRf = rf;
    tempWeight = weight;
    await sharedPreferences.setString('tempRf', tempRf);
    await sharedPreferences.setInt('tempWeight', tempWeight);
  }

/*
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    databaseReferenceTest.child('3566').onValue.listen((event) async {
      var snapshot = event.snapshot;
      String value = snapshot.value['RFID_TEMP'];
      print('Value is $value');
      databaseReferenceTest
          .child('3566')
          .child('WEIGHT_ADDED')
          .once()
          .then((DataSnapshot snapshot) {
        var data = snapshot.value;
        print('Data : $data');
        users
            .where("rfId", isEqualTo: value)
            .get()
            .then((QuerySnapshot querySnapshot) {
          var user = querySnapshot.docs.first;
          users.doc(user["uid"]).update({
            "coins": ((user["coins"] + 2 * data) as num).round(),
            "recycled": ((user["recycled"] + data) as num).round()
          });
        });
      });
    });
    await databaseReferenceTest.child('/3566/RFID_TEMP').set('');
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => setState(() => liste.clear()),
            icon: Icon(
              Icons.delete,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  liste: liste,
                ),
              ),
            ),
            icon: Icon(
              Icons.refresh,
            ),
          ),
        ],
        title: Text(
          'WE TEAM',
        ),
      ),
      body: StreamBuilder(
        stream: databaseReferenceTest.child('3566').onValue.distinct(),
        builder: (_, AsyncSnapshot<Event> event) {
          if (event.hasData) {
            var rfId = event.data!.snapshot.value['RFID_TEMP'];
            var weight = event.data!.snapshot.value['WEIGHT_ADDED'];
            if (rfId != null && rfId != '') {
              saveTemp(rf: rfId, weight: weight);
              if (weight != tempWeight) {
                users
                    .where("rfId", isEqualTo: rfId)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  var user = querySnapshot.docs.first;
                  var coins = ((user["coins"] + 2 * weight) as num).round();
                  var recycled = ((user["recycled"] + weight) as num).round();
                  users.doc(user["uid"]).update({
                    "coins": coins,
                    "recycled": recycled,
                  }).then((_) {
                    liste.add(
                      StreamModel(
                        userName: user['name'],
                        uid: user['uid'],
                        weight: weight,
                        coins: coins,
                        recycled: recycled,
                      ),
                    );
                    databaseReferenceTest
                        .child('3566')
                        .child('RFID_TEMP')
                        .set('');
                    setState(() {});
                  });
                });
              } else {
                if (rfId != tempRf) {
                  users
                      .where("rfId", isEqualTo: rfId)
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    var user = querySnapshot.docs.first;
                    var coins = ((user["coins"] + 2 * weight) as num).round();
                    var recycled = ((user["recycled"] + weight) as num).round();
                    users.doc(user["uid"]).update({
                      "coins": coins,
                      "recycled": recycled,
                    }).then((_) {
                      liste.add(
                        StreamModel(
                          userName: user['name'],
                          uid: user['uid'],
                          weight: weight,
                          coins: coins,
                          recycled: recycled,
                        ),
                      );
                      databaseReferenceTest
                          .child('3566')
                          .child('RFID_TEMP')
                          .set('');
                      setState(() {});
                    });
                  });
                } else {
                  databaseReferenceTest
                      .child('3566')
                      .child('RFID_TEMP')
                      .set('');
                }
              }
            }

            if (liste.isEmpty) {
              return Center(
                child: Text('İşlem Yok'),
              );
            }
            return ListView.builder(
              itemCount: liste.length,
              itemBuilder: (_, index) {
                var model = liste[index];
                return ListTile(
                  title: Text('${model.userName} - ${model.weight} gr.'),
                  subtitle: Text('ID: ${model.uid}'),
                  trailing:
                      Text('${model.coins} Coin\n${model.recycled} Rcyc.'),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class StreamModel {
  final String userName;
  final String uid;
  final int weight;
  final int coins;
  final int recycled;

  StreamModel({
    required this.userName,
    required this.uid,
    required this.weight,
    required this.coins,
    required this.recycled,
  });
}
