import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raskop_fe_backoffice/res/assets.dart';
import 'package:raskop_fe_backoffice/shared/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

///
class WebviewPaymentScreen extends ConsumerStatefulWidget {
  ///
  const WebviewPaymentScreen({required this.redirectUrl, super.key});

  ///
  final String redirectUrl;

  ///
  static const String route = 'payment';

  @override
  ConsumerState<WebviewPaymentScreen> createState() =>
      _WebviewPaymentScreenState();
}

class _WebviewPaymentScreenState extends ConsumerState<WebviewPaymentScreen> {
  Future<void> _showResultDialog(String message, String status) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Status Pembayaran'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                context
                  ..pop()
                  ..pop();
                setState(() {
                  if (status == 'success') {
                    Toast().showSuccessToast(
                      context: context,
                      title: 'Status Pembayaran',
                      description: message,
                    );
                  } else if (status == 'pending') {
                    Toast().showWarningToast(
                      context: context,
                      title: 'Pembayaran Tertunda',
                      description: message,
                    );
                  } else {
                    Toast().showErrorToast(
                      context: context,
                      title: 'Pembayaran Gagal',
                      description: message,
                    );
                  }
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  PlatformWebViewControllerCreationParams params =
      const PlatformWebViewControllerCreationParams();

  @override
  void initState() {
    super.initState();
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(
        params,
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(
        params,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) {
        log(request.platform.toString(), name: 'Permission Request');
      },
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setBackgroundColor(const Color(0xFFFFFFFF));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Center(
          child: Image.asset(ImageAssets.raskop),
        ),
      ),
      body: WebViewWidget(
        controller: controller
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                final url = request.url;
                if (url.contains('status_code=200') ||
                    url.contains('transaction_status=success')) {
                  _showResultDialog('Pembayaran Berhasil!', 'success');
                  return NavigationDecision.prevent;
                } else if (url.contains('transaction_status=pending')) {
                  _showResultDialog('Pembayaran Pending.', 'pending');
                  return NavigationDecision.prevent;
                } else if (url.contains('transaction_status=failure') ||
                    url.contains('status_code=400')) {
                  _showResultDialog('Pembayaran Gagal.', 'failure');
                  return NavigationDecision.prevent;
                } else if (url.contains('transaction_status=expire')) {
                  _showResultDialog('Pembayaran Kadaluarsa', 'expire');
                  return NavigationDecision.prevent;
                } else if (url.contains('blob')) {
                  Toast().showWarningToast(
                    context: context,
                    title: 'Unprocessable',
                    description:
                        'Untuk sementara waktu, Download QRIS tidak dapat dilakukan.\nSilakan langsung scan QR yang tersedia!',
                  );
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
              onWebResourceError: (WebResourceError error) {
                print('WebView Error: ${error.description}');
              },
            ),
          )
          ..addJavaScriptChannel(
            'QRScanner',
            onMessageReceived: (receiver) {
              if (![null, 'undefined'].contains(receiver.message)) {
                final result = jsonDecode(receiver.message);
                log(
                  result.toString(),
                  name: 'Midtrans Response',
                );
                print('QRCODE URL: $result');
              }
            },
          )
          ..runJavaScript('''
          setTimeout(() => {
            let qrImg = document.querySelector('img[src*="qr"]');
            if (qrImg) {
              QRScanner.postMessage(qrImg.src);
            }
          }, 3000);
        ''')
          ..loadRequest(Uri.parse(widget.redirectUrl)),
      ),
    );
  }
}
