//
//  LocationDetailViewController.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 4/26/22.
//

import UIKit
import CoreData

class LocationDetailViewController: UIViewController, NSFetchedResultsControllerDelegate {
// Outlets
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    Properties
    var networkWeatherClient = NetworkWeatherClient()
    var dataController : DataController!
    var myCities: MyCities!
    var fetchedResultsController : NSFetchedResultsController<MyCities>!
    
//    Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.style = .large
        self.activityIndicator.startAnimating()
        let city = myCities.cityName?.split(separator: " ").joined(separator: "%20")
        self.networkWeatherClient.fetchCurrentWeather(forRequestType: .cityName(city: city!))

        self.networkWeatherClient.onCompletion = {[weak self]currentWeather in
            print(currentWeather.cityName)
            guard let self = self else {return}
            self.updateInterfaceWith(weather: currentWeather)

        }
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    func updateInterfaceWith(weather : CurrentWeather){
        DispatchQueue.main.async {
            
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
            
        }
        
    }
    


}
