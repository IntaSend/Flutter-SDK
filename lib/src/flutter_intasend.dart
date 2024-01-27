// Importing necessary libraries and classes
import 'package:flutter/material.dart';
import 'package:flutter_intasend/src/checkout/enums/currency.dart';

import 'checkout/widgets/checkout_modal.dart';

// Class for handling Intasend functionalities in Flutter
class FlutterIntasend {
  // Static method to initialize the checkout process
  static Future initCheckOut({
    // Required parameters for checkout initialization
    required BuildContext context,
    required bool isTest,
    required String publicKey,
    required Currency currency,
    required double amount,
    // Optional callback functions for different payment statuses
    Function? onPending,
    Function? onProcessing,
    Function? onFailed,
    Function? onCanceled,
    Function? onPartial,
    Function? onComplete,
    Function? onRetry,
    // Optional user information
    String? firstName,
    String? lastName,
    String? email,
    double? height,
    Color? backgroundColor,
    Color? accentColor,
    double? borderRadius,
  }) async {
    // Showing a loading dialog while processing the checkout initialization
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: false,
        isScrollControlled: true,
        constraints: BoxConstraints.expand(
            height: height ?? MediaQuery.of(context).size.height * 0.95),
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: CheckOutModalWidget(
              isTest: isTest,
              publicKey: publicKey,
              currency: currency,
              amount: amount,
              backgroundColor: backgroundColor,
              accentColor: accentColor,
              height: height,
              email: email,
              lastName: lastName,
              firstName: firstName,
              onCanceled: onCanceled,
              onComplete: onCanceled,
              onFailed: onFailed,
              onPartial: onPartial,
              onPending: onPending,
              onProcessing: onProcessing,
              onRetry: onRetry,
              borderRadius: borderRadius,
            ),
          );
        });
  }
}
