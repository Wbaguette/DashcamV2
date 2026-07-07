// Author: Jean-Pierre

import SwiftUI
import WebKit

let sharedProcessPool = WKProcessPool()

struct DashcamWebView: UIViewRepresentable {
    @EnvironmentObject var warningManager: AppWarningManager
    let url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.processPool =  sharedProcessPool
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.backgroundColor = .black
        webView.isOpaque = false
        
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: ()) {
        uiView.stopLoading()
        uiView.load(URLRequest(url: URL(string: "about:blank")!))
        uiView.removeFromSuperview()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
                        
            // This bypasses the -1202 error for self-signed certs
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if let trust = challenge.protectionSpace.serverTrust {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                    return
                } else {
                    DispatchQueue.main.async {
                        // TODO: inject warning manager somehow
//                        warningManager.show(message: "Failed to get state of the servers SSL transaction state")
                    }
                    return
                }
            }
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
