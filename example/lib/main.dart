import 'package:flutter/material.dart';
import 'package:flutter_intasend/flutter_intasend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout example'),
      ),
      body: Center(
        child: FilledButton.tonal(
          onPressed: () {
            // Initiating the Intasend checkout process when the button is pressed
            FlutterIntasend.initCheckOut(
              context: context,
              isTest: true,
              publicKey: "ISPubKey_test_c319353e-ada9-41e6-a793-1a5ad8991e22",
              currency: Currency.kes,
              amount: 15,
              accentColor: Colors.red,
              backgroundColor: Colors.yellow,
              height: MediaQuery.of(context).size.height * 0.7,
              borderRadius: 16.0,
              // Callback function for processing status
              onProcessing: () {
                debugPrint("PROCESSING PAYMENT");
              },
              onPending: () {
                debugPrint("PENDING PAYMENT");
              },
              onCanceled: () {
                debugPrint("CANCELLED PAYMENT");
              },
              onFailed: () {
                debugPrint("FAILED PAYMENT");
              },
              onPartial: () {
                debugPrint("PARTIAL PAYMENT");
              },
              onComplete: () {
                debugPrint("COMPLETE PAYMENT");
              },
              onRetry: () {
                debugPrint("RETRY PAYMENT");
              },
            );
          },
          child: const Text("Complete Payment"),
        ),
      ),
    );
  }
}
