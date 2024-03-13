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
                            VStack {
                                Group {
                                    if let imagePath = plant.imagePath, let uiImage = ImageStorage.loadImageFromDocumentDirectory(name: imagePath) {
                                        Image(uiImage: uiImage)
                                            .resizable()
    //                                    .resizable()
    //                                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
    //                                    .frame(width:100, height:100)
    //                                    .clipped()
    //                                    .cornerRadius(8)
    //                                    .clipShape(RoundedRectangle(cornerRadius: 8))
    //                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth:2))
                                    } else {
                                        Image(systemName: "leaf.fill")
                                            .resizable()
                                            .scaledToFit()
    //                                    .resizable()
    //                                    .scaledToFit()
    //                                    .frame(width:100, height:100)
    //                                    .padding()
    //                                    .background(Color.white)
    //                                    .clipShape(RoundedRectangle(cornerRadius: 8))
    //                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth:2))
                                    }
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width:100, height:100)
                                .clipped()
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius:8).stroke(Color.green, lineWidth:2))
                                .background(Color.white)
                                    
                                Text(plant.nickname ?? "Unknown")
                                    .font(.caption)
                                    .frame(width: 100)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Your Plants")
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
