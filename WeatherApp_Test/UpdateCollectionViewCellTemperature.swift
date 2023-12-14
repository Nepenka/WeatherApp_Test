//
//  UpdateCellTemperature.swift
//  WeatherApp_Test
//
//  Created by 123 on 14.12.23.
//

import Foundation
import UIKit


 func updateCellTemperature(_ cell: UICollectionViewCell, with listOfferModel: ListOfferModel) {
    guard let temperatureLabel = (cell as? WeatherCollectionViewCell)?.temperatureLabel else {
        return
    }

    if let temperatureKelvin = listOfferModel.main?.temp {
        var temperatureValue: Double
        let temperatureUnitIndex = UserDefaults.standard.integer(forKey: "temperatureUnitIndex")
        let temperatureUnitString: String

        if temperatureUnitIndex == 0 {
            temperatureValue = Double(temperatureKelvin - 273.15)
            temperatureUnitString = "°C"
        } else {
            temperatureValue = Double((temperatureKelvin - 273.15) * 9/5 + 32)
            temperatureUnitString = "°F"
        }

        let formattedTemperature = String(format: "%.1f", temperatureValue)
        temperatureLabel.text = "\(formattedTemperature) \(temperatureUnitString)"
    } else {
        temperatureLabel.text = "N/A"
    }
}

