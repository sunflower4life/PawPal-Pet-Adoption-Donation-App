import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/donation_payment.php?'
          'email=${Uri.encodeComponent(widget.user.email ?? '')}&'
          'phone=${Uri.encodeComponent(widget.user.phone ?? '')}&'
          'user_id=${widget.user.user_id}&'
          'name=${Uri.encodeComponent(widget.user.name ?? '')}&'
          'amount=${widget.amount}&'
          'pet_id=${widget.petId}&'
          'pet_name=${Uri.encodeComponent(widget.petName)}',
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
      body: Stack(
        children: [
          WebViewWidget(controller: _webcontroller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}