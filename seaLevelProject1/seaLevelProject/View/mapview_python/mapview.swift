//
//  mapview.swift
//  seaLevelProject
//
//  Created by BEOM SHIEK KANG on 6/12/24.
//

import SwiftUI
import WebKit

struct mapview: View {
    @State var jsonData: [String: Any]? = nil
    var body: some View {
        struct WebView: UIViewRepresentable {
            let url: URL

            func makeUIView(context: Context) -> WKWebView {
                return WKWebView()
            }

            func updateUIView(_ uiView: WKWebView, context: Context) {
                let request = URLRequest(url: url)
                uiView.load(request)
            }
        }
        return WebView(url: URL(string: "http://127.0.0.1:5000/showmap")!)
                 .edgesIgnoringSafeArea(.all)
                 .padding()
                    
//        WebView(url: URL(string: "http://127.0.0.1:5000/goSwiftfile?name=\(getsjondata)")!)
        
    }
}

#Preview {
    mapview()
}
