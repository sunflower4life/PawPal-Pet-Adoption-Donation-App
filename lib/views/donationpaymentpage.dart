import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/mydonationsscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DonationPaymentPage extends StatefulWidget {
  final User user;
  final double amount;
  final int petId;
  final String petName;

  const DonationPaymentPage({
    super.key,
    required this.user,
    required this.amount,
    required this.petId,
    required this.petName,
  });

  @override
  State<DonationPaymentPage> createState() => _DonationPaymentPageState();
}

class _DonationPaymentPageState extends State<DonationPaymentPage> {
  late WebViewController _webcontroller;
  bool _isWebPlatform = false;

  @override
  void initState() {
    super.initState();
    _isWebPlatform = kIsWeb;

    String paymentUrl = '${MyConfig.baseUrl}/pawpal/api/donation_payment.php?'
        'email=${Uri.encodeComponent(widget.user.email ?? '')}&'
        'phone=${Uri.encodeComponent(widget.user.phone ?? '')}&'
        'user_id=${widget.user.user_id}&'
        'name=${Uri.encodeComponent(widget.user.name ?? '')}&'
        'amount=${widget.amount}&'
        'pet_id=${widget.petId}&'
        'pet_name=${Uri.encodeComponent(widget.petName)}';

    print("Payment URL: $paymentUrl");

    if (kIsWeb) {
      // 🔥 FLUTTER WEB → redirect browser
      launchUrl(
        Uri.parse(paymentUrl),
        mode: LaunchMode.platformDefault,
      ).then((_) {
        // After payment, navigate to My Donations
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyDonationsScreen(user: widget.user),
              ),
            );
          }
        });
      });
    } else {
      // 📱 MOBILE → use WebView
      _webcontroller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              print("WebView loading: $url");
            },
            onPageFinished: (url) {
              print("WebView finished: $url");
              
              // Check if we're on the success page
              if (url.contains('donation_update.php')) {
                print("Payment page detected, waiting for completion...");
                
                // After 4 seconds, navigate to My Donations
                // (gives time for the success page to show)
                Future.delayed(const Duration(seconds: 4), () {
                  if (mounted) {
                    print("Navigating to My Donations...");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyDonationsScreen(user: widget.user),
                      ),
                    );
                  }
                });
              }
            },
            onWebResourceError: (error) {
              print("WebView error: ${error.description}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: ${error.description}"),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        )
        ..loadRequest(Uri.parse(paymentUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isWebPlatform) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Donation Payment"),
          backgroundColor: const Color.fromARGB(255, 72, 38, 44),
          foregroundColor: const Color.fromARGB(255, 255, 244, 215),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Opening payment gateway..."),
              SizedBox(height: 10),
              Text(
                "You will be redirected back after payment",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation Payment"),
        backgroundColor: const Color.fromARGB(255, 72, 38, 44),
        foregroundColor: const Color.fromARGB(255, 255, 244, 215),
      ),
      body: WebViewWidget(controller: _webcontroller),
    );
  }
}