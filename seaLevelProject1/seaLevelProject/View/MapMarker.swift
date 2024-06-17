//
//  MapMarker.swift
//  seaLevelProject
//
//  Created by 박정민 on 6/11/24.
//

import SwiftUI
import MapKit

struct MapMarker: View {
    
    @State var titleText: String = "전체보기"
    @State var mapinfo: [MapMarkerModel] = []
    @State var markerLat: String = ""
    @State var markerLng: String = ""
    @State var nameIndex: Int = 0
    @State var showlandmark: Bool = false
    @State var titleName: String = ""
    @State var areaName: String = ""
    @State var landmarkindex: Int = 0
    @State var showList: Bool = false
    
    
    @State var map1 = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.9910113, longitude: 127.9259497),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
    
    var body: some View {
        ZStack(content: {
            Map(position: $map1) {
                ForEach(mapinfo, id: \.name) { item in
                    let latitude = (Double(item.lat) != nil) ? Double(item.lat)! : 0.0
                    let longitude = (Double(item.lng) != nil) ? Double(item.lng)! : 0.0
                    Marker(item.name,systemImage: "building.columns" ,coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        
                }
                
            }
            VStack(spacing: 0) {
                header
                    .padding()
                Spacer()
                
                if showList {
                    HStack {
                        VStack(alignment: .leading) {
                            if let imageUrl = URL(string: "http://127.0.0.1:5000/static/images/\(titleName).jpg") {
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
                            .background(Color(red: 0.2, green: 0.5, blue: 0.8))
                            .cornerRadius(20)
                            
                            Spacer().frame(height: 35)
                            
                            Button("Next") {
                                showNextLandmark()
                                showlandmark = false
                            }
                            .frame(width: 130)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0.0, green: 0.8, blue: 0.8))
                            .cornerRadius(20)
                        }
                        .padding()
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.95, green: 0.93, blue: 0.88))
                            .offset(y: 65)
                    )
                    .cornerRadius(20)
                }
            }

                
        }).onAppear(perform: {
            fetchLandmarkData()
        })
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
      withAnimation(.easeInOut) {

        self.landmarkindex = (self.landmarkindex + 1) % self.mapinfo.count


        self.titleText = self.mapinfo[self.landmarkindex].name


        self.titleName = self.mapinfo[self.landmarkindex].name
        self.areaName = self.mapinfo[self.landmarkindex].location


        let latitude = (Double(self.mapinfo[self.landmarkindex].lat) != nil) ? Double(self.mapinfo[self.landmarkindex].lat)! : 0.0
        let longitude = (Double(self.mapinfo[self.landmarkindex].lng) != nil) ? Double(self.mapinfo[self.landmarkindex].lng)! : 0.0
        let newRegion = MKCoordinateRegion(
          center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
          span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.map1 = MapCameraPosition.region(newRegion)
      }
    }
    
    func toggleLandMark() {
        withAnimation(.easeInOut) {
            showlandmark = !showlandmark
        }
    }
    
    func showNextMapMarker(title: String, lat: String, lng: String) {
        withAnimation(.easeInOut) {
            // 제목 업데이트
            self.titleText = title
            
            // 선택한 랜드마크 마커 찾기
            guard let index = mapinfo.firstIndex(where: { $0.name == title }) else { return }
            
            // 마크하고 정보 업데이트
            self.landmarkindex = index
            self.titleName = mapinfo[index].name
            self.areaName = mapinfo[index].location
            
            // 위도와 경도 변환
            let latitude = (Double(lat) != nil) ? Double(lat)! : 0.0
            let longitude = (Double(lng) != nil) ? Double(lng)! : 0.0
            
            // 새로운 영역 설정
            let newRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            // 지도 위치 변경
            self.map1 = MapCameraPosition.region(newRegion)
            
            // 목록 항목 패널 표시
            self.showlandmark = true
            
            self.showList = true
        }
    }

    
    func showAllLandMark() {
        withAnimation(.easeInOut) {
            titleText = "전체보기"
            showlandmark = false
            let newRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 36.9910113, longitude: 127.9259497),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
            map1 = MapCameraPosition.region(newRegion)
            
            
            showList = false
        }
    }
}

#Preview {
    MapMarker()
}

extension MapMarker {
    private var header: some View {
        VStack {
            Button(action: toggleLandMark) {
                Text(titleText)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.black)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading, content: {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .padding()
                            .rotationEffect(Angle(degrees: showlandmark ? 180 : 0))
                    })
            }
            
            if showlandmark {
                List {
                    Button(action: showAllLandMark, label: {
                        Text("전체 보기")
                    })
                    
                    ForEach(mapinfo, id: \.name) { item in
                        Button(action: {
                            showNextMapMarker(title: item.name, lat: item.lat, lng: item.lng)
                            showlandmark = false
                        }, label: {
                            HStack(alignment: .top, spacing: 10) {
                                if let imageUrl = URL(string: "http://127.0.0.1:5000/static/images/\(item.name).jpg") {
                                    AsyncImage(url: imageUrl) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                        case .failure:
                                            Image(systemName: "xmark.octagon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                    Text(item.location)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        })
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .background(Color(red: 0.95, green: 0.93, blue: 0.88))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
}
