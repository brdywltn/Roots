//
//  AddPlantView.swift
//  Roots
//
//  Created by Brody Wilton on 13/03/2024.
//

import SwiftUI
import CoreML

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
    @State private var identifiedSpecies: String = "Unknown"
    @State private var showingGetCareInfoButton = false
    @State private var showingPredictSpecies = false
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Plant Details")) {
                    TextField("Nickname", text: $nickname)
                    TextField("Scientific Name", text: $scientificName)
                    TextField("Watering Information", text: $careInformation)
                    DatePicker("Last Watered", selection: $lastWateredDate, displayedComponents: .date)
                    DatePicker("Last Fed", selection: $lastFedDate, displayedComponents: .date)
                }
                Section {
                    Button("Add Image") {
                        showingImagePicker = true
                        showingPredictSpecies = true
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    if showingPredictSpecies {
                        Button("Predict Species") {
                            predictSpecies()
                        }
                    }
                    if showingGetCareInfoButton {
                        Button("Get Watering Information") {
                            let service = PlantcareInformationService()
                            service.getWateringScheduleInformation(forSpecies: identifiedSpecies) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let careInfo):
                                        self.careInformation = careInfo
                                        
                                        if careInfo == "Minimum" {
                                            self.careInformation = self.careInformation + " 💧"
                                        } else if careInfo == "Frequent" {
                                            self.careInformation = self.careInformation + " 💧💧💧"
                                        } else if careInfo == "Average" {
                                            self.careInformation = self.careInformation + "💧💧"
                                        } else if careInfo == "None" {
                                            self.careInformation = self.careInformation + ""
                                        }
                                    case .failure(let error):
                                        print("Failed to fetch care information: \(error)")
                                    }
                                }
                            }
                        }
                        if !careInformation.isEmpty {
                            Text("Care Information: \(careInformation)")
                        }
                    }
                    Text("Identified Species: \(identifiedSpecies)")
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
    
    private func predictSpecies() {
        guard let selectedImage = selectedImage else { return }
        guard let model = try? PlantIdentification(configuration: MLModelConfiguration()) else {
            print("Error loading model")
            return
        }
        let resizedImage = selectedImage.resize(to: CGSize(width:224, height:224))
        guard let buffer = resizedImage.pixelBuffer() else { return }
        
        do {
            let prediction = try model.prediction(conv2d_input:buffer)
            identifiedSpecies = prediction.classLabel
            scientificName = prediction.classLabel
            showingGetCareInfoButton = true
        } catch {
            print("Error during prediction: \(error)")
        }
    }
}

#Preview {
    AddPlantView()
}
