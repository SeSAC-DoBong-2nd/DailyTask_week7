//
//  NetworkManager.swift
//  DailyTask_week7
//
//  Created by 박신영 on 2/3/25.
//

import Foundation

import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getWeatherAPI<T: Decodable>(apiHandler: WeatherTargetType,
                                  responseModel: T.Type,
                                     completionHandler: @escaping (Result<T, AFError>) -> Void) {
        AF.request(apiHandler)
            .responseDecodable(of: T.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(let result):
                    print("✅ API 요청 성공")
                    completionHandler(.success(result))
                case .failure(let error):
                    print("❌ API 요청 실패\n", error)
                    completionHandler(.failure(error))
                }
            }
    }

}
