//
//  CityModel.swift
//  WeatherApp_Test
//
//  Created by 123 on 7.12.23.
//

import Foundation


class CityModel: Codable {
    var id: Float
    var name: String
    var county: String?
    var population: Float?
}
