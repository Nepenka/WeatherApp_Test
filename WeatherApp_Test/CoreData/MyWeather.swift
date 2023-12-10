//
//  WeatherEntity.swift
//  WeatherApp_Test
//
//  Created by 123 on 9.12.23.
//


import UIKit
import CoreData

class MyWeather: NSManagedObject, Encodable {
    @NSManaged var temp: Float
    @NSManaged var dt_txt: String
    @NSManaged var weatherDescription: String
}
