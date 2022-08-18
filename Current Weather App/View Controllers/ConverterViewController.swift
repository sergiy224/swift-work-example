//
//  ConverterViewController.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 2/25/22.
//

import UIKit

class ConverterViewController: UIViewController {
    
//    Oulets
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var fahrenheitLabel: UILabel!
    @IBOutlet weak var slider: UISlider!{
       
    didSet{
        
        slider.maximumValue = 100
        slider.minimumValue = -100
        slider.value = 0
        
    }
    }
//    Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Retrieve the slider location
        slider.value = UserDefaults.standard.float(forKey: "Slider value key")
        
        celsiusLabel.text = UserDefaults.standard.string(forKey: "Celsius Value Changed")
        fahrenheitLabel.text = UserDefaults.standard.string(forKey:  "Fahrenheit Value Changed")
        pictureChanged()
        
    }
    
    
    
    fileprivate func pictureChanged() {
        if slider.value > 0 {
            ImageView.image = UIImage(named: "Image-1")
        } else if slider.value <= 0 {
            ImageView.image = UIImage(named: "image-3")
        } else {
            print("Something went wrong ")
        }
       
    }
    
    
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let temperatureCelsius = Int(round(sender.value))
        celsiusLabel.text = "\(temperatureCelsius)ºC"
        let fahrenheitTemperature = Int(round((sender.value * 9/5) + 32))
        fahrenheitLabel.text = "\(fahrenheitTemperature)ºF"
        // Save the slider location
            UserDefaults.standard.set(slider.value, forKey: "Slider value key")
        UserDefaults.standard.set("\(temperatureCelsius)ºC", forKey: "Celsius Value Changed")
        UserDefaults.standard.set("\(fahrenheitTemperature)ºF", forKey: "Fahrenheit Value Changed")
        
      pictureChanged()
      
        
    }
}
