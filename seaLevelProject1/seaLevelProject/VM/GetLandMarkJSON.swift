//
//  GetLandMarkJSON.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/13/24.
//

import Foundation


struct GetLandMarkJSON {
    func loadJsonData(url: String) async throws -> [GetLandMark] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        print(data)
        return try JSONDecoder().decode([GetLandMark].self, from: data)
    }
    
    func urlAction(url: String) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let res = try JSONDecoder().decode([String].self, from: data)
        
        return res[0]
    }
    
    
}
