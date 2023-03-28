//
//  ConnectionURLs.swift
//  DDM_ProyectoFinal_ONC_IOS
//
//  Created by Omar Nieto on 25/03/23.
//

import Foundation
import UIKit

class ConnectionURL
{
    
    //"https://api.openweathermap.org/data/2.5/weather?lang=se&units=metric&lat={lat}&lon={lon}&appid={APIkey}"
    //"https://api.openweathermap.org/data/2.5/forecast?lang=se&units=metric&lat={lat}&lon={lon}&appid={APIkey}"
    //"http://api.openweathermap.org/data/2.5/air_pollution?lat=19.31888949&lon=-99.1843676&appid=496a0105344a523fa20133a783419a90
    ////"http://api.openweathermap.org/data/2.5/air_pollution?lat=19.31888949&lon=-99.1843676&appid=496a0105344a523fa20133a783419a90
    
    
    
    static let OPEN_WEATHER_API_KEY = "496a0105344a523fa20133a783419a90"
    static let URL_BASE = "https://api.openweathermap.org/data/2.5/"
    static let URL_BASE2 = "http://api.openweathermap.org/data/2.5/"
    
    static func getURLWeather(lat: Double, lon: Double) -> String {
        return "\(URL_BASE)weather?lang=es&units=metric&lat=\(String(lat))&lon=\(String(lon))&appid=\(OPEN_WEATHER_API_KEY)"
    }
    
    static func getURLWeatherForecast(lat: Double, lon: Double) -> String {
        return "\(URL_BASE)forecast?lang=es&units=metric&lat=\(String(lat))&lon=\(String(lon))&appid=\(OPEN_WEATHER_API_KEY)"
    }
    
    //"http://api.openweathermap.org/data/2.5/air_pollution?lat=19.31888949&lon=-99.1843676&appid=496a0105344a523fa20133a783419a90
    
    static func getURLWeatherPollution(lat: Double, lon: Double) -> String {
        return "\(URL_BASE)air_pollution?lat=\(String(lat))&lon=\(String(lon))&appid=\(OPEN_WEATHER_API_KEY)"
    }
    
}



