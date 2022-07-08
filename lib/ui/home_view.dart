import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/net/api_methods.dart';
import 'package:crypto/net/flutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'add_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double ethereum = 0.0;
  double tether = 0.0;
  double cardano = 0.0;
  double solana = 0.0;

  @override
  initState() {
    updateValues();
  }

  updateValues() async {
    bitcoin = await getPrice("bitcoin");
    ethereum = await getPrice("ethereum");
    tether = await getPrice("tether");
    cardano = await getPrice("cardano");
    solana = await getPrice("solana");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getValue(String id, double amount) {
      if (id == "bitcoin") {
        return (bitcoin * amount).toStringAsFixed(2);
      } else if (id == "ethereum") {
        return (ethereum * amount).toStringAsFixed(2);
      } else if (id == "tether") {
        return (tether * amount).toStringAsFixed(2);
      } else if (id == "cardano") {
        return (cardano * amount).toStringAsFixed(2);
      } else if (id == "solana") {
        return (solana * amount).toStringAsFixed(2);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 51, 70),
        title: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: Center(
            child: Text("My Wallet"),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(20, 22, 41, 1),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('Coins')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data?.docs.map((document) {
                    return Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color.fromRGBO(108, 106, 235, 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 5.0),
                              Text(
                                "Coin: ${document.id}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                "Price: ${getValue(document.id, document['Amount'])}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await removeCoin(document.id);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ))
                            ],
                          )),
                    );
                  }).toList() as List<Widget>,
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(),
            ),
          );
        },
        backgroundColor: Color.fromRGBO(108, 106, 235, 1),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
