import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, String> coinValues = {};
  bool isWaiting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateCurrencyExchange();
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
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIosPicker() : getAndroidDropDownButton(),
          ),
        ],
      ),
    );
  }

  Column makeCards() {
    List<Widget> cryptosCardList = [];

    for (String crypto in cryptoList) {
      CryptoCard cryptoCard = CryptoCard(
        selectedCurrency: selectedCurrency,
        cryptoCurrency: crypto,
        exchangeRate: isWaiting ? '?' : coinValues[crypto],
      );

      cryptosCardList.add(cryptoCard);
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptosCardList,
    );
  }

  DropdownButton getAndroidDropDownButton() {
    List<DropdownMenuItem<String>> dropDownItemsList = [];

    for (String currency in currenciesList) {
      DropdownMenuItem<String> dropdownMenuItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropDownItemsList.add(dropdownMenuItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItemsList,
      onChanged: (String newValue) {
        setState(() {
          selectedCurrency = newValue;
          updateCurrencyExchange();
        });
      },
    );
  }

  CupertinoPicker getIosPicker() {
    List<Widget> textList = [];
    for (String currency in currenciesList) {
      Text text = Text(currency);
      textList.add(text);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          updateCurrencyExchange();
        });
      },
      children: textList,
    );
  }

  Widget getPicker() {
    if (Platform.isAndroid)
      return getAndroidDropDownButton();
    else if (Platform.isIOS) return getIosPicker();
  }

  void updateCurrencyExchange() async {
    isWaiting = true;

    try {
      CoinData coinData = CoinData();
      var data = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;

      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print('Exception in updateCurrencyExchange: $e');
    }
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {@required this.selectedCurrency,
      this.cryptoCurrency,
      this.exchangeRate});

  final String cryptoCurrency;
  final String selectedCurrency;
  final String exchangeRate;

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
            '1 $cryptoCurrency = $exchangeRate $selectedCurrency',
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

/*

 */
