//
//  WeatherTargetType.swift
//  DailyTask_week7
//
//  Created by 박신영 on 2/3/25.
//

import Foundation

import Alamofire

enum WeatherTargetType {
    case getWeatherAPI(request: DTO.WeatherRequestModel)
}

extension WeatherTargetType: TargetType {
    
    var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.baseURL) as? String,
              let url = URL(string: urlString) else {
            fatalError("🚨BASE_URL을 찾을 수 없습니다🚨")
        }
        return url
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var utilPath: String {
        switch self {
        case .getWeatherAPI:
            return ""
        }
    }
    
    var path: String {
        switch self {
        case .getWeatherAPI:
            return ""
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .getWeatherAPI(let request):
            return .query(request)
        }
    }
    
    var encoding: Alamofire.ParameterEncoding {
        return URLEncoding.default
    }
    
    var header: Alamofire.HTTPHeaders {
        return []
    }
    
}

