//
//  NetworkManager.swift
//  WeatherApp_Test
//
//  Created by 123 on 7.12.23.
//

import Foundation

class NetworkManager {
    private init() {}

    static let shared: NetworkManager = NetworkManager()

    func getWeather(city: String, result: @escaping ((OfferModel?, Error?) -> ())) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: "2fa1a055a4df50bdd446f4f21ea16142")
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"

        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in

            if let error = error {
                result(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "NetworkManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                result(nil, error)
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decoderOfferModel = try decoder.decode(OfferModel.self, from: data)
                    result(decoderOfferModel, nil)
                } catch {
                    result(nil, error)
                }
            } else {
                let error = NSError(domain: "NetworkManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                result(nil, error)
            }

        }.resume()
    }
}
