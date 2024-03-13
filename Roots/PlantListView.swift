//
//  PlantListView.swift
//  Roots
//
//  Created by Brody Wilton on 13/03/2024.
//

import SwiftUI

struct PlantListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plant.nickname, ascending: true)],
        animation: .default)
    private var plants: FetchedResults<Plant>
    
    @State private var showingAddPlantView = false
    
    var body: some View {
        NavigationView {
            ScrollView  {
                LazyVGrid(columns:[GridItem(.flexible()), GridItem(.flexible())], spacing:20) {
                    ForEach(plants, id:\.self) { plant in
                        NavigationLink(destination: PlantDetailView(plant:plant)) {
                            Image(plant.image ?? "placeholder_image")
                                .resizable()
                                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                .frame(width:100, height:100)
                                .clipped()
                                .cornerRadius(8)
                            Text(plant.nickname ?? "Unknown")
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Plants")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {showingAddPlantView = true}) {
                        Label("Add Plant", systemImage: "plus")
                    }
                    .sheet(isPresented: $showingAddPlantView) {
                        AddPlantView().environment(\.managedObjectContext, self.viewContext)
                    }
                }
            }
        }
    }
}

struct PlantDetailView: View {
    var plant: Plant
    
    var body: some View {
        Text(plant.nickname ?? "Unknown plant")
    }
}

#Preview {
    PlantListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
