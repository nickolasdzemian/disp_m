// import 'dart:developer';
// import 'dart:io';
// import 'dart:convert';
// import 'package:shelf/shelf.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// void getRemoteConfig() async {
//   final bool result = await InternetConnectionChecker().hasConnection;
//   if (result == true) {
//     final HttpClient httpClient = HttpClient();
//     final url = Uri.parse('http://teploluxe.host/disp/ZA/check.json');
//     final request = await httpClient.getUrl(url);
//     var response = await request.close();
//     inspect(response);
    
//     Map<String, dynamic> data = jsonDecode(response.body);
//     String resp = response.toString();
//     final config = jsonDecode(resp);
//     print(config);
//   } else {
//     null;
//   }
// }
