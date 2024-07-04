import SwiftUI
import WebKit
import SocketIO

struct mapview: View {
    @State private var isLoading: Bool = true
    @State var isAlert = false
    @State var getdata: [GetData] = []

    

    
    var body: some View {
        ZStack {
        
            // WebView를 먼저 표시하고, isLoading일 때 로딩 인디케이터를 표시하도록 순서를 조정합니다.
            WebView(url: URL(string: "http://127.0.0.1:5000/showmap")!, isLoading: $isLoading)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.9)) // 투명도 설정
                    .frame(width: 320, height: 110)
                    .overlay(
                        Text("추세를 확인 할 지역의 랜드마크를 선택하세요.")
                            .foregroundColor(.black)
                            .font(.headline)
                    )
                    .padding()
                    .offset(y: -280) // Y축
                
                Button(action: {
                    
                               // 버튼을 클릭했을 때 수행할 동작
                            isAlert = true
                    
                           }) {
                               Image(systemName: "questionmark.circle")
                                   .font(.largeTitle)
                                   .foregroundColor(.blue)
                           }
                           .offset(x: 160,y: 250)
                           .alert("도움말", isPresented: $isAlert, actions: {
                                                 
                                              Button("확인", role: .cancel, action: {
                                            
                                              })
                                          },
                                              message: {
                                              Text("전체 데이터는 1990 ~ 2018 까지의 전세계 평균 데이터를 추합.\n 그 평균을 대한민국 랜드마크에 대입하여 추세를 예측하실수 있습니다.")
                                          })
            }
            
            // 로딩 인디케이터
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                .background(Color.clear) // 배경색 투명으로 설정
                .cornerRadius(10)
                .padding()
                .zIndex(1) // 다른 뷰들보다 앞에 표시되도록 zIndex 설정
            }
        }
        .onAppear(perform: {
            let queryModel = QueryModel()
            Task {
                getdata = try await queryModel.loadData4(url: URL(string: "http://127.0.0.1:5000/getData")!)
           
            }
        })
    }

}

    
    struct WebView: UIViewRepresentable {
        let url: URL
        @Binding var isLoading: Bool
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            return webView
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {
            let request = URLRequest(url: url)
            if uiView.url != url {
                uiView.load(request)
            }
        }
        
        class Coordinator: NSObject, WKNavigationDelegate {
            var parent: WebView
            
            init(_ parent: WebView) {
                self.parent = parent
            }
            
            func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
                DispatchQueue.main.async {
                    self.parent.isLoading = true
                }
            }
            
            func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                DispatchQueue.main.async {
                    self.parent.isLoading = false
                }
            }
            
            func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
                DispatchQueue.main.async {
                    self.parent.isLoading = false
                }
            }
            
            func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
                DispatchQueue.main.async {
                    self.parent.isLoading = false
                }
            }
        }
    
}
#Preview {
    mapview()
}

