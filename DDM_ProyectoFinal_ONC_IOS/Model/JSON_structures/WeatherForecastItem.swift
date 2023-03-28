//
//  WeatherForecastItem.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 25/03/23.
//

import Foundation

// MARK: - List
struct WeatherForecastItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}


//-------------- OK ---------------
// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let seaLevel, grndLevel: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}


//----------//-------------


// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}


// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}


// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
   // let gust: Double
}


// MARK: - Coord
struct Coord: Codable {
    let lat: Double
    let lon: Double
}




// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

// MARK: - Sys

struct Sys: Codable {
    //let id: Int
    //let type: Int?
    let country: String?
    let sunrise, sunset: Int?
    let pod: String?
}




