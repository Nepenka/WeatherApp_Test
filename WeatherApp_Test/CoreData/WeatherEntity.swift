//
//  WeatherEntity.swift
//  WeatherApp_Test
//
//  Created by 123 on 9.12.23.
//


import UIKit
import CoreData

class WeatherEntity: NSManagedObject, Encodable {
    @NSManaged var id: UUID
    @NSManaged var temp: Float
    @NSManaged var dt_txt: String
    @NSManaged var weatherDescription: String
}
