//
//  HomePageView.swift
//  Roots
//
//  Created by Brody Wilton on 13/03/2024.
//

import SwiftUI
import CoreData
import Contacts

struct HomePageView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var randomPlantImage: UIImage? = nil
    @State private var greeting = "Hello, User!"
    
    var body: some View {
        VStack {
            Text(greeting)
                .font(.title)
                .padding(.top)
                .padding(.top)
                .padding(.top)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.richGrey)
            
            Spacer()
            
            if let image = randomPlantImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:300, height: 300)
                    .cornerRadius(10)
            } else {
                Text("Add some plants to see them here!")
                    .foregroundColor(Color.richGrey)
            }
            
            Spacer()
            
            WeatherWidgetView()
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .onAppear {
            loadRandomPlantImage()
            fetchUserName()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background {
            Color.softLimeGreen.ignoresSafeArea()
        }
    }
    
    private func loadRandomPlantImage() {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        do {
            let plants = try managedObjectContext.fetch(fetchRequest)
            if let randomPlant = plants.randomElement(), let imagePath = randomPlant.imagePath, let image = ImageStorage.loadImageFromDocumentDirectory(name: imagePath) {
                randomPlantImage = image
            }
        } catch {
            print("Error fetching plants: \(error)")
        }
    }
    
    private func fetchUserName() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if let error = error {
                print("Failed to request access: \(error)")
                DispatchQueue.main.async {
                    self.greeting = "Hello!"
                }
                return
            }
            
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request) {( contact, stop) in
                        DispatchQueue.main.async {
                            self.greeting = "Hello, \(contact.givenName)"
                        }
                        stop.pointee = true
                    }
                } catch {
                    print("Failed to fetch contact: \(error)")
                }
            } else {
                print("Access denied")
                DispatchQueue.main.async {
                    self.greeting = "Hello!"
                }
            }
        }
    }
}

#Preview {
    HomePageView()
}
