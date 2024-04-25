//
//  PlantDetailView.swift
//  Roots
//
//  Created by Brody Wilton on 13/03/2024.
//

import SwiftUI

struct PlantDetailView: View {
    @ObservedObject var plant: Plant
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showDatePickerSheet = false
    @State private var dateToUpdate: DateType?
    
    enum DateType {
        case lastWatered
        case lastFed
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // image
                Spacer()
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
                        Text("Watering Frequency")
                            .font(.headline)
                        Text(careInformation)
                    }
                    .padding(.bottom, 1)
                }
                
                //last watered
                HStack(/*alignment: .leading*/) {
                   Text("Last Watered")
                        .font(.headline)
                    if let lastWateredDate = plant.lastWateredDate {
                        Text(lastWateredDate, formatter: itemFormatter)
                    }
                    Button("Update", systemImage: "pencil.line") {
                        dateToUpdate = .lastWatered
                        showDatePickerSheet = true
                    }
                }
                .padding(.bottom, 1)
                
                //last fed
                HStack(/*alignment: .leading*/) {
                    Text("Last Fed")
                        .font(.headline)
                    if let lastFedDate = plant.lastFedDate {
                        Text(lastFedDate, formatter: itemFormatter)
                    }
                    Button("Update", systemImage: "pencil.line") {
                        dateToUpdate = .lastFed
                        showDatePickerSheet = true
                    }
                }
                
                //Times watered
                HStack {
                    Text("Times Watered:")
                        .font(.headline)
                    Text("\(plant.timesWatered)")
                }
                
                //Times fed
                HStack {
                    Text("Times Fed:")
                        .font(.headline)
                    Text("\(plant.timesFed)")
                }
            }
            .padding()
            .sheet(isPresented: $showDatePickerSheet) {
                if let dateType = dateToUpdate {
                    DatePickerView(plant: plant, dateType: dateType, context: viewContext)
                }
            }
            
        }
        .ignoresSafeArea(edges: .all)
        .navigationTitle(plant.nickname ?? "Plant Details")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background {
            Color.softLimeGreen.ignoresSafeArea()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
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
