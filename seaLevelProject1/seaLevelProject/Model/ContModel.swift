//
//  ContModel.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/17/24.
//

import Foundation

struct ContModel: Decodable{
    var year: String // 연도
    var seaLevel: String // 해수면 높이
    var co2: String // co2
    var population: String // Population
    var thickness: String    // Thickness
    var thicMean: String    //북극해빙면적평균
    var seaMeanTemp: String // 해상평균온도
    var earthTempMean: String   //지구평균온도
    
}
