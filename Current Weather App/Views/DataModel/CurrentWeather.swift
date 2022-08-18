//
//  CurrentWeather.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 3/1/22.
//

import Foundation

struct CurrentWeather{
    var cityName : String
    let temperature : Double
//    because label has string in it
    var temperatureString : String{
        return String("\(String( format : "%.0f", temperature))ºF")
    }
    let feelsLikeTemperature : Double
    var feelsLikeTemperatureString : String{
        return String("Feels like \(String( format : "%.0f", feelsLikeTemperature))ºF")
    }
    let conditionCode : Int
    
    var systemIconNameString : String{
        switch conditionCode {
        case 200...230: return
            "cloud.bolt.rain.fill"
        case 300...321 : return
            "cloud.drizzle.fill"
        case 500...531 : return
            "cloud.drizzle.fill"
        case 600...622 : return
            "cloud.snow.fill"
        case 701...781 : return
            "cloud.fog.fill"
        case 800 : return
            "sun.min.fill"
        case 801...804 : return
            "cloud.sun.fill"
        default: return
            "nosign"
        }
    }
    
    init?(currentWeatherResponses : CurrentWeatherResponses){
        cityName = currentWeatherResponses.name
        temperature = currentWeatherResponses.main.temp
        feelsLikeTemperature = currentWeatherResponses.main.feelsLike
        conditionCode = currentWeatherResponses.weather.first!.id
    }
}
