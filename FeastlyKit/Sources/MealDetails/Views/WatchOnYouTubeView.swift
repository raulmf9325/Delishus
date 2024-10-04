//
//  WatchOnYouTubeView.swift
//
//
//  Created by Raul Mena on 9/9/24.
//

import SwiftUI
import WebKit

struct WatchOnYouTubeView: View {
    let stringURL: String

    var body: some View {
        WebView(stringURL: stringURL)
    }
}

struct WebView: UIViewRepresentable {
    let stringURL: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        guard let url = URL(string: stringURL) else { return webView }
        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
}

#Preview {
    WatchOnYouTubeView(stringURL: "www.youtube.com")
}
