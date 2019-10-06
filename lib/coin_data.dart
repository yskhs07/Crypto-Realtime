import 'package:http/http.dart' as Http;
import 'dart:convert';


const url = 'https://apiv2.bitcoinaverage.com/indices/global/ticker';


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



class Networking {
  var cryptoData;
  double lastPrice;
  Map<String, String> cryptoPrice = {};
  Future getCryptoPrice(String currencySelected) async {
    for (String crypto in cryptoList) {
      Http.Response response = await Http.get('$url/$crypto$currencySelected');
      if (response.statusCode == 200) {
        cryptoData = jsonDecode(response.body);
        lastPrice = cryptoData['last'];
        cryptoPrice[crypto] = lastPrice.toStringAsFixed(0);
        print(cryptoPrice[crypto]);
      } else {
        print(response.statusCode);
        throw ('Cannot handle Request');
      }
    }
    return cryptoPrice;
  }
}
