//
//  WeatherData.swift
//  WeatherApp_Test
//
//  Created by 123 on 9.12.23.
//

import UIKit
import CoreData

class WeatherDataManager {

    let modelName = "WeatherDataModel"

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
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

    func fetchWeatherData() -> [Weather] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Weather> = Weather.fetchRequest()

        do {
            let weatherData = try context.fetch(fetchRequest)
            return weatherData
        } catch {
            print("Error fetching weather data from Core Data: \(error)")
            return []
        }
    }

    func deleteOldWeatherData() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Weather> = Weather.fetchRequest()

        do {
            let weatherData = try context.fetch(fetchRequest)
            for weatherEntity in weatherData {
                context.delete(weatherEntity)
            }

            try context.save()
        } catch {
            print("Error deleting old weather data from Core Data: \(error)")
        }
    }
}
