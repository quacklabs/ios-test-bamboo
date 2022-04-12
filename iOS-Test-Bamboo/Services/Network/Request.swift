//
//  Request.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class Request: NetworkService {
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let sessionManager = Session(configuration: configuration, delegate: SessionDelegate(), serverTrustManager: nil)
        return sessionManager
    }()
    
    func fetch<T>(_ request: NetworkRequest) -> Observable<(NetworkResponse, T?)> where T : Decodable, T : Encodable {
        let headers = self.buildHeaders(encoding: request.encoding)
        return Observable.create({ observer -> Disposable in
            if let url = request.endpoint.url {
                
                self.session.request(url, method: request.method, parameters: request.body, encoding: request.encoding.get, headers: headers).response { response in
                    self.parseResponse(response) { (status, _ result: T?) in
                        switch status {
                        case .success:
                            observer.onNext((status, result))
                        case .failed(let error):
                            observer.onError(error)
                        }
                        observer.onCompleted()
                    }
                }
                
            } else {
                observer.onError(NetworkError.unknown("URL could not be determined"))
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
    /*
        for upload or multipart form tasks
     
        Returns:
            NetworkResponse - Network response status
            CGFloat - current upload progress
            T - Generic data model expected from server
     */
    func push<T>(_ request: NetworkRequest) -> Observable<(NetworkResponse, CGFloat?, T?)> where T : Decodable, T : Encodable {
        let headers = self.buildHeaders(encoding: request.encoding)
        
        let block = { (multipart: MultipartFormData) in
            if request.body.count > 0 {
                for (key, value) in request.body {
                    if let data = self.form_data(value: value) {
                        multipart.append(data, withName: key)
                    }
                }
            }
            // only handling image uploads for now. to refactor later
            if request.files.count > 0 {
                for (key, value) in request.files {
                    let fileName = NSUUID().uuidString
                    multipart.append(value, withName: "\(key)", fileName: "\(fileName).jpeg", mimeType: "image/jpeg")
                }
            }
        }
        
        return Observable.create({ observer -> Disposable in
            if let url = request.endpoint.url {
                
                AF.upload(multipartFormData: block, to: url, method: request.method, headers: headers).response { response in
                    self.parseResponse(response) { (status, _ result: T?) in
                        switch status {
                        case .success:
                            observer.onNext((status, nil, result))
                        case .failed(let error):
                            observer.onError(error)
                        }
                        observer.onCompleted()
                    }
                }
            } else {
                observer.onError(NetworkError.unknown("URL could not be determined"))
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
    
    
    private func parseResponse<T: Codable>(_ response: AFDataResponse<Data?>, completion: (NetworkResponse, T?) -> Void) {
        switch(response.response?.statusCode) {
        case 200, 201:
            if let jsonData = response.data {
                if let json = try? JSONDecoder().decode(T.self, from: jsonData) {
                    completion(.success, json)
                    return
                }
                
                do {
                    let obj = try JSONSerialization.jsonObject(with: jsonData, options: [.fragmentsAllowed, .allowFragments])
                    print("obj: \(obj)")
                    let data = try JSONSerialization.data(withJSONObject: obj, options: [.fragmentsAllowed, .prettyPrinted])
                    do {
                        let serialized = try JSONDecoder().decode(T.self, from: data)
                        completion(.success, serialized)
                    }catch {
                        print("error again: \(error)")
                        completion(.success, nil)
                    }
                    
                } catch {
                    print("error: \(error)")
                }
            } else {
                completion(.success, nil)
            }
        case 400, 401:
            guard let data = response.data else {
                completion(.failed(.api_error("No response received")), nil)
                return
            }
            if let server_error = try? JSONDecoder().decode(Response.self, from: data) {
                completion(.failed(.api_error(server_error.message)), nil)
                return
            }
            completion(.failed(.api_error("Invalid API Key")), nil)
        case 403:
            completion(.failed(.unauthenticated), nil)
        case 404, 422:
            guard let data = response.data, let resp = try? JSONDecoder().decode(Response.self, from: data) else {
                completion(.failed(.unknown("Unable to decode errorr")), nil)
                return
            }
            completion(.failed(.unknown(resp.message)), nil)
        default:
            print("response: \(response.response)")
            session.cancelAllRequests()
            completion(.failed(.unknown("Your internet connection appears to be offline")), nil)
        }
    }
    
    func buildHeaders(encoding: Encoding? = .json, token: String? = nil) -> HTTPHeaders {
        var headers: HTTPHeaders = ["Accept" : "application/json"]
        headers.add(name: encoding!.contentType.name, value: encoding!.contentType.value)

        if let token = token {
            headers.add(name: "Authorization", value: token)
        }

        return headers
    }
    
    // Properly formatting and parsing multipart/form-data requests to be sent as json request
    private func form_data(value: Any) -> Data? {
        if value is String {
            if let temp = value as? String {
                return temp.data(using: .utf8, allowLossyConversion: false)!
            }
        } else if value is Int {
            if let temp = value as? Int {
                let data = try! JSONEncoder().encode(temp)
                return data
            }
        } else if value is Bool {
            if let temp = value as? Bool {
                let boolData = try! JSONEncoder().encode(temp)
                return boolData
            }
        }
        return nil
    }
}
