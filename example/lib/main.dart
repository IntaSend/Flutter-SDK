import 'dart:developer';

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
      debugShowCheckedModeBanner: false,
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
          onPressed: () async {
            // Initiating the Intasend checkout process when the button is pressed
            await FlutterIntasend.initCheckOut(
              context: context,
              isTest: true,
              publicKey: "ISPubKey_test_c319353e-ada9-41e6-a793-1a5ad8991e22",
              currency: Currency.kes,
              firstName: 'Test',
              lastName: 'User',
              email: 'jHbZt@example.com',
              height: MediaQuery.of(context).size.height * 0.95,
              amount: 15,
              borderRadius: 16.0,
              // Callback function for processing status
              onProcessing: () {
                log("PROCESSING PAYMENT");
              },
              onCanceled: () {
                log("CANCELED PAYMENT");
              },
              onComplete: () {
                log("COMPLETED PAYMENT");
              },
              onFailed: () {
                log("FAILED PAYMENT");
              },
              onPartial: () {
                log("PARTIAL PAYMENT");
              },
              onPending: () {
                log("PENDING PAYMENT");
              },
              onRetry: () {
                log("RETRY PAYMENT");
              },
            );
          },
          child: const Text("Complete Payment"),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
      ),
    );
  }
}
