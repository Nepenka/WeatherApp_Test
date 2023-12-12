//
//  OfferModel.swift
//  WeatherApp_Test
//
//  Created by 123 on 7.12.23.
//

import Foundation




class OfferModel: Codable {
    var cod: String?
    var message:Float?
    var cnt:Float
    var list:[ListOfferModel]?
    var weather: WeatherOfferModel?
}
