import 'dart:convert' as json;

import 'package:http/http.dart' as http;

class NetworkHelper {
  Future getData(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      var decodeData = json.jsonDecode(data);

      print('Decoded data: $decodeData');
      return decodeData;
    } else {
      print(response.body);
      print(response.statusCode);
    }
  }
}
