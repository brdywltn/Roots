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
    @State private var showingDelete = false
 
    
    var body: some View {
        NavigationView {
            ScrollView  {
                LazyVGrid(columns:[GridItem(.flexible()), GridItem(.flexible())], spacing:20) {
                    ForEach(plants, id:\.self) { plant in
                        NavigationLink(destination: PlantDetailView(plant: plant)){
                            PlantItemView(plant:plant, showDelete: $showingDelete) {
                                deletePlant(plant)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Your Plants")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
            
                    Button(action: {showingAddPlantView = true}) {
                        Label("Add Plant", systemImage: "plus")
                    }
                    Button(action: {showingDelete.toggle() }) {
                        Image(systemName: showingDelete ? "xmark.circle" : "minus.circle")
                    }
                    .sheet(isPresented: $showingAddPlantView) {
                        AddPlantView().environment(\.managedObjectContext, self.viewContext)
                    }
                }
            }
        }
    }
    
    private func deletePlant(_ plant: Plant) {
        viewContext.delete(plant)
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    PlantListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


