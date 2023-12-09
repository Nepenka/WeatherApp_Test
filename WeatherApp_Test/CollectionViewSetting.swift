//
//  CollectionViewSetting.swift
//  WeatherApp_Test
//
//  Created by 123 on 9.12.23.
//

import Foundation
import UIKit



public func settingCollectionView(_ collectionView: UICollectionView) {
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = true
    collectionView.layer.borderColor = UIColor.black.cgColor
    collectionView.layer.cornerRadius = 10.0
    collectionView.layer.borderWidth = 2.0
    collectionView.layer.masksToBounds = true
}
