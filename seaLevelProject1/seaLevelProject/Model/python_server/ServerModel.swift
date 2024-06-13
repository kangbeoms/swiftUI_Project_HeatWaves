//
//  ServerModel.swift
//  seaLevelProject
//
//  Created by BEOM SHIEK KANG on 6/13/24.
//

import Foundation

struct Response: Codable {
  var results: [readData]
}

struct readData: Codable{
    var imageurl: String
    var name: String
    
    init(imageurl: String, name: String) {
        self.imageurl = imageurl
        self.name = name
    }
    
}
