import 'package:crypto/net/flutterfire.dart';
import 'package:flutter/material.dart';

class AddView extends StatefulWidget {
  AddView({Key? key}) : super(key: key);

  @override
  _AddViewState createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  List<String> coins = [
    "bitcoin",
    "tether",
    "ethereum",
    "cardano",
    "solana",
  ];

  String dropdownValue = 'bitcoin';
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(20, 22, 41, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
            dropdownColor: Color.fromRGBO(40, 44, 74, 1),
            iconEnabledColor: Color.fromRGBO(40, 36, 202, 1),
            value: dropdownValue,
            items: coins.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (String? newvalue) {
              setState(() {
                dropdownValue = newvalue!;
              });
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: TextFormField(
              controller: _amountController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle:
                    TextStyle(color: Color.fromARGB(255, 129, 126, 126)),
                labelText: "Coin Amount",
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 35),
          Container(
            width: MediaQuery.of(context).size.width / 1.4,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Color.fromRGBO(108, 106, 235, 1),
            ),
            child: MaterialButton(
              onPressed: () async {
                await addCoin(dropdownValue, _amountController.text);
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ),
        ],
      ),
    );
  }
}
