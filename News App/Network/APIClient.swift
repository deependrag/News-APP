//
//  AppDelegate.swift
//  News App
//
//  Created by Deependra Dhakal on 06/12/2020.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case invalidData
    case jsonConversionFailure
    case errorMessage(message : String)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .errorMessage(let message): return message
        }
    }
}

enum StatusType: String {
    case ok = "ok"
    case error = "error"
}

class APIClient {
    static let shared = APIClient()
    
    private func decodingTask<T: Codable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping (T?, APIError?) -> Void) -> URLSessionDataTask {
        
        
        let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .errorMessage(message: error?.localizedDescription ?? "Request Failed"))
                return
            }
            
            guard let data = data else {return}
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
            
            let status = json?["status"] as? String
            
            print(httpResponse.statusCode)
            if let status = status,
               let statusType = StatusType.init(rawValue: status),
               statusType == .ok{
                do {
                    let genericModel = try JSONDecoder().decode(decodingType, from: data)
                    completion(genericModel, nil)
                    
                } catch let error{
                    print(error)
                    completion(nil, .jsonConversionFailure)
                }
            }else{
                if let message  = json?["message"] as? String{
                    completion(nil,.errorMessage(message: message))
                }
            }
        }
        return task
    }
    
    func fetch<T: Codable>(with request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            print(request.url?.absoluteString ?? "")
            //MARK: change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(.invalidData))
                    }
                    return
                }
                completion(.success(json))
            }
        }
        task.resume()
    }
}
