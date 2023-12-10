//
//  ShowInternetConnection.swift
//  WeatherApp_Test
//
//  Created by 123 on 10.12.23.
//

import Foundation
import UIKit


public func showNoInternetConnectionAlert(in viewController: UIViewController) {
    let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    viewController.present(alertController, animated: true, completion: nil)
}
