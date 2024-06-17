//
//  model.swift
//  test_main
//
//  Created by BEOM SHIEK KANG on 6/16/24.
//

import Foundation
import SwiftUI

struct Savedata: Decodable{
    let title: String
    let publish: String
    let image: String
    let link: String
}

struct Vidiodata: Decodable{
    let link: String
    let image: String
}

struct DataFrame: Decodable{
    //var id = UUID()
    var Year: String
    var sealevel: String
    var co2: String
    var Population: String
    var Thickness: String
    var 북극해빙면적평균: String
    var 해상평균온도: String
    var 지구평균온도: String
}



extension Savedata: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension Vidiodata: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(link)
    }
}

extension DataFrame: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(Year)
    }
}

