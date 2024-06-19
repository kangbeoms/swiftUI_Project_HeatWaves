//
//  LandMarkListModel.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/19/24.
//

import Foundation

struct LandMarkListModel: Decodable{
    var name: String
    var sealevel: String
    var height: String
    
    
    init(name: String, sealevel: String, height: String){
        self.name = name
        self.sealevel = sealevel
        self.height = height
    }
    
}


extension LandMarkListModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
