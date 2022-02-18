//
//  WeatherDetailsView.swift
//  WeatherApp
//
//  Created by Lasha Kitiashvili on 2/17/22.
//

import UIKit

class WeatherDetailsView: UIView {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    func initialize() {
        let bundle = Bundle(for: WeatherDetailsView.self)
        bundle.loadNibNamed("WeatherDetailsView", owner: self, options: nil)
        
        container.frame = bounds
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(container)
    }

    func fillData(iconName: String, detailValue: String) {
        self.detailImageView.image = UIImage(named: iconName)
        self.detailImageView.tintColor = UIColor.systemYellow
        self.detailLabel.text = detailValue
    }
}
