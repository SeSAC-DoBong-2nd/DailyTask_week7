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
        let main: Main
        let wind: Wind
    }
    
    // MARK: - Main
    struct Main: Codable {
        let temp, tempMin, tempMax: Double?
        let humidity: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }
    
    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double?
    }
    
}
