//
//  ViewController.swift
//  WeatherApp_Test
//
//  Created by 123 on 7.12.23.
//

import UIKit
import SnapKit



class ViewController: UIViewController, UISearchResultsUpdating {
    
    var collectionView: UICollectionView!
    var timer = Timer()
    var offerModel: OfferModel?
    var tableView: UITableView = .init()
    var weatherOfferModel: WeatherOfferModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 224/255, green: 255/255, blue: 255/255, alpha: 1)
        let navigationController = UINavigationController(rootViewController: self)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        setupNavigationBar()
        setupCollectionView()
        setupTableView()
        
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.cornerRadius = 10.0
        collectionView.layer.borderWidth = 2.0
        collectionView.layer.masksToBounds = true
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(350)
            make.height.equalTo(150)
        }
    }
    
//MARK - UITableView
    
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
    
    
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let city = searchController.searchBar.text, !city.isEmpty else {
            return
        }

        timer.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            NetworkManager.shared.getWeather(city: city) { (model, error) in
                if let error = error {
                    print("Error fetching weather data: \(error)")
                    return
                }

                guard let list = model?.list, !list.isEmpty else {
                    print("No weather data received")
                    return
                }

                self?.offerModel = model
                self?.weatherOfferModel = model?.list?.first?.weather?.first 
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.offerModel?.list?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherCollectionViewCell

        if let listOfferModel = offerModel?.list?[indexPath.item], let weatherOfferModel = weatherOfferModel {
            cell.configure(with: listOfferModel)
        }
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.masksToBounds = true

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
        return self.offerModel?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

                if let weeklyList = offerModel?.list?[indexPath.row] {
                    cell.configure(with: weeklyList)
                }

                return cell
    }
    
    
}

//MARK: - UICollectionViewCell

class WeatherCollectionViewCell: UICollectionViewCell {
    
    var timeLabel: UILabel!
    var temperatureLabel: UILabel!
    var weatherIconImageView: UIImageView!
    var descriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        timeLabel = UILabel()
        temperatureLabel = UILabel()
        weatherIconImageView = UIImageView()
        descriptionLabel = UILabel()
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(descriptionLabel)
        
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }

        weatherIconImageView.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            make.centerX.equalTo(contentView.snp.centerX)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(8)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
    
    func configure(with listOfferModel: ListOfferModel) {
            if let time = listOfferModel.dt_txt {
                timeLabel.text = time
            } else {
                timeLabel.text = "N/A"
            }

            if let temperature = listOfferModel.main?.temp {
                temperatureLabel.text = "\(temperature) °F"
            } else {
                temperatureLabel.text = "N/A"
            }

            if let weather = listOfferModel.weather?.first {
                if let icon = weather.icon, let imageName = weatherIconMapping[icon] {
                    weatherIconImageView.image = UIImage(named: imageName)
                } else {
                    weatherIconImageView.image = nil
                }

                if let description = weather.description {
                    descriptionLabel.text = description
                } else {
                    descriptionLabel.text = "N/A"
                }
            } else {
                
                weatherIconImageView.image = nil
                descriptionLabel.text = "N/A"
            }
        }
}
    
    //MARK: - TableViewCell
    class TableViewCell: UITableViewCell {
        func configure(with weeklyList: ListOfferModel) {
            
            
            
            
        }
        
    }

