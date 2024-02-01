// Importing necessary libraries
import 'dart:convert'; // For encoding and decoding JSON
import 'package:flutter/material.dart';
import 'package:flutter_intasend/src/checkout/enums/currency.dart'; // Custom enum for currency
import 'package:http/http.dart' as http; // For making HTTP requests

// Asynchronous function to get ID and Signature
Future<Map<String, dynamic>> getIdSignature({
  // Required parameters for the function
  required BuildContext context,
  required bool isTest,
  required String publicKey,
  required Currency currency,
  required double amount,
  String? firstName,
  String? lastName,
  String? email,
}) async {
  // Defining live and test host URLs
  String liveHost = "https://payment.intasend.com";
  String testHost = "https://sandbox.intasend.com";

  // Function to determine the host URL based on whether it is a test environment
  String host({required bool test}) => test ? testHost : liveHost;

  // Creating a payload map with data for the HTTP request
  final Map<String, dynamic> payload = {
    "public_key": publicKey,
    "currency": enumStringCurrency(currency: currency),
    if (email != null) "email": email,
    "amount": amount,
    if (firstName != null) "first_name": firstName,
    if (lastName != null) "last_name": lastName,
  };

  // Defining the endpoint for the API request
  String endPoint = "checkout/";

  // Constructing the complete URL for the API request
  String url = "${host(test: isTest)}/api/v1/$endPoint";

  try {
    // Making an HTTP POST request
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    // Decoding the response body into a Map
    Map<String, dynamic> data = jsonDecode(response.body);

    // Checking if the request was successful (status code 200 or 201)
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Returning a map with ID and Signature if successful
      return {
        "id": data['id'],
        "signature": data['signature'],
      };
    } else {
      // Throwing an exception if the request was not successful, including error details
      throw Exception('${data['errors'][0]['detail']}');
    }
  } catch (e) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        String errorMessage = 'An error occurred';

        if (e is http.ClientException) {
          errorMessage =
              'Unable to connect to the server. Please check your internet connection.';
        } else if (e is FormatException) {
          errorMessage = 'Invalid server response. Please try again later.';
        } else if (e is Exception) {
          errorMessage = 'Something went wrong. Please try again later.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(errorMessage),
          ),
        );
        Navigator.pop(context);
      },
    );

    // Throwing an exception if an error occurs during the request
    throw Exception('$e');
  }
}
