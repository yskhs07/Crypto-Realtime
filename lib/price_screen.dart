import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedValue1 = 'USD';

  DropdownButton<String> androidDD() {
    List<DropdownMenuItem<String>> itemList = [];
    for (String currency in currenciesList) {
      var item = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      itemList.add(item);
    }
    return DropdownButton<String>(
      value: selectedValue1,
      items: itemList,
      onChanged: (value) {
        setState(() {
          selectedValue1 = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> items = [];
    for (String item in currenciesList) {
      items.add(Text(item));
    }
    return CupertinoPicker(
      looping: true,
      backgroundColor: Colors.lightBlue,
      itemExtent: 40,
      onSelectedItemChanged: (selectedValue) {
        selectedValue1 = currenciesList[selectedValue];
        getData();
      },
      children: items,
    );
  }

  Map<String, String> cryptoValues = {};
  bool isWaiting = false;
  void getData() async {
    isWaiting = true;
    try {
      var data = await Networking().getCryptoPrice(selectedValue1);
      isWaiting = false;
      setState(() {
        cryptoValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CryptoCard(
                  crypto: 'BTC',
                  currency: selectedValue1,
                  value: isWaiting ? '?' : cryptoValues['BTC']),
              CryptoCard(
                  crypto: 'ETH',
                  currency: selectedValue1,
                  value: isWaiting ? '?' : cryptoValues['ETH']),
              CryptoCard(
                  crypto: 'LTC  ',
                  currency: selectedValue1,
                  value: isWaiting ? '?' : cryptoValues['LTC'])
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDD(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
 const  CryptoCard({this.crypto, this.currency, this.value});

  final String crypto;
  final String value;
  final String currency;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto= $value $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
