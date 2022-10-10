import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../../logic/view_models/company_details_manager.dart';
import '../../../models/helper/service_locator.dart';
import '../../routes/router.dart';

class PaymentUrl extends StatefulWidget {
  String paymentUrl;

  PaymentUrl({required this.paymentUrl});

  @override
  State<PaymentUrl> createState() => _PaymentUrlState();
}

class _PaymentUrlState extends State<PaymentUrl> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  bool flag = false;
  bool isCompleted = false;
  int counter = 0;
  late StreamSubscription _onDestroy;
  late StreamSubscription<String> _onUrlChanged;
  late StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void dispose() {
    counter = 0;
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    flag = false;
    isCompleted = false;
    counter = 0;
    flutterWebviewPlugin.close();

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {});

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {

      }
    });

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {

        // if (url.contains("login") || url.contains("redirect")) {
        //         Navigator.pushNamed(context, landing);
        //         flutterWebviewPlugin.close();
        // } else
          if ( url.contains("uat.xuriti.app") ) {
          counter++;
          print("counter");
          print(counter);
          print("url changed 2 $url");

          if ( counter >= 3 ) {
           // print("url changed 2 $url");

            counter = 0;
            print("counter close");
            print(counter);
            Navigator.pushNamed(context, landing);
            flutterWebviewPlugin.close();
          }
        }


      }
    });
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }
  Widget build(BuildContext context) {
   // print("paymentUrl: ${widget.paymentUrl}");
    return WebviewScaffold(
        url: widget.paymentUrl,
        appBar: AppBar(
          backgroundColor: Color(0xff6f21d1),
          title: Text(
            "Pay Now",
          ),
        ));
  }
}
