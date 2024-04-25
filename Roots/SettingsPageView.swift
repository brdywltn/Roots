//
//  SettingsPageView.swift
//  Roots
//
//  Created by Brody Wilton on 13/03/2024.
//

import SwiftUI

struct SettingsPageView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding(.top)
                .padding(.top)
                .padding(.top)
                .foregroundColor(Color.richGrey)
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background {
            Color.softLimeGreen.ignoresSafeArea()
        }
    }
}

#Preview {
    SettingsPageView()
}
