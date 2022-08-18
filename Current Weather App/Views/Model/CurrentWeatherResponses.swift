//
//  CurrentWeatherResponses.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 3/1/22.
//

import Foundation

struct CurrentWeatherResponses : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Codable {
    let temp : Double
    let feelsLike : Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        
    }
}
struct Weather : Codable {
    let id : Int
}
