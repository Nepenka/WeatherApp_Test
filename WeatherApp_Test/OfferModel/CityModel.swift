//
//  CityModel.swift
//  WeatherApp_Test
//
//  Created by 123 on 7.12.23.
//

import Foundation


class CityModel: Codable {
    var id: Int
    var name: String
    var country: String
    var population: Int
    var timezone: Int
    var sunrise: Int
    var sunset: Int
}
