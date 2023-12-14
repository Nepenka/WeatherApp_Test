//
//  TableViewCell.swift
//  WeatherApp_Test
//
//  Created by 123 on 14.12.23.
//

import Foundation
import UIKit


class TableViewCell: UITableViewCell {
    func configure(with listOfferModel: ListOfferModel) {
        let windSpeedText = "Wind Speed: \(listOfferModel.wind?.speed ?? 0)"
        let kelvinTemperature = listOfferModel.main?.temp ?? 0
        let celsiusTemperature = kelvinTemperature - 273.15
        let formattedTemperature = String(format: "%.1f", celsiusTemperature)
        let degreeText = "Temp: \(formattedTemperature)°C"
        let gustText = "Gust: \(listOfferModel.wind?.gust ?? 0)"

        textLabel?.text = "\(windSpeedText), \(degreeText), \(gustText)"
    }
}
