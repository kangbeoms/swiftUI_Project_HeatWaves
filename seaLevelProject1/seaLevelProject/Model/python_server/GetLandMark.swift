//
//  GetLandMark.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/13/24.
//

import Foundation


struct GetLandMark: Decodable{
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
