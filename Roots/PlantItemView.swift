//
//  PlantItemView.swift
//  Roots
//
//  Created by Brody Wilton on 13/03/2024.
//

import SwiftUI

struct PlantItemView: View {
    let plant: Plant
    @Binding var showDelete: Bool
    let deleteAction: () -> Void


    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing:0) {
                if let imagePath = plant.imagePath, let uiImage = ImageStorage.loadImageFromDocumentDirectory(name: imagePath) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width:150, height:150)
                        .cornerRadius(8)
                        .shadow(radius:5)
                } else {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width:100, height:100)
                }
                Text(plant.nickname ?? "Unknown")
                    .padding(.top)
            }
            
            .cornerRadius(8)
            
            if showDelete {
                Button(action: deleteAction) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                }
                .offset(x:-10, y:10)
            }
        }
    }
}



//struct PlantItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantItemView(plant: Plant()
//            .previewLayout(.sizeThatFits)
//    }
//}

