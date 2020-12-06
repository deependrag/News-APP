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
    var images: [UIImage]? {get}
    var multiPartKeyName: String? {get}
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
        
        if !items.isEmpty, images == nil {
            components.queryItems = items
        }
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var request = URLRequest(url: url,timeoutInterval: images == nil ? 10 : 60)
        if httpMethod == .post {
            request.httpMethod = HTTPMethod.post.rawValue
            
            if images == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                if let data = data {
                    let paramsData = try? JSONSerialization.data(withJSONObject: data)
                    request.httpBody = paramsData
                }
            }else {
                ///For multipart
                let boundary = "Boundary-\(UUID().uuidString)"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//                let mimeType = "image/jpeg"
                
                var body = Data()
                let boundaryPrefix = "--\(boundary)\r\n"
                
                if let params = self.params{
                    for (key, value) in params {
                        body.append(boundaryPrefix.data(using: .utf8)!)
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                        body.append("\(value)\r\n".data(using: .utf8)!)
                    }
                }
                
                var dataArray = [Data]()
                if let images = self.images {
                    for (_,image) in images.enumerated(){
                        if let data = image.jpegData(compressionQuality: 1.0){
                            dataArray.append(data)
                        }
                    }
                }
                
                var filename = String()
                for (index,data) in dataArray.enumerated(){
                    filename = "image\(index)"
                    body.append(boundaryPrefix.data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(multiPartKeyName ?? "")\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: \"content-type header\"\r\n\r\n".data(using: .utf8)!)
                    body.append(data)
                    body.append("\r\n".data(using: .utf8)!)
                    
                }
                body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//                body.append(" — ".appending(boundary.appending(" — ")).data(using: .utf8)!)
                request.httpBody = body
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
        
        if let authorizationCode = UserDefaultHandler.shared.token{
            request.setValue("Bearer " + authorizationCode, forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}


//MARK:- Login
enum APIService {
    case home,
         login(parmas: [String : Any]),
         logout,
         userProfile,
         updateUserProfile(params: [String: String]?, images: [UIImage]?, keyName: String?),
         registerUser(parmas: [String : Any]),
         socialLogin(parmas: [String : Any]),
         forgotPassword(parmas: [String : Any]),
         verifyToken(parmas: [String : Any]),
         changeForgetPassword(parmas: [String : Any]),
         updatePassword(params: [String:Any]),
         productDetails(params: [String: String]),
         getCart(params: [String: Any]),
         addToCart(params: [String: Any]),
         wishList,
         removeFromWishList(params: [String: Any]),
         updateCart(params: [String: Any]),
         checkout(params: [String: Any]),
         filter(params: [String: String]),
         
         getDeliveryAddress,
         addDeliveryAddress(params: [String: Any]),
         updateDeliveryAddress(params: [String : Any]),
         deleteDeliveryAddress(params: [String : Any]),
         
         citiesList,
         
         notificationList(params: [String : String]),
         
         orderList(params: [String : String]),
         cancelOrder(params: [String : Any]),
         getOrder(params: [String : String]),
         khaltiVerify(params: [String: Any]),
         imePayVerify(params: [String: Any]),
         
         searchSuggestion,
         searchCompletion(params: [String : String]),
         
         addOrUpdateReview(params: [String: String]?, images: [UIImage]?, keyName: String?),
         allReviews(params: [String: String]),
         userReviews(params: [String : String]),
         categories,
         brands,
         
         faqs,
         termsAndConditions,
    
         getSubscriptions(params: [String : String]),
         cancelSubscription(params: [String: Any])
}

extension APIService : Endpoint {
    var path: String {
        switch  self {
        case .home:
            return APIConstant.HOME_PAGE_URL
            
        //MARK:- User Profile
        case .userProfile:
            return APIConstant.USER_PROFILE
            
        case .updateUserProfile:
            return APIConstant.UPDATE_USER_PROFILE
            
        //MARK:- Delivery Address
        case .getDeliveryAddress:
            return APIConstant.GET_DELIVERY_ADDRESS
        
        case .updateDeliveryAddress:
            return APIConstant.UPDATE_DELIVERY_ADDRESS
            
        case .deleteDeliveryAddress:
            return APIConstant.DELETE_DELIVERY_ADDRESS
            
        case .addDeliveryAddress:
            return APIConstant.ADD_DELIVERY_ADDRESS
            
        //MARK:- Authentication
        case .login:
            return APIConstant.LOGIN_URL
        case .logout:
            return APIConstant.LOGOUT_URL
        case .socialLogin:
            return APIConstant.SOCIAL_LOGIN_URL
        case .forgotPassword:
            return APIConstant.FORGOT_PASSWORD_URL
        case .verifyToken:
            return APIConstant.VERIFY_TOKEN_URL
        case .changeForgetPassword:
            return APIConstant.CHANGE_FORGOT_PASSWORD_URL
        case .registerUser:
            return APIConstant.REGISTER_USER_URL
        case .updatePassword:
            return APIConstant.UPDATE_PASSWORD_URL
            
            //MARK:- Orders
        case .orderList:
            return APIConstant.ORDER_LIST
        case .getOrder:
            return APIConstant.GET_ORDER
        case .cancelOrder:
            return APIConstant.CANCEL_ORDER
        case .khaltiVerify:
            return APIConstant.VERIFY_KHALTI
        case .imePayVerify:
            return APIConstant.IMEPAY_VERIFY
            
        //MARK:- Carts
        case .getCart:
            return APIConstant.GET_CART
        case .updateCart:
            return APIConstant.UPDATE_CART
        case .addToCart:
            return APIConstant.ADD_TO_CART
            
        //MARK:- Checkout
        case .checkout:
            return APIConstant.CHECKOUT
            
        //MARK:- Wish List
        case .wishList:
            return APIConstant.WISH_LIST
        case .removeFromWishList:
            return APIConstant.REMOVE_FROM_WISHLIST
            
        //MARK:- Products
        case . productDetails:
            return APIConstant.PRODUCT_DETAILS
            
        //MARK:- Filter
        case .filter:
            return APIConstant.FILTER_URL
            
        //MARK:- Cities
        case .citiesList:
            return APIConstant.CITIES_LIST
            
        //MARK:- Notification
        case .notificationList:
            return APIConstant.NOTIFICATION_LIST
            
        //MARK:- Search Suggestion
        case .searchSuggestion:
            return APIConstant.SEARCH_SUGGESTION
            
        case .searchCompletion:
            return APIConstant.SEARCH_COMPLETION
            
        //MARK:- Add or Update Review
        case .addOrUpdateReview:
            return APIConstant.ADD_UPDATE_REVIEW
        case .allReviews:
            return APIConstant.ALL_REVIEWS
        case .userReviews:
            return APIConstant.GET_USER_REVIEWS
            
        //MARK:- Categories
        case .categories:
            return APIConstant.GET_CATEGORIES
            
        //MARK:- Brands
        case .brands:
            return APIConstant.GET_BRANDS
        
        //MARK:- FAQs
        case .faqs:
            return APIConstant.GET_FAQ
            
        //MARK:- Terms and conditions
        case .termsAndConditions:
            return APIConstant.TERMS_AND_CONDITIONS
            
        //MARK:- Subscription
        case .getSubscriptions:
            return APIConstant.GET_USER_SUBSCRIPTION
            
        case .cancelSubscription:
            return APIConstant.CANCEL_SUBSCRIPTION
        }
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .home, .getCart, .productDetails, .filter, .wishList, .userProfile, .getDeliveryAddress, .citiesList, .orderList, .getOrder, .notificationList, .allReviews, .searchCompletion, .searchSuggestion, .categories, .brands, .userReviews, .termsAndConditions, .faqs, .getSubscriptions:
            return .get
            
        default:
            return .post
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
        case .productDetails(let params), .filter(let params), .getOrder(let params), .orderList(let params), .notificationList(let params), .userReviews(let params), .allReviews(let params), .searchCompletion(let params), .getSubscriptions(let params):
            return params
        
        case .addOrUpdateReview(let params, _, _), .updateUserProfile(let params, _, _):
            return params
        default :
            return nil
        }
    }
    
    var data: [String : Any]? {
        switch self {
        
        case .login(let data),
             .socialLogin(let data),
             .forgotPassword(let data),
             .verifyToken(let data),
             .changeForgetPassword(let data),
             .updatePassword(let data),
             .registerUser(let data),
             .getCart(let data),
             .updateCart(let data),
             .addToCart(let data),
             .removeFromWishList(let data),
             .addDeliveryAddress(let data),
             .updateDeliveryAddress(let data),
             .deleteDeliveryAddress(let data),
             .checkout(let data),
             .khaltiVerify(let data),
             .imePayVerify(let data),
             .cancelOrder(let data),
             .cancelSubscription(let data):
            return data
        default:
            return nil
            
        }
    }
    
    var images: [UIImage]? {
        switch self {
        case .addOrUpdateReview(_, let images, _), .updateUserProfile(_, let images, _):
            return images
        default:
            return nil
            
        }
    }
    
    var multiPartKeyName: String? {
        switch self {
        case .addOrUpdateReview(_, _, let keyName), .updateUserProfile(_, _, let keyName):
            return keyName
        default:
            return nil
            
        }
    }
}
