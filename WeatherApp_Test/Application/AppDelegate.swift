//
//  AppDelegate.swift
//  WeatherApp_Test
//
//  Created by 123 on 7.12.23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    

    func setAppLanguage(_ languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }

    func currentAppLanguage() -> String? {
        return UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let savedLanguage = currentAppLanguage() {
            LanguageManager.shared.setAppLanguage(savedLanguage)
        } else {
            LanguageManager.shared.setAppLanguage(NSLocale.current.languageCode ?? "en")
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }


}

