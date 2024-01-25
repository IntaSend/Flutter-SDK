// Importing the dart:convert library for encoding and decoding JSON data
import "dart:convert";

// Importing the host function from the specified file
import 'package:flutter_intasend/src/checkout/utils/host.dart';

// Asynchronous function to get the checkout URL
Future<String> getCheckoutUrl({
  // Required parameters for the function
  required String id,
  required String signature,
  required bool isTest,
  required String publicKey,
}) async {
  // Creating a Map to hold data for encoding into JSON
  Map<String, dynamic> data = {
    "checkout_id": id,
    "signature": signature,
  };

  // Encoding the data into a base64-encoded string
  String encoded = base64Encode(utf8.encode(jsonEncode(data)));

  // Creating another Map for the payload with additional parameters
  Map<String, dynamic> payload = {
    "checkout": encoded,
    "is_mobile": "false",
  };

  // Creating a query string from the payload using Uri class
  String params = Uri(queryParameters: payload).query;

  // Constructing the final checkout URL by combining the host URL and query parameters
  String src = "${host(isTest: isTest)}$params";

  // Returning the final checkout URL
  return src;
}
