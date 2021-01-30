import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_webview_test/value_util.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FWebView extends StatefulWidget {
  final String url;
  final double height;
  final bool shouldReloadWhenBlank;
  final Function(String value) onPageStarted;
  final Function(String value) onPageFinished;
  final Function(double offsetY) offsetYChanged;
  final Function(WebViewController controller) onWebControllerCreated;
  final VoidCallback onDataLoaded;
  final VoidCallback onPageError;
  final Function(String title) setPageTitle;
  final double errorTop;

  FWebView(
      {Key key,
      this.url,
      this.height,
      this.onPageStarted,
      this.onPageFinished,
      this.onDataLoaded,
      this.offsetYChanged,
      this.shouldReloadWhenBlank = false,
      this.onWebControllerCreated,
      this.onPageError,
      this.setPageTitle,
      this.errorTop})
      : super(key: key);

  @override
  _FWebViewState createState() => _FWebViewState();
}

class _FWebViewState extends State<FWebView> {
  WebViewController _webViewController;

  bool isError = false;
  int pauseTime; // 进入后台的时间

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  injectJs() {
    if (_webViewController == null) {
      return;
    }

    /// 调试js
    String injectJsStr = '''
    UmallApp.postMessage(JSON.stringify({
       "method": "toastInjectSuccess",
       "params": {}
    }));
    ''';
    _webViewController.evaluateJavascript(injectJsStr);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("url: ${widget.url}");
    return Container(
      width: double.infinity,
      height: widget.height,
      child: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: "Mozilla/5.0 Oldbird",
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          widget.onWebControllerCreated?.call(_webViewController);
          debugPrint("❎ onWebViewCreated");
        },
        onPageStarted: (str) {
          debugPrint("❎ onPageStarted - str:$str");
          widget.onPageStarted?.call(str);
        },
        onPageFinished: (str) {
          debugPrint("❎ onPageFinished - str:$str");
          widget.onPageFinished?.call(str);
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint(
              "❌ onWebResourceError：：${error.description} - ${error.domain} - ${error.errorCode}");
          if (Platform.isIOS) {
            if (error.errorCode != -1009) return;
          } else {
            if (![WebResourceErrorType.connect, WebResourceErrorType.timeout]
                .contains(error.errorType)) return;
          }
          if (widget.onPageError != null) {
            widget.onPageError();
          }
          setState(() {
            isError = true;
          });
        },
        debuggingEnabled: false,
        javascriptChannels: <JavascriptChannel>[
          WebViewJsBridge(
            context,
            offsetYChanged: widget.offsetYChanged,
            setPageTitle: widget.setPageTitle,
            onDataLoaded: () {
              /// h5 告诉我们那边数据加载完成了，可以执行js。
              injectJs();
              widget.onDataLoaded?.call();
            },
            jsCallback: (String method, params) {
              if (_webViewController != null && method.length != null) {
                _webViewController.evaluateJavascript('$method("$params")');
              }
            },
          )
        ].toSet(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class WebViewJsBridge implements JavascriptChannel {
  final Function(double offsetY) offsetYChanged;
  final Function(String method, dynamic params) jsCallback;
  final VoidCallback onDataLoaded;
  final Function(String title) setPageTitle;
  final BuildContext context; // 来源于当前widget, 便于操作UI

  WebViewJsBridge(
    this.context, {
    this.offsetYChanged,
    this.jsCallback,
    this.onDataLoaded,
    this.setPageTitle,
  });

  @override
  String get name => "UmallApp";

  /// 处理js 请求
  @override
  get onMessageReceived => (JavascriptMessage msg) {
        String data = msg.message;
        Map json = jsonDecode(data);
        String method = ValueUtil.toStr(json['method']);
        Map<String, dynamic> params =
            Map<String, dynamic>.from(ValueUtil.toMap(json['params']));
        String callback = ValueUtil.toStr(json['callback']);
        String errorCallback = ValueUtil.toStr(json['errorCallback']);
        _executeMethod(method,
            params: params, callback: callback, errorCallback: errorCallback);
      };

  /// 执行方法
  /// [method] 方法名
  /// [params] 参数
  /// [callback] 正确方法回调
  /// [errorCallback] 错误方法回调
  _executeMethod(String method,
      {Map<String, dynamic> params, String callback, String errorCallback}) {
    if (method == 'toastInjectSuccess') {
      debugPrint("😊😊😊😊toastInjectSuccess");
    } else if (method == 'onDataLoaded') {
      // 页面加载完成出现状态栏
      onDataLoaded?.call();
    } else {
      jsCallback?.call(
          errorCallback, {"code": 400, "errorMessage": "$method 方法在原生未实现"});
    }
  }
}
