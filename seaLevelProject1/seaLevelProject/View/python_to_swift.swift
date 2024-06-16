//
//  python_to_swift.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/13/24.
//

//import SwiftUI
//
//struct python_to_swift: View {
//    
//    @State var selectLandMark: [GetLandMark] = []
//    
//    var body: some View {
//        Detail()
//            .onAppear(perform: {
//                let json = GetLandMarkJSON()
//                Task {
//                    selectLandMark = try await json.loadJsonData(url:"http://127.0.0.1:5000/goSwiftfile?name=63빌딩")
////                    for item in selectLandMark {
////                        print("건물이름 : \(item.name) \nlat :\(item.lat)\nlng:\(item.lng)")
//                        print("건물이름 : \($selectLandMark.result)")
////                    }
////                    print(json)
//                }
//            })
//        
//
//    }
//
//}
//
//#Preview {
//    python_to_swift()
//}
