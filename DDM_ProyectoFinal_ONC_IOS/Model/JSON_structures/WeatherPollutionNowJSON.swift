//
//  WeatherPollutionNow.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 20/03/23.
//

import Foundation

// MARK: - WeatherPollution

struct WeatherPollution: Codable {
    let coord: Coord
    let list: [ListPollution]
}

// MARK: - List
struct ListPollution: Codable {
    let dt: Int
    let main: MainPollution
    let components: [String: Double]
}

// MARK: - Main
struct MainPollution: Codable {
    let aqi: Int
}

