//
//  MainOfferModel.swift
//  WeatherApp_Test
//
//  Created by 123 on 7.12.23.
//

import Foundation


class MainOfferModel: Codable {
    var temp_min: Float?
    var temp_max: Float?
    var temp: Float?
    init(temp_min: Float? = nil, temp_max: Float? = nil, temp: Float? = nil) {
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.temp = temp
    }
}
