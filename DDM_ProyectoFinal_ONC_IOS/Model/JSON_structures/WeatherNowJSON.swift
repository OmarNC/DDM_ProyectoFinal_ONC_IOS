//
//  WeatherNowJSON.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 20/03/23.
//

import Foundation

// MARK: - WeatherNow
 struct WeatherNow: Codable {
     let coord: Coord
     let weather: [Weather]
     let base: String
     let main: Main
     let visibility: Int
     let wind: Wind
     let rain: Rain?
     let clouds: Clouds
     let dt: Int
     let sys: Sys
     let timezone, id: Int
     let name: String
     let cod: Int
 }
 





