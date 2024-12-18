import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart'as http;

enum ApiServiceMethodeType {
  get,
  post,
}

const baseUrl ="https://api.stripe.com/v1";
final Map<String, String> requestHeaders ={
  'Content-Type': 'application/x-www-form-urlencoded',
  'Authorizatoin': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
};

Future<Map<String, dynamic>?> stripeApiService({
  required ApiServiceMethodeType requestMethode,
  Map<String, dynamic>? requestBody,
  required String endpoint,
})async{
  final requestUrl = "$baseUrl/$endpoint";
  try{
    final requestResponse = requestMethode == ApiServiceMethodeType.get
        ? await http.get(
             Uri.parse(requestUrl),
             headers: requestHeaders,
          )
        :await http.post(
          Uri.parse(requestUrl),
          headers: requestHeaders,
         body: requestBody,); 
    if (requestResponse.statusCode == 200){
      return json.decode(requestResponse.body);

    } 
    else {
      print(requestResponse.body);
      throw Exception("Faild to fetch data:${requestResponse.body}");
    }    

  }catch(error){
    print(error.toString());
    return null;
  }

}