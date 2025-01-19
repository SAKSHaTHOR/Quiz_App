import 'dart:convert';

import 'package:http/http.dart' as http;

var link = "https://api.jsonserve.com/Uw5CrX";

getQuiz() async {
  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = jsonDecode(res.body.toString());
    print("data is loaded");
    return data;
  }
}
