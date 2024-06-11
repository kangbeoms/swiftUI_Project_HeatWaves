//
//  MapMarkerQueryDB.swift
//  seaLevelProject
//
//  Created by 박정민 on 6/11/24.
//

import Foundation


struct MapMarkerQueryDB {
    func loadJsonData(url: String) async throws -> [MapMarkerModel] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        print(data)
        return try JSONDecoder().decode([MapMarkerModel].self, from: data)
    }
    
    func urlAction(url: String) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let res = try JSONDecoder().decode([String].self, from: data)
        
        return res[0]
    }
    
    
}
