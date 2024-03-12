//
//  SplashView.swift
//  Roots
//
//  Created by Brody Wilton on 12/03/2024.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .frame(width:150, height: 150)
                .foregroundColor(.green)
            Text("Roots")
                .font(.largeTitle)
                .foregroundColor(.green)
        }
        .padding()
    }
}

#Preview {
    SplashView()
}

//struct SplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashView()
//    }
//}
