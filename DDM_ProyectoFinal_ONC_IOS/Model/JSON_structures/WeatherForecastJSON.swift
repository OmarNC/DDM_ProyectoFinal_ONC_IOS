//
//  WeatherForecastJSON.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 25/03/23.
//

import Foundation

// MARK: - WeatherForecast
struct WeatherForecast: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherForecastItem]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
