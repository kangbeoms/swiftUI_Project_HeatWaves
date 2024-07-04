//
//  queryModel.swift
//  test_main
//
//  Created by BEOM SHIEK KANG on 6/16/24.
//

import Foundation

struct QueryModel {
    func loadData(url: URL) async throws -> [Savedata]{
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Savedata].self, from: data)
    }
    
    func loadData2(url: URL) async throws -> [Vidiodata]{
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Vidiodata].self, from: data)
    }
    
    func loadData3(url: URL) async throws -> [DataFrame]{
        let (data, _) = try await URLSession.shared.data(from: url)
      
        return try JSONDecoder().decode([DataFrame].self, from: data)
    }
    
    func loadData4(url: URL) async throws -> [GetData]{
        let (data, _) = try await URLSession.shared.data(from: url)
      
        return try JSONDecoder().decode([GetData].self, from: data)
    }
}

