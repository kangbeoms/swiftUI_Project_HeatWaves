import SwiftUI

struct GetpythonData: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var name: String = ""
    
    var body: some View {
        VStack {

            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                if let landname = viewModel.landname,
                   let latitude = viewModel.latitude,
                   let longitude = viewModel.longitude,
                   let level = viewModel.level,
                   let height = viewModel.height {
                    
                    VStack(alignment: .leading) {
                        Text("Land Name: \(landname)")
                        Text("Latitude: \(latitude)")
                        Text("Longitude: \(longitude)")
                        Text("해수면: \(level)")
                        Text("높이: \(height)")
                    }
                    
                } else {
                    Text("No data available")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Map Points")
    }
}

#Preview {
    GetpythonData()
}
