//
//  ViewController.swift
//  WeatherApp_Test
//
//  Created by 123 on 7.12.23.
//

import UIKit
import SnapKit
import Reachability
import CoreLocation


class ViewController: UIViewController, UISearchResultsUpdating {
    
    var collectionView: UICollectionView!
    var timer = Timer()
    var offerModel: OfferModel?
    var tableView: UITableView = .init()
    var weatherOfferModel: WeatherOfferModel?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 224/255, green: 255/255, blue: 255/255, alpha: 1)
        let navigationController = UINavigationController(rootViewController: self)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        setupNavigationBar()
        setupCollectionView()
        setupTableView()
        setupLocationManager()
        
    }
    
    
    
    
    //MARK: - Location Manager
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    //MARK: - UICollectionView
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        settingCollectionView(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: WeatherCollectionViewCell.self))
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        
        collectionView.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(350)
            make.height.equalTo(150)
        }
    }
    
    //MARK: - UITableView
    
    func setupTableView() {
        view.addSubview(tableView)
        settingTableView(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(20)
        }
        
        
    }
    
    //MARK: - Navigation Bar
    fileprivate func setupNavigationBar() {
        self.navigationItem.title = "WeatherWise"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - Core Data (SaveData)
    func saveWeatherDataToCoreData() {
        guard let list = self.offerModel?.list else {
            return
        }
        
        let weatherDataManager = WeatherDataManager()
        
        for listOfferModel in list {
            if let temp = listOfferModel.main?.temp,
               let dt_txt = listOfferModel.dt_txt,
               let weatherDescription = listOfferModel.weather?.first?.description {
                weatherDataManager.saveWeatherData(temp: temp, dt_txt: dt_txt, weatherDescription: weatherDescription)
            }
        }
    }
    
    //MARK: - FetchWeatherData
    func fetchWeatherDataFromCoreData() {
        let weatherDataManager = WeatherDataManager()
        let _ = weatherDataManager.fetchWeatherData()
        
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
            guard let city = searchController.searchBar.text, !city.isEmpty else {
                return
            }

            timer.invalidate()

            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
                guard let self = self else { return }

                if isConnectedToNetwork() {
                    // Fetch weather data from the internet
                    NetworkManager.shared.getWeather(city: city) { (model, error) in
                        if let error = error {
                            print("Error fetching weather data: \(error)")
                            self.fetchWeatherDataFromCoreData()
                            return
                        }

                        guard let list = model?.list, !list.isEmpty else {
                            print("No weather data received")
                            self.fetchWeatherDataFromCoreData()
                            return
                        }

                        self.saveWeatherDataToCoreData()

                        DispatchQueue.main.async {
                            self.offerModel = model
                            self.weatherOfferModel = model?.list?.first?.weather?.first
                            self.collectionView.reloadData()
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    
                    self.fetchWeatherDataFromCoreData()
                }
            }
        }
    }

// MARK: - Reverse Geocoding

func getCountryInfo(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                print("Reverse geocoding error: \(error?.localizedDescription ?? "")")
                completion("N/A")
                return
            }

            if let country = placemark.country {
                completion(country)
            } else {
                completion("N/A")
            }
        }
}


//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        getWeatherForLocation(latitude: latitude, longitude: longitude) { [weak self] (model: OfferModel?, error: Error?) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching weather data: \(error)")
                return
            }
            
            

            self.saveWeatherDataToCoreData()

            DispatchQueue.main.async {
                self.offerModel = model
                self.weatherOfferModel = model?.list?.first?.weather?.first
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }
    }
    func getWeatherForLocation(latitude: Double, longitude: Double, completion: @escaping (OfferModel?, Error?) -> Void) {
        WeatherForLocation.shared.weatherResult = completion
        WeatherForLocation.shared.getWeatherForLocation(latitude: latitude, longitude: longitude)
    }

}



//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.offerModel?.list?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WeatherCollectionViewCell.self), for: indexPath) as? WeatherCollectionViewCell else {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
      }

        if let listOfferModel = offerModel?.list?[indexPath.item] {
            cell.configure(with: listOfferModel)
        }

        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 10
            let cellHeight = collectionView.bounds.height - 10
            return CGSize(width: cellWidth, height: cellHeight)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offerModel?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    
            if let listOfferModel = offerModel?.list?[indexPath.row] {
                cell.configure(with: listOfferModel)
            }

            return cell
    }
    
    
}
 
