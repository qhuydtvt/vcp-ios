//
//  Service.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

class Service {
    
    static var shared: Service {
        return Service()
    }
    
    fileprivate var baseUrl: String = ""
    
    fileprivate var headers: HTTPHeaders? = nil
    
    fileprivate var parameters: Parameters? = nil
    
    fileprivate var method: HTTPMethod = .get
    
    var progress: BehaviorSubject<Double>
    
    fileprivate init() {
        self.progress = BehaviorSubject(value: 0.0)
    }
    
    func setPathUrl(path: String) -> Service {
        self.baseUrl = Config.default.getUrl() + path
        return self
    }
    
    func withHeaders(key: String, value: String) -> Service {
        if self.headers == nil {
            self.headers = [:]
        }
        self.headers?[key] = value
        return self
    }
    
    func withParameters(key: String, value: Any) -> Service {
        if self.parameters == nil {
            self.parameters = [:]
        }
        self.parameters?[key] = value
        return self
    }
    
    func method( _ method: HTTPMethod) -> Service {
        self.method = method
        return self
    }
    
    func request() -> Observable<JSON> {
        return Observable<JSON>.create({ [weak self] (observer) -> Disposable in
            let request = Alamofire.request(self?.baseUrl ?? "", method: self?.method ?? .get, parameters: self?.parameters, encoding: URLEncoding.default, headers: self?.headers).downloadProgress(closure: { (progress) in
                self?.progress.onNext(progress.fractionCompleted)
                if progress.fractionCompleted.isEqual(to: 1.0) {
                    self?.progress.onCompleted()
                }
            }).responseJSON(completionHandler: { [weak self] (response) in
                if let json = self?.responseJSON(response) {
                    observer.onNext(json)
                }
                if let error = self?.responseError(response) {
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    fileprivate func responseJSON(_ response: DataResponse<Any>) -> JSON? {
        guard let data = response.result.value, let statusCode = response.response?.statusCode, statusCode == 200 else {
            return nil
        }
        return JSON(data)
    }
    
    fileprivate func responseError(_ response: DataResponse<Any>) -> LokServiceError<String, Int> {
        guard let data = response.result.value, let statusCode = response.response?.statusCode else {
            return .other("Đã xảy ra lỗi!")
        }
        guard let message = JSON(data)["message"].string else {
            return .other("Đã xảy ra lỗi!")
        }
        
        switch statusCode {
        case 400..<451:
            return .client(message, statusCode)
        case 500..<530:
            return .server(message, statusCode)
        default:
            return .other("Đã xảy ra lỗi!")
        }
    }
}


