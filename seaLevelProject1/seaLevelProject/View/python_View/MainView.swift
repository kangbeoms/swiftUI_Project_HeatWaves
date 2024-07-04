import SwiftUI
import SDWebImageSwiftUI
import Charts

struct MainView: View {
    
    @State var readdata: [Savedata] = []
    @State var vidio: [Vidiodata] = []
    @State var isLoad: Bool = true
    
    var body: some View {
        if isLoad {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isLoad = false
                        }
                    }
                }
        } else {
            TabView {
                SituationView(readdata: $readdata, vidio: $vidio)
                    .tabItem {
                        Label("Home", systemImage: "homekit")
                    }
                
                MapMarker()
                    .tabItem {
                        Label("지도", systemImage: "map.fill")
                    }
                NavigationView{ // Detail 페이지에 버튼추가 위해
                    Detail()
                }
                        .tabItem {
                            Label("상세 정보", systemImage: "info.circle")
                        }
                
            }
            .onAppear {
                let queryModel = QueryModel()
                Task {
                    readdata = try await queryModel.loadData(url: URL(string: "http://127.0.0.1:5000/swiftnews")!)
                    vidio = try await queryModel.loadData2(url: URL(string: "http://127.0.0.1:5000/swiftyou")!)
                }
            }
        }
    }
}

struct SituationView: View {
    @Binding var readdata: [Savedata]
    @Binding var vidio: [Vidiodata]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                        NavigationLink(destination: mapview(), label: {
                            Text("지도보기")
                        })
                    // 관련 영상 섹션
                    VStack {
                    
                        Section(header: Text("관련 영상").bold()) {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                                ForEach(vidio, id: \.link) { video in
                                    let imageURL = URL(string: video.image)
                                    Button(action: {
                                        if let url = URL(string: video.link) {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        WebImage(url: imageURL)
                                            .resizable()
                                            .frame(width: 170, height: 170)
                                            .scaledToFit()
                                            .padding()
                                    }
                                }
                            }
                            .frame(height: 400)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                            .padding()
                        }
                    }
                    Divider()
                        .frame(height: 30)
                    
                    // 날씨 뉴스 섹션
                    VStack {
                        Section(header: Text("날씨 뉴스").bold()) {
                            LazyVGrid(columns: [GridItem(.flexible(minimum: 200, maximum: 370))]) {
                                ForEach(readdata, id: \.title) { todo in
                                    let imageURL = URL(string: todo.image)
                                    Button(action: {
                                        if let url = URL(string: todo.link) {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        HStack {
                                            WebImage(url: imageURL)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 110, height: 70)
                                                .padding(.trailing, 30)
                                                .padding(.vertical, 10)
                                            
                                            VStack(alignment: .leading) {
                                                Text(todo.title)
                                                    .frame(minWidth: 120,  maxWidth: 180, maxHeight: 60, alignment: .leading)
                                                HStack(content: {
                                                    Spacer()
                                                    Text(todo.publish)
                                                })
                                                
                                            }
                                            .padding()
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    Divider()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 5)
                                    
                                )
                                
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Save US!")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}


#Preview {
    MainView()
}
