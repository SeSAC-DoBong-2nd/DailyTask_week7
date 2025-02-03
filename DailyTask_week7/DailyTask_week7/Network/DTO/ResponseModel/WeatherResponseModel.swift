//
//  WeatherResponseModel.swift
//  DailyTask_week7
//
//  Created by 박신영 on 2/3/25.
//

import Foundation

extension DTO {
    
    // MARK: - WeatherResponseModel
    struct WeatherResponseModel: Codable {
        let coord: Coord
        let weather: [Weather]
        let main: Main
        let wind: Wind
    }
    
    // MARK: - Coord
    struct Coord: Codable {
        let lon, lat: Double
    }
    
    // MARK: - Main
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, humidity, seaLevel, grndLevel: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main, description, icon: String
    }
    
    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double
    }
    
}
