import 'package:http/http.dart' as http;

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
//  String _apikey = "?apikey=7755239A-B8CA-451E-B6AE-7DD1F99BFFD1";
  String _apikey = "?apikey=84238052-79A1-41ED-BE97-8EAA51B3ABA2";
  String _url = "https://rest.coinapi.io/v1/exchangerate";
  final String cur;
  final String cryptoType;
  CoinData({this.cur, this.cryptoType});

  Future<dynamic> getExchangeRates() async {
    http.Response response =
        await http.get(_url + "/$cryptoType/" + cur + _apikey);
    return response.body;
  }
}
