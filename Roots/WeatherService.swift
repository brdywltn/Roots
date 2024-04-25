//
//  WeatherService.swift
//  Roots
//
//  Created by Brody Wilton on 15/03/2024.
//

import Foundation
import CoreLocation

class WeatherService {
    let apiKey = "7102be27887a4b94d0bf2328856b5d57"
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<WeatherInfo, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                print(weatherResponse)
                let temperature = weatherResponse.main.temp
                let sunrise = weatherResponse.sys.sunrise
                let sunset = weatherResponse.sys.sunset
                let cloudiness = weatherResponse.clouds.all
                
                let sunlightLevel = self.calculateSunlightLevel(sunrise: sunrise, sunset: sunset, cloudiness: cloudiness)
                
                
                let weatherInfo = WeatherInfo(temperature: temperature, sunlightLevel: sunlightLevel)
                completion(.success(weatherInfo))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func calculateSunlightLevel(sunrise: Int, sunset: Int, cloudiness: Int) -> String {
        let dayLengthInSeconds = sunset - sunrise
        let dayLengthInHours = Double(dayLengthInSeconds) / 3600.0
        let adjustedDayLength = dayLengthInHours * (1 - Double(cloudiness) / 100.0)
        
        switch adjustedDayLength {
        case 0..<4:
            return "🌑" //very low sunlight
        case 4..<8:
            return "🌒" //low sunlight
        case 8..<12:
            return "🌓" //moderate sunlight
        default:
            return "🌔" //high sunlight
        }
    }
}

struct WeatherInfo {
    let temperature: Double
    let sunlightLevel: String
}

struct WeatherResponse: Decodable {
    let main: WeatherMain
    let sys: WeatherSys
    let clouds: Clouds
}

struct WeatherMain: Decodable {
    let temp: Double
}

struct WeatherSys: Decodable {
    let sunrise: Int
    let sunset: Int
}

struct Clouds: Decodable {
    let all: Int
}
