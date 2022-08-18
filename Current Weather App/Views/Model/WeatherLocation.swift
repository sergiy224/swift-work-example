//
//  WeatherLocation.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 4/21/22.
//

import Foundation
class WeatherLocation {
    var name: String
    var latitude : Double
    var longitude : Double
    
    init(name : String, latitude : Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        
    }
}
