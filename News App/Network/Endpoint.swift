//
//  AppDelegate.swift
//  News App
//
//  Created by Deependra Dhakal on 06/12/2020.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Endpoint {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var httpHeaders: [String : String]? { get }
    var params: [String : String]? { get }
    var data: [String : Any]? { get }
}


extension Endpoint {
    var base: String {
        return APIConstant.BASE_URL
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        var items = [URLQueryItem]()
        
        if let params = self.params{
            for (key,value) in params {
                items.append(URLQueryItem(name: key, value: value))
            }
            
        }
        
        items = items.filter{!$0.name.isEmpty}
        
        if !items.isEmpty{
            components.queryItems = items
        }
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        if httpMethod == .post {
            request.httpMethod = HTTPMethod.post.rawValue
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let data = data {
                let paramsData = try? JSONSerialization.data(withJSONObject: data)
                request.httpBody = paramsData
            }
        } else {
            request.httpMethod = HTTPMethod.get.rawValue
        }
        
        //Set headers
        if let requestHeaders = httpHeaders {
            for (key, value) in requestHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.setValue(APIConstant.API_KEY, forHTTPHeaderField: "X-Api-Key")
        
        return request
    }
}


//MARK:- API Setup
enum APIService {
    case topHeadlines(params: [String : String])
}

extension APIService : Endpoint {
    var path: String {
        switch  self {
        case .topHeadlines:
            return APIConstant.TOP_HEADLINES_URL
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .topHeadlines:
            return .get
        }
    }
    
    var httpHeaders: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
    
    var params: [String : String]? {
        switch self {
        case .topHeadlines(let params):
            return params
        }
    }
    
    var data: [String : Any]? {
        switch self {
        
        default:
            return nil
            
        }
    }
    
}
