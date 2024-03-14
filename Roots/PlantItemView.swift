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
            VStack {
                if let imagePath = plant.imagePath, let uiImage = ImageStorage.loadImageFromDocumentDirectory(name: imagePath) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                }
                Text(plant.nickname ?? "Unknown")
            }
            .frame(width:100, height:100)
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

