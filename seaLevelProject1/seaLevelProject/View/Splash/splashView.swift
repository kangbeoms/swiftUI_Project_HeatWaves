//
//  splashView.swift
//  test_main
//
//  Created by BEOM SHIEK KANG on 6/17/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
//            Color.blue
//                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Save US!")
                    .font(.title)
                    .padding()
                
                WebImage(url: URL(string: "https://s3-alpha-sig.figma.com/img/daee/2a17/597c56772824fe32a993512a1004a8cc?Expires=1719187200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=ecEeTT-1W2Uo70nVmb0tF0yjCkBCnTO9ztkn7XLefwzdK5s8Op8xDZ2moNq9i~Sj5xv2C6zxjxLjPJbqxy7BLY3bW6eEkhGm2G7uM1Ws-3iTD2JuQiuAzXVaC5-cHBxX0tCekHnYWMGupy4xmiGsGt7QSCKucVbs68cM3aD3~FrSa91rFphJrOsZbFe5uBkPj9N7DX3SWu1kkYE~ewp5zG1ZmBKMH1WpDqUD9KL9jdlxGDLaKm8wA~SIagc5~udZRCIWRpQACDbLvvCrzePRxu2YJMfU7PfQ4rrz5r23U9HmDYgqVVq9OKr~F3Mlmw3ViejjGnyFNoAY9L7vgXJBTQ__"))
                    .font(.system(size: 200))
                    .foregroundColor(.white)
            }
        }
    }
}
