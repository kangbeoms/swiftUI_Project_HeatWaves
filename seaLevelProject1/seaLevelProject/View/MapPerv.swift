import SwiftUI

struct MapPerv: View {
    
    @State var mapinfo: [MapMarkerModel] = []
    @State var titleName: String = ""
    @State var areaName: String = ""
    @State var landmarkindex: Int = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let imageUrl = URL(string: "http://127.0.0.1:5000/static/images/63%EB%B9%8C%EB%94%A9.jpg") {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                                .clipped()
                        case .failure:
                            Image(systemName: "xmark.octagon")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Text(titleName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(areaName)
                    .font(.subheadline)
            }
            .padding()
            
            Spacer()
            
            VStack {
                Button("해수면상승예측하러가기") {
                    // 액션 추가
                }
                .frame(width: 130)
                .frame(height: 50)
                .font(.system(size: 13))
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(20)
                
                Spacer().frame(height: 35)
                
                Button("Next") {
                    showNextLandmark()
                }
                .frame(width: 130)
                .frame(height: 50)
                .foregroundColor(.white)
                .padding()
                .background(Color.gray)
                .cornerRadius(20)
            }
            .padding()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
        )
        .cornerRadius(20)
        .onAppear {
            fetchLandmarkData()
        }
    }
    
    func fetchLandmarkData() {
        let query = MapMarkerQueryDB()
        Task {
            mapinfo = try await query.loadJsonData(url: "http://localhost:8080/swiftUI/JSP/swift_sealevel_query.jsp")
            updateLandmark()
        }
    }
    
    func updateLandmark() {
        guard !mapinfo.isEmpty else { return }
        titleName = mapinfo[landmarkindex].name
        areaName = mapinfo[landmarkindex].location
    }
    
    func showNextLandmark() {
        landmarkindex = (landmarkindex + 1) % mapinfo.count
        updateLandmark()
    }
}

#Preview {
    MapPerv()
}
