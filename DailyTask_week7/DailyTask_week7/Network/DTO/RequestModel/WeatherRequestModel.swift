//
//  WeatherRequestModel.swift
//  DailyTask_week7
//
//  Created by 박신영 on 2/3/25.
//

import Foundation

extension DTO {
    static let accessToken = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.apiKey) as? String
    
    // MARK: - WeatherRequestModel
    struct WeatherRequestModel: Codable {
        let lat: Double
        let lon: Double
        var appid = accessToken
        var units: String = "metric"
    }
    
}
