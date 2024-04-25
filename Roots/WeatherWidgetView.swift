//
//  WeatherWidgetView.swift
//  Roots
//
//  Created by Brody Wilton on 15/03/2024.
//

import SwiftUI
import CoreLocation

struct WeatherWidgetView: View {
    @State private var temperature: Double?
    @State private var sunlightLevel: String = ""
    @State private var locationName: String = "Loading..."
    
    private let weatherService = WeatherService()
    private let locationManager = CLLocationManager()
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(locationName)
                .font(.headline)
                .foregroundColor(.richGrey)
            if let temperature = temperature {
                Text("Temp: \(temperature, specifier: "%.1f")°C")
                    .font(.headline)
                    .foregroundColor(Color.richGrey)
                Text("Current sunlight: \(sunlightLevel)")
                    .foregroundColor(Color.richGrey)
            } else {
                Text("Fetching temperature...")
                    .font(.subheadline)
                    .foregroundColor(Color.richGrey)
            }
        }
        .padding()
        .onAppear() {
            fetchWeather()
        }
    }
    
    private func fetchWeather() {
        locationManager.requestWhenInUseAuthorization()
        guard let location = locationManager.location else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        weatherService.fetchWeather(latitude: latitude, longitude: longitude) { result in
            DispatchQueue.main.async {
                switch result  {
                case .success(let weatherInfo):
                    self.temperature = weatherInfo.temperature
                    self.sunlightLevel = weatherInfo.sunlightLevel
                    self.locationName = "Current Location"
                case .failure(let error):
                    print(error.localizedDescription)
                    self.locationName = "Error fetching weather"
                }
            }
        }
    }
}

#Preview {
    WeatherWidgetView()
}
