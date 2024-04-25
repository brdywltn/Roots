//
//  PlantcareInformationService.swift
//  Roots
//
//  Created by Brody Wilton on 09/04/2024.
//

import Foundation

class PlantcareInformationService {
    //private let api_key = "sk-TCS06609afc5e551f4947"

    private let api_key = "sk-NNag66181fad43341365"
    
    func getWateringScheduleInformation(forSpecies species: String, completion: @escaping (Result<String, Error>) -> Void) {
        let formattedSpecies = species.replacingOccurrences(of: "-", with: "%20")
        let urlString = "https://perenual.com/api/species-list?key=\(api_key)&q=\(formattedSpecies)"
        
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.cannotDecodeRawData)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PerenualResponse.self, from: data)
                if let firstResult = response.data.first {
                    let wateringInfo = firstResult.watering
                    completion(.success(wateringInfo))
                } else {
                    completion(.failure(URLError(.zeroByteResource)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct PerenualResponse: Decodable {
    let data: [PlantData]
}

struct PlantData: Decodable {
    let watering: String
}

