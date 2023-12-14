//
//  LanguageManager.swift
//  WeatherApp_Test
//
//  Created by 123 on 14.12.23.
//

import Foundation


class LanguageManager {
    static let shared = LanguageManager()

    func setAppLanguage(_ languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}

