//
//  ImageStorage.swift
//  Roots
//
//  Created by Brody Wilton on 13/03/2024.
//

import UIKit

struct ImageStorage {
    
    static func saveImageToDocumentDirectory(_ image: UIImage, plantId: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return nil }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(plantId).jpg"
        let fileURL = directory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving file: ", error.localizedDescription)
            return nil
        }
    }
    
    static func loadImageFromDocumentDirectory(name: String) -> UIImage? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(name)
        if let image = UIImage(contentsOfFile: fileURL.path) {
            return image
        }
        return nil
    }
}
