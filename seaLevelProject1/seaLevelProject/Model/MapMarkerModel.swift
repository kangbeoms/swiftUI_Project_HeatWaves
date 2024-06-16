//
//  MapMarkerModel.swift
//  seaLevelProject
//
//  Created by 박정민 on 6/11/24.
//

import Foundation


struct MapMarkerModel: Decodable{
    var name: String
    var lat: String
    var lng: String
    var sealevel: String
    var height: String
    var location: String
    
    
    init(name: String, lat: String, lng: String, sealevel: String, height: String, location: String){
        self.name = name
        self.lat = lat
        self.lng = lng
        self.sealevel = sealevel
        self.height = height
        self.location = location
    }
    
}


extension MapMarkerModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
