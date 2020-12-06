//
//  AppDelegate.swift
//  News App
//
//  Created by Deependra Dhakal on 06/12/2020.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case tokenExired
    case errorMessage(message : String)
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .tokenExired: return "Token Expired"
        case .errorMessage(let message): return message
        }
    }
}

struct BaseResponse<T: Codable> : Codable {
//    let status : Bool?
    let message : String?
    let token : Int?
    let data : T?

    enum CodingKeys: String, CodingKey {

//        case status = "status"
        case message = "message"
        case data = "data"
        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(T.self, forKey: .data)
        token = try values.decodeIfPresent(Int.self, forKey: .token)
    }

}


enum ResponseType {
    case general, fromData
}

//protocol APIClient {
//    func fetch<T: Codable>(with request: URLRequest, objectType: ResponseType, decode: @escaping (Codable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
//}

class APIClient {
    static let shared = APIClient()
    
//    typealias JSONTaskCompletionHandler =
    
    private func decodingTask<T: Codable>(with request: URLRequest, object: ResponseType, decodingType: T.Type, completionHandler completion: @escaping (T?, APIError?) -> Void) -> URLSessionDataTask {
        
        
        let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .errorMessage(message: error?.localizedDescription ?? "Request Failed"))
                return
            }
            
            guard let data = data else {return}
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            
            print(httpResponse.statusCode)
            if httpResponse.statusCode == 200 {
//                if let data = data {
                    do {
                        if (json as? NSDictionary) != nil{
                            if object == .general {
                                let genericModel = try JSONDecoder().decode(decodingType, from: data)
                                completion(genericModel, nil)
                            }else {
                                let genericModel = try JSONDecoder().decode(BaseResponse<T>.self, from: data)
                                completion(genericModel.data, nil)
                            }
                        }
                        
                    } catch let error{
                        print(error)
                        completion(nil, .jsonConversionFailure)
                    }
//                } else {
//                    completion(nil, .invalidData)
//                }
            }
            else{
                
                if let json = json as? NSDictionary{
                    if let message  = json["message"] as? String{
                        completion(nil,.errorMessage(message: message))
                    }
                }else{
                    completion(nil, .requestFailed)
                }
            }
        }
        return task
    }
    
    func fetch<T: Codable>(with request: URLRequest, objectType: ResponseType, completion: @escaping (Result<T, APIError>) -> Void) {
        
//        let url = Bundle.main.url(forResource: "AppData", withExtension: "json")!
//        let data = try! Data(contentsOf: url)
////        let JSON = try! JSONSerialization.jsonObject(with: data, options: [])
//        do {
//
//            if objectType == .general {
//                let genericModel = try JSONDecoder().decode(T.self, from: data)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    completion(.success(genericModel))
//                }
//
//            }else {
//                let genericModel = try JSONDecoder().decode(BaseResponse<T>.self, from: data)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    completion(.success(genericModel.data!))
//                }
//
//            }
//
//        } catch let error{
//            print(error)
//            completion(.failure(.errorMessage(message: error.localizedDescription)))
//        }
        
        
        let task = decodingTask(with: request, object: objectType, decodingType: T.self) { (json , error) in
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
