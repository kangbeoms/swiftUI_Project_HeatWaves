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
    
    @State var showlandmark: Bool = false
    
    @State var map1 = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.9910113, longitude: 127.9259497),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
    
    var body: some View {
        ZStack(content: {
            Map(position: $map1) {
                ForEach(mapinfo, id: \.name) { item in
                    let latitude = (Double(item.lat) != nil) ? Double(item.lat)! : 0.0
                    let longitude = (Double(item.lng) != nil) ? Double(item.lng)! : 0.0
                    Marker(item.name, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                }
            }
            VStack(spacing: 0) {
                header
                .padding()
                
                Spacer()
            }
        }).onAppear(perform: {
            let query = MapMarkerQueryDB()
            Task {
                mapinfo = try await query.loadJsonData(url:"http://localhost:8080/swiftUI/JSP/swift_sealevel_query.jsp")
            }
        })
    }
    
    func toggleLandMark() {
        withAnimation(.easeInOut) {
            showlandmark = !showlandmark
        }
    }
    
    func showNextMapMarker(title: String, lat: String, lng: String) {
        withAnimation(.easeInOut) {
            titleText = title
            showlandmark = false
            
            let latitude = (Double(lat) != nil) ? Double(lat)! : 0.0
            let longitude = (Double(lng) != nil) ? Double(lng)! : 0.0
            let newRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            map1 = MapCameraPosition.region(newRegion)
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
                        Button(action: { showNextMapMarker(title: item.name, lat: item.lat, lng: item.lng) }, label: {
                            Text(item.name)
                                .padding(.vertical, 4)
                                .listRowBackground(Color.clear)
                        })
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
}

