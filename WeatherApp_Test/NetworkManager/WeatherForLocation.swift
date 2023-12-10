//
//  WeatherForLocation.swift
//  WeatherApp_Test
//
//  Created by 123 on 10.12.23.
//

import Foundation
import CoreLocation

class WeatherForLocation: NSObject {
    private override init() {}

    static let shared: WeatherForLocation = WeatherForLocation()

    typealias WeatherResult = ((OfferModel?, Error?) -> ())

    var weatherResult: WeatherResult?

    func getWeatherForCurrentLocation(result: @escaping WeatherResult) {
        weatherResult = result

        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension WeatherForLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        getWeatherForLocation(latitude: latitude, longitude: longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        weatherResult?(nil, error)
    }
}

extension WeatherForLocation {
    func getWeatherForLocation(latitude: Double, longitude: Double) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: "2fa1a055a4df50bdd446f4f21ea16142")
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"

        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.weatherResult?(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "WeatherForLocation", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                self.weatherResult?(nil, error)
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decoderOfferModel = try decoder.decode(OfferModel.self, from: data)
                    self.weatherResult?(decoderOfferModel, nil)
                } catch {
                    self.weatherResult?(nil, error)
                }
            } else {
                let error = NSError(domain: "WeatherForLocation", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                self.weatherResult?(nil, error)
            }
        }.resume()
    }
}
