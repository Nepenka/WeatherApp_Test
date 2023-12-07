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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 224/255, green: 255/255, blue: 255/255, alpha: 1)
        let navigationController = UINavigationController(rootViewController: self)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        setupNavigationBar()
        setupCollectionView()

        
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
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
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

        if let listOfferModel = offerModel?.list?[indexPath.item] {
            cell.configure(with: listOfferModel)
        }
        cell.contentView.backgroundColor = UIColor(red: 175/255, green: 238/255, blue: 238/255, alpha: 1)
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.cornerRadius = 8.0
        cell.contentView.layer.masksToBounds = true

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

class WeatherCollectionViewCell: UICollectionViewCell {

    var timeLabel: UILabel!
    var temperatureLabel: UILabel!
    var weatherIconImageView: UIImageView!

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

        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIconImageView)

       
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

            if let icon = listOfferModel.icon, let imageName = weatherIconMapping[icon] {
                weatherIconImageView.image = UIImage(named: imageName)
            } else {
                weatherIconImageView.image = nil
            }
        }
    
}
