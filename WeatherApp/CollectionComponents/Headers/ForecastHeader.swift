//
//  ForecastHeader.swift
//  WeatherApp
//
//  Created by Lasha Kitiashvili on 2/19/22.
//

import UIKit

class ForecastHeader: UITableViewHeaderFooterView {
    @IBOutlet var dateLabel: UILabel!
    
    func configure(dateText: String) {
        dateLabel.text = dateText.uppercased()
    }
}
