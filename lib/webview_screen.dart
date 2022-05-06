import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {

  static const routeName = '/webview_screen';
  final String url_link;
  WebViewScreen({required Key key, required this.url_link}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();

}

class _WebViewState extends State<WebViewScreen> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  int _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0,
      title: Text(
        'Back',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: IndexedStack(
          index: _stackToView,
          children: [
            Column(
              children: <Widget>[
                Expanded(
                    child: WebView(
                      initialUrl: widget.url_link,
                      gestureNavigationEnabled: false,
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageFinished: _handleLoad,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                      },
                    )),
              ],
            ),
            Container(
                child: Center(child: CircularProgressIndicator(),)
            ),
          ],
        ));
  }
}