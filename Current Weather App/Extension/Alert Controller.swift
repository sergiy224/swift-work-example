//
//  Alert Controller.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 2/24/22.
//

import UIKit
extension ViewController{
    
    
    func presentSearchAlertController(title : String?, message : String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void){
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["San Francisco", "Istambul", "Baku", "Barcelona", "Tokyo"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else {return}
            if cityName != "" {
//                self.networkWeatherClient.fetchCurrentWeather(forCity: cityName)
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
        }
    }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
}
    
    func alertForFail(){
        let alert = UIAlertController(title: "Error", message: "Something Went Wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

extension MyCitiesViewController{
    func alertForFail(){
        let alert = UIAlertController(title: "Error", message: "Something Went Wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

