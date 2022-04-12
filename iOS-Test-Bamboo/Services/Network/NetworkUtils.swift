//
//  NetworkUtils.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import Alamofire
import Foundation

struct NetworkRequest {
    var endpoint: API_Client
    var method: HTTPMethod
    var encoding: Encoding
    var body: Dictionary<String, Any>
    var files: Dictionary<String, Data> = [:]
    
    init(endpoint: API_Client, method: HTTPMethod, encoding: Encoding, body: Dictionary<String, Any>) {
        self.endpoint = endpoint
        self.method = method
        self.body = body
        self.encoding = encoding
    }
}

enum NetworkResponse {
    case success
    case failed(NetworkError)
    
    var localizedDescription: String {
        switch self {
        case .success:
            return "successful"
        case .failed(let error):
            return error.localizedDescription
        }
    }
}

enum NetworkError: Error {
    case api_error(String)
    case unauthenticated
    case unauthorized
    case not_found
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .api_error(let error):
            return error
        case .unauthenticated, .unauthorized:
            return "Request authorization failed, please login"
        case .not_found:
            return "Requested URL was not found"
        case .unknown(let error):
            return error
        }
    }
}

extension NetworkError: Comparable {
    static func < (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return false
    }
    
    static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

enum Encoding {
    case json
    case url
    case urlJson
    case upload
    
    var get: ParameterEncoding {
        switch self {
        case .json, .upload:
            return JSONEncoding.default
        case .url, .urlJson:
            return URLEncoding.default
        }
    }
    
    var contentType: (name: String, value: String) {
        switch self {
        case .json, .urlJson:
            return (name: "Content-Type", value: "application/json")
        case .url:
            return (name: "Content-Type", value: "application/x-www-form-urlencoded")
        case .upload:
            return (name: "Content-type", value: "multipart/form-data")
        }
    }
}

