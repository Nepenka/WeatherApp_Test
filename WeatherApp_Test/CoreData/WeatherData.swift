//
//  WeatherData.swift
//  WeatherApp_Test
//
//  Created by 123 on 9.12.23.
//

import UIKit
import CoreData


class WeatherDataManager {
    
    static let shared = WeatherDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherDataModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
        return container
    }()
    
    func saveWeatherData(temp: Float, dt_txt: String, weatherDescription: String) {
        let context = persistentContainer.viewContext
        let weatherEntity = WeatherEntity(context: context)
        
        weatherEntity.temp = temp
        weatherEntity.dt_txt = dt_txt
        weatherEntity.weatherDescription = weatherDescription
        
        do {
            try context.save()
        } catch {
            print("Error saving weather data to Core Data: \(error)")
        }
    }
    
    func fetchWeatherData() -> [WeatherEntity] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")

        do {
            let weatherData = try context.fetch(fetchRequest)
            return weatherData
        } catch {
            print("Ошибка при получении данных о погоде из Core Data: \(error)")
            return []
        }
    }

    func deleteOldWeatherData() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")

        do {
            let weatherData = try context.fetch(fetchRequest)
            for weatherEntity in weatherData {
                context.delete(weatherEntity)
            }

            try context.save()
        } catch {
            print("Ошибка при удалении старых данных о погоде из Core Data: \(error)")
        }
    }


}
