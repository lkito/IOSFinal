//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Lasha Kitiashvili on 2/17/22.
//

import UIKit

class WeatherDetailView: UIView {
    @IBOutlet var container: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        let bundle = Bundle(for: WeatherDetailView.self)
        bundle.loadNibNamed("WeatherDetailView", owner: self, options: nil)
        
        container.frame = bounds
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(container)
    }
    
    func fillData(iconName: String, detailValue: String) {
        self.imageView.image = UIImage(systemName: iconName)
        self.label.text = detailValue
    }
}
