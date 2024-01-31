// Importing necessary libraries
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intasend/src/checkout/enums/currency.dart';
import 'package:flutter_intasend/src/checkout/services/get_checkout_url.dart';
import 'package:flutter_intasend/src/checkout/services/get_id_signature.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Custom Widget representing the Checkout Modal
class CheckOutModalWidget extends StatefulWidget {
  // Required parameters for the widget
  final bool isTest;
  final double? height;
  final String publicKey;
  final Currency currency;
  final double amount;
  final String? firstName;
  final String? lastName;
  final String? email;
  final Color? backgroundColor;
  final Color? accentColor;
  final double? borderRadius;
  final Function? onPending;
  final Function? onProcessing;
  final Function? onFailed;
  final Function? onCanceled;
  final Function? onPartial;
  final Function? onComplete;
  final Function? onRetry;

  // Constructor for the widget
  const CheckOutModalWidget({
    Key? key,
    required this.isTest,
    this.onComplete,
    this.onFailed,
    this.onProcessing,
    this.onPending,
    this.onCanceled,
    this.onPartial,
    this.onRetry,
    this.height,
    required this.publicKey,
    required this.currency,
    required this.amount,
    this.firstName,
    this.lastName,
    this.email,
    this.backgroundColor,
    this.accentColor,
    this.borderRadius,
  }) : super(key: key);

  // Creating the state for the widget
  @override
  State<CheckOutModalWidget> createState() => _CheckOutModalWidgetState();
}

// State class for the CheckOutModalWidget
class _CheckOutModalWidgetState extends State<CheckOutModalWidget> {
  // Timer for periodically checking the payment status
  Timer? _timer;

  // Creating a WebViewController for the WebView
  WebViewController? _webViewController;

  Future _loadPage() async {
    Map<String, dynamic> idSi = await getIdSignature(
      isTest: widget.isTest,
      publicKey: widget.publicKey,
      currency: widget.currency,
      amount: widget.amount,
      context: context,
    );

    String id = idSi['id'];
    String signature = idSi['signature'];

    String url = await getCheckoutUrl(
      id: id,
      signature: signature,
      isTest: widget.isTest,
      publicKey: widget.publicKey,
    );

    setState(() {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..enableZoom(false)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            // Preventing navigation to specific URLs for security reasons
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://intasend.com/')) {
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          ),
        )
        // Loading the checkout URL into the WebView
        ..loadRequest(Uri.parse(url));
    });
  }

  @override
  void initState() {
    _loadPage();
    super.initState();
    // Setting up a periodic timer to check payment status every 3 seconds
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkStatus().then(
        (status) {
          // Handling different payment statuses based on the result
          switch (status) {
            case "PENDING":
              if (widget.onPending != null) widget.onPending!();
              break;
            case "PROCESSING":
              if (widget.onProcessing != null) widget.onProcessing!();
              break;
            case "FAILED":
              if (widget.onFailed != null) widget.onFailed!();
              break;
            case "CANCELLED":
              if (widget.onCanceled != null) widget.onCanceled!();
              break;
            case "PARTIAL":
              if (widget.onPartial != null) widget.onPartial!();
              break;
            case "COMPLETE":
              if (widget.onComplete != null) widget.onComplete!();
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Payment was successful",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              break;
            case "RETRY":
              if (widget.onRetry != null) widget.onRetry!();
              break;
            default:
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // Cancelling the timer to avoid memory leaks
    _timer!.cancel();
    super.dispose();
  }

  // Function to asynchronously check the payment status
  Future<String> _checkStatus() async {
    String status = "";
    if (_webViewController != null) {
      // Getting the current URL from the WebViewController
      String? currentUrl = await _webViewController!.currentUrl();
      if (currentUrl != null) {
        // Checking if the URL matches the expected pattern for status retrieval
        if (currentUrl
            .startsWith('https://websdk-sandbox.intasend.com/results/')) {
          // Running JavaScript code in the WebView to extract the payment status
          var result = await _webViewController!.runJavaScriptReturningResult(
              'var parser = new DOMParser();'
              'var doc = parser.parseFromString(document.body.innerHTML, "text/html");'
              'var statusElement = Array.from(doc.querySelectorAll(".flex.py-1 > div"))'
              '  .find(element => element.innerText.trim() === "Status");'
              'var statusValue = "";'
              'if (statusElement && statusElement.nextElementSibling) {'
              '  statusValue = statusElement.nextElementSibling.innerText;'
              '} else {'
              '  statusValue = "INCOMPLETE";'
              '}'
              'statusValue;');

          // Extracting the status from the JavaScript result
          String objectString = result.toString();
          status = objectString.substring(1, objectString.length - 1);
        }
      }
    }
    // Returning the extracted status
    return status;
  }

  @override
  Widget build(BuildContext context) {
    // Creating a set of gesture recognizers to handle gestures in the WebView
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
      Factory(() => EagerGestureRecognizer())
    };
    // Building the widget structure
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: buildBody(gestureRecognizers: gestureRecognizers),
    );
  }

  Widget buildBody({
    required Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 3,
            child: Container(),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius == null
                  ? null
                  : BorderRadius.only(
                      topLeft: Radius.circular(widget.borderRadius!),
                      topRight: Radius.circular(widget.borderRadius!),
                    ),
              color: widget.backgroundColor ??
                  Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
          buildWebView(
            backgroundColor: widget.backgroundColor ??
                Theme.of(context).scaffoldBackgroundColor,
            gestureRecognizers: gestureRecognizers,
          ),
        ],
      );

  Widget buildWebView({
    required Color backgroundColor,
    required Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
  }) =>
      _webViewController == null
          ? Flexible(
              flex: 1,
              child: Container(
                color: widget.backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: CircularProgressIndicator(
                    color: widget.accentColor,
                  ),
                ),
              ),
            )
          : Flexible(
              flex: 5,
              child: Container(
                color: widget.backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
                child: WebViewWidget(
                  controller: _webViewController!,
                  gestureRecognizers: gestureRecognizers,
                ),
              ),
            );
}
