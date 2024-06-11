//
//  MapMarker.swift
//  seaLevelProject
//
//  Created by 박정민 on 6/11/24.
//

import SwiftUI
import MapKit

struct MapMarker: View {
    
    @State var mapinfo: [MapMarkerModel] = []
    
    
    @State var map1 = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.9910113, longitude: 127.9259497),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
    
    var body: some View {
        Map(position: $map1){
            ForEach(mapinfo, id: \.name) { item in
                let latitude = (Double(item.lat) != nil) ? Double(item.lat)! : 0.0
                let longitude = (Double(item.lng) != nil) ? Double(item.lng)! : 0.0
                Marker(item.name, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
        }.onAppear(perform: {
            let query = MapMarkerQueryDB()
            Task {
              mapinfo = try await query.loadJsonData(url:"http://localhost:8080/swiftUI/JSP/swift_sealevel_query.jsp")
                for item in mapinfo {
                    print("건물이름 : \(item.name) \nlat :\(item.lat)\nlng:\(item.lng)")
                }
            }
        })
    }
    
    
    
    
    
}

#Preview {
    MapMarker()
}
