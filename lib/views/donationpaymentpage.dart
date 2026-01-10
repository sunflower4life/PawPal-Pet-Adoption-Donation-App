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
  late String userEmail, userPhone, userName, userID;
  bool _isWebPlatform = false;

  @override
  void initState() {
    // Extract user data from widget
    userEmail = widget.user.email ?? '';
    userPhone = widget.user.phone ?? '';
    userName = widget.user.name ?? '';
    userID = widget.user.user_id.toString();
    _isWebPlatform = kIsWeb;
    super.initState();

    _webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // Handle page finished loading
          onPageFinished: (url) {
            // Check if payment update page is loaded
            if (url.contains('donation_update.php')) {
              // Wait 4 seconds for success page to display
              Future.delayed(const Duration(seconds: 4), () {
                if (mounted) {
                  // Navigate to donations list
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
        ),
      )
      // Load payment gateway URL
      ..loadRequest(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/donation_payment.php?email=$userEmail&phone=$userPhone&user_id=$userID&name=$userName&amount=${widget.amount}&pet_id=${widget.petId}&pet_name=${widget.petName}',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation Payment"),
        backgroundColor: const Color.fromARGB(255, 72, 38, 44),
        foregroundColor: const Color.fromARGB(255, 255, 244, 215),
      ),
      // Display payment gateway in WebView
      body: WebViewWidget(controller: _webcontroller),
    );
  }
}