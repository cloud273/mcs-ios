/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */

import UIKit
import WebKit

public protocol WebContent {
    func load(_ webview: WKWebView)
}

public class WebDataContent : WebContent {
    
    public var data : Data
    public var mime : String
    
    public init(_ data : Data, mime : String) {
        self.data = data
        self.mime = mime
    }
    
    public func load(_ webView: WKWebView) {
        webView.load(data, mimeType: mime, characterEncodingName: "", baseURL: URL(string: "http://localhost")!)
    }
    
}

public class WebUrlContent : WebContent {
    
    public var url : URL
    
    public init(_ url : URL) {
        self.url = url
    }
    
    public func load(_ webView: WKWebView) {
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10))
    }
    
}

open class QDWebViewController: QDViewController {

    private var _webView: WKWebView!
    
    public var webView: WKWebView! {
        get {
            if (_webView == nil) {
                let source: String = "var meta = document.createElement('meta');" +
                    "meta.name = 'viewport';" +
                    "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                    "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
                let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
                let userContentController: WKUserContentController = WKUserContentController()
                userContentController.addUserScript(script)
                
                let webConfiguration = WKWebViewConfiguration()
                webConfiguration.userContentController = userContentController
                _webView = WKWebView(frame: .zero, configuration: webConfiguration)
            }
            return _webView
        }
    }
    
    public var content : WebContent?
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading))
    }
    
    override open func loadView() {
        view = webView
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = .white
        if isRefresh() {
            setRefreshToScrollView(webView.scrollView)
        }
        reload()
    }
    
    open func isRefresh() -> Bool {
        return true
    }
    
    public func reload() {
        content?.load(webView)
    }
    
    override open func refresh() {
        webView.reload()
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = object as? WKWebView else { return }
        guard let keyPath = keyPath else { return }
        guard let change = change else { return }
        if keyPath == #keyPath(WKWebView.isLoading) {
            if let val = change[NSKeyValueChangeKey.newKey] as? Bool {
                if val {
                    startLoading()
                } else {
                    stopLoading()
                }
            }
        }
    }
    
    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func stopLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        endRefresh()
    }
    
}
