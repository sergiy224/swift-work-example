//
//  NetworkWeatherClient.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 2/28/22.
//

import Foundation
import CoreLocation

class NetworkWeatherClient {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion : ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=imperial"
            
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apikey=\(apiKey)&units=imperial"
        }
        performFetch(withURLString: urlString)
    }
  

   fileprivate func performFetch(withURLString urlString : String){
        guard let url = URL(string: urlString) else {return}
    let session = URLSession(configuration: .default)
    let task =  session.dataTask(with: url) { data, response, error in
        if let data = data {

            if let currentWeather = self.parseJSON(withData : data){

                 self.onCompletion?(currentWeather)
                print("currentWeather: \(currentWeather)")
            }
        }
    }
    task.resume()
    }
    
   fileprivate func parseJSON(withData data : Data) -> CurrentWeather?{
        let decoder = JSONDecoder()
        do{
           let currentWeatherData = try decoder.decode(CurrentWeatherResponses.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherResponses: currentWeatherData) else {
                return nil }
            return currentWeather
//            print(currentWeatherData.main.temp)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
}
}
