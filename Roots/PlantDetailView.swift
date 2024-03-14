//
//  PlantDetailView.swift
//  Roots
//
//  Created by Brody Wilton on 13/03/2024.
//

import SwiftUI

struct PlantDetailView: View {
    var plant: Plant
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // image
                if let imagePath = plant.imagePath,
                   let uiImage = ImageStorage.loadImageFromDocumentDirectory(name: imagePath) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .cornerRadius(8)
                        .shadow(radius:5)
                } else {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(height:200)
                        .foregroundColor(.green)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius:5)
                }
                
                //scientific name
                Text(plant.scientificName ?? "Unknown Plant")
                    .font(.title)
                    .padding(.bottom, 1)
                
                //care info
                if let careInformation = plant.careInformation {
                    VStack(alignment: .leading) {
                        Text("Care Information")
                            .font(.headline)
                        Text(careInformation)
                    }
                    .padding(.bottom, 1)
                }
                
                //last watered
                if let lastWateredDate = plant.lastWateredDate {
                    VStack(alignment: .leading) {
                        Text("Last Watered")
                            .font(.headline)
                        Text(lastWateredDate, formatter: itemFormatter)
                    }
                    .padding(.bottom, 1)
                }
                
                //last fed
                if let lastFedDate = plant.lastFedDate {
                    VStack(alignment: .leading) {
                        Text("Last Fed")
                            .font(.headline)
                        Text(lastFedDate, formatter: itemFormatter)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(plant.nickname ?? "Plant Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlantDetailView(plant: Plant())
            .previewLayout(.sizeThatFits)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()
