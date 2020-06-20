import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

//https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=7755239A-B8CA-451E-B6AE-7DD1F99BFFD1
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selCur = currenciesList[0];
  String currencyValue = "?";
  String currencyValueBTC = "?";
  String currencyValueETH = "?";
  String currencyValueLTC = "?";

  CupertinoPicker getPicker() {
    List<Text> pickerItems = [];
    for (String cur in currenciesList) {
      pickerItems.add(Text(
        cur,
        style: TextStyle(color: Colors.white),
      ));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlueAccent,
        itemExtent: 35.0,
        onSelectedItemChanged: (index) {
          setState(() {
            selCur = currenciesList[index];
            setCryptoTiles();
          });
        },
        children: pickerItems);
  }

  DropdownButton getDropdown() {
    List<DropdownMenuItem> dropdownItems = [];
    for (String cur in currenciesList) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(cur),
        value: cur,
      ));
    }
    return DropdownButton(
        value: selCur,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selCur = value;
            setCryptoTiles();
          });
        });
  }

  Future<String> getExchangeRates(String cur, String cryptoType) async {
    currencyValue = "?";
    var data =
        await CoinData(cur: cur, cryptoType: cryptoType).getExchangeRates();
    print(data);
    var decodedData = jsonDecode(data);
    double rate = decodedData['rate'];
    currencyValue = rate != null ? rate.round().toString() : "0";
    setState(() {
      currencyValueBTC = '?';
      currencyValueETH = '?';
      currencyValueLTC = '?';
    });
    return currencyValue;
  }

  @override
  void initState() {
    super.initState();
    setCryptoTiles();
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
            children: [
              CryptoCard(
                currencyValue: currencyValueBTC,
                selCur: selCur,
                cryptoCur: cryptoList[0],
              ),
              CryptoCard(
                currencyValue: currencyValueETH,
                selCur: selCur,
                cryptoCur: cryptoList[1],
              ),
              CryptoCard(
                currencyValue: currencyValueLTC,
                selCur: selCur,
                cryptoCur: cryptoList[2],
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlueAccent,
            child: Platform.isIOS ? getPicker() : getDropdown(),
          ),
        ],
      ),
    );
  }

  void setCryptoTiles() async {
    String a = await getExchangeRates(selCur, cryptoList[0]);
    String b = await getExchangeRates(selCur, cryptoList[1]);
    String c = await getExchangeRates(selCur, cryptoList[2]);
    setState(() {
      currencyValueBTC = a;
      currencyValueETH = b;
      currencyValueLTC = c;
    });
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key key,
    @required this.currencyValue,
    @required this.selCur,
    @required this.cryptoCur,
  }) : super(key: key);

  final String currencyValue;
  final String selCur;
  final String cryptoCur;

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
            '1 $cryptoCur = $currencyValue $selCur',
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
