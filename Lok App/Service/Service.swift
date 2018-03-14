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
    var baseUrl: String {
        get {
            return Config.default.getUrl()
        }
    }
    
    func request(url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, progressHandler: ((Double) -> Void)? = nil) -> Observable<JSON> {
        return Observable<JSON>.create({ [weak self] (observer) -> Disposable in
            let request = Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).downloadProgress(closure: { (progress) in
                progressHandler?(progress.fractionCompleted)
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
