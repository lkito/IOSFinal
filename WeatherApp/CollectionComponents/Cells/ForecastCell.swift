//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Lasha Kitiashvili on 2/19/22.
//

import UIKit


struct ForecastCellModel {
    var weatherImage: UIImage
    var timeOfDayText: String
    var weatherStatusText: String
    var temperatureText: String
}

class ForecastCell: UITableViewCell {
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var timeOfDayLabel: UILabel!
    @IBOutlet var weatherStatusLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(with model: ForecastCellModel){
        weatherImage.image = model.weatherImage
        timeOfDayLabel.text = model.timeOfDayText
        weatherStatusLabel.text = model.weatherStatusText
        temperatureLabel.text = model.temperatureText + "°C"
    }
}
