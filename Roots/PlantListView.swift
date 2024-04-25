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
                HStack {
                    Text("Your Plants")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.richGrey)
                        .padding()
                }
                LazyVGrid(columns:[GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(plants, id:\.self) { plant in
                        NavigationLink(destination: PlantDetailView(plant: plant)){
                            PlantItemView(plant:plant, showDelete: $showingDelete) {
                                deletePlant(plant)
                            }
                        }
                        .foregroundColor(Color.richGrey)
                    }
                }
            }
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .background {
                Color.softLimeGreen.ignoresSafeArea()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
            
                    Button(action: {showingAddPlantView = true}) {
                        Label("Add Plant", systemImage: "plus")
                            .foregroundColor(Color.richGrey)
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
    //save an image
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    //view controller for picking an image
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    //required function
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    //create a coordinator to manage communication between SwiftUI and the image picker
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //control the communication between swiftUI and image picker
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        //bind to swiftUI
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        //handle image selection
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
            //extract the image and bind it to the contextual variable to save in coredata later
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            //dismiss the picker
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    PlantListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


