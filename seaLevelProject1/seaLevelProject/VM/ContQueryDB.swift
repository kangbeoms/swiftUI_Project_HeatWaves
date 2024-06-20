//
//  ContQueryDB.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/17/24.
//

import Foundation

struct ContQueryDB {
    func loadJsonData(url: String) async throws -> [String] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        return try JSONDecoder().decode([String].self, from: data)
    }
     
    
}
