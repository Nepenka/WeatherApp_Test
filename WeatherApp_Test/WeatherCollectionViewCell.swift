//
//  WeatherCollectionViewCell.swift
//  WeatherApp_Test
//
//  Created by 123 on 14.12.23.
//

import UIKit
import SnapKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    var timeLabel = UILabel()
    var temperatureLabel = UILabel()
  var weatherIconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
    var descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

  override func prepareForReuse() {
    super.prepareForReuse()

    timeLabel.text = nil
    temperatureLabel.text = nil
    descriptionLabel.text = nil
    weatherIconImageView.image = nil
  }

    private func setupSubviews() {
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
          make.size.equalTo(25)
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

        if let temperatureKelvin = listOfferModel.main?.temp {
                let temperatureCelsius = temperatureKelvin - 273.15
                let formattedTemperature = String(format: "%.1f", temperatureCelsius)
                temperatureLabel.text = "\(formattedTemperature) °C"
            } else {
                temperatureLabel.text = "N/A"
            }

        if let weather = listOfferModel.weather?.first {
            if let icon = weather.icon, let imageName = weatherIconMapping[icon] {

                if let image = UIImage(named: imageName) {
                    weatherIconImageView.image = image
                } else {
                    weatherIconImageView.image = UIImage(named: "DefaultWeatherImage")
                }
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
    
    
