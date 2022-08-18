//
//  ViewController.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 2/24/22.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
//    Outlets
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//    Properties
    var networkWeatherClient = NetworkWeatherClient()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    var menuOut = false
    
//    Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        hamburgerView.isHidden = true
        self.activityIndicator.style = .large
        self.activityIndicator.startAnimating()
                    self.networkWeatherClient.onCompletion = {[weak self]currentWeather in
                        print(currentWeather.cityName)
                        guard let self = self else {return}
                        self.updateInterfaceWith(weather: currentWeather)
                    
                    }
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestLocation()
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuOut = false
        hamburgerView.isHidden = true
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }

    @IBAction func menuButtonClicked(_ sender: Any) {
        hamburgerView.isHidden = false
        if menuOut == false{

            menuOut = true
        } else {

            menuOut = false
            hamburgerView.isHidden = true
        }



    }
    @IBAction func seacrhButtonTapped(_ sender: Any) {
        self.presentSearchAlertController(title: "Enter city name", message: nil, style: .alert){ [unowned self] city in
            self.networkWeatherClient.fetchCurrentWeather(forRequestType: .cityName(city: city))
            
        }
    
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
extension ViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherClient.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        alertForFail()
        print(error.localizedDescription)
    }
}
