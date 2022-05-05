import 'package:bitcoin_ticker/services/NetworkHelper.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    NetworkHelper networkHelper = NetworkHelper();
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      String url =
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=964DFF73-72F9-43AD-A560-4FABB9E13656';
      var data = await networkHelper.getData(url);

      double rate = data['rate'];
      cryptoPrices[crypto] = rate.toStringAsFixed(0);
    }

    return cryptoPrices;
  }
}
