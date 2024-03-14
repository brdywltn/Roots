//
//  AddPlantView.swift
//  Roots
//
//  Created by Brody Wilton on 13/03/2024.
//

import SwiftUI

struct AddPlantView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    // Store plant details
    @State private var nickname: String = ""
    @State private var scientificName: String = ""
    @State private var careInformation: String = ""
    @State private var lastWateredDate: Date = Date()
    @State private var lastFedDate: Date = Date()
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Plant Details")) {
                    TextField("Nickname", text: $nickname)
                    TextField("Scientific Name", text: $scientificName)
                    TextField("Care Information", text: $careInformation)
                    DatePicker("Last Watered", selection: $lastWateredDate, displayedComponents: .date)
                    DatePicker("Last Fed", selection: $lastFedDate, displayedComponents: .date)
                }
                Section {
                    Button("Add Image") {
                        showingImagePicker = true
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    Button("Add Plant") {
                        addNewPlant()
                    }
                }
            }
            .navigationBarTitle("Add New Plant", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func addNewPlant() {
        withAnimation {
            let newPlant = Plant(context: viewContext)
            newPlant.id = UUID()
            newPlant.nickname = nickname
            newPlant.scientificName = scientificName
            newPlant.careInformation = careInformation
            newPlant.lastWateredDate = lastWateredDate
            newPlant.lastFedDate = lastFedDate
            
            //image path
            if let selectedImage = selectedImage {
                if let imagePath = ImageStorage.saveImageToDocumentDirectory(selectedImage, plantId: UUID().uuidString) {
                    newPlant.imagePath = imagePath
                }
            }
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print(error.localizedDescription)
                //TODO: handle error properly
            }
        }
    }
}

#Preview {
    AddPlantView()
}
