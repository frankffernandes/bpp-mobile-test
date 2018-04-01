//
//  HTTPRequester.swift
//  EiTV Play
//
//  Created by Francisco Almeida on 03/30/2018.
//  Copyright © 2018 EiTV Entretenimento e Interatividade para TV Digital. All rights reserved.
//

import UIKit
import Alamofire

protocol HTTPResponseProtocol: class {
    func HTTPOnResponse(type: HTTPRequesterType, response: HTTPResponse)
    func HTTPOnResponseError(type: HTTPRequesterType)
}

enum HTTPRequesterType: String {    
    case login
    case invoices
}

class HTTPRequester {
    static let shared = HTTPRequester()
    private var alamoFireManager: SessionManager!
    
    let LOGIN_URL = "login"
    let INVOICES_URL = "invoice"
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5 // seconds
        configuration.timeoutIntervalForResource = 5
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }    
    
    /*
     * DELEGATE & LISTENERS
     */
    private var listeners: [HTTPResponseProtocol] = []
    func registerListener(_ instance: HTTPResponseProtocol) {
        listeners.append(instance)
    }
    func removeListener(_ instance: HTTPResponseProtocol) {
        for (i, l) in listeners.enumerated() {
            if l === instance {
                listeners.remove(at: i)
            }
        }
    }
    func informListeners(type: HTTPRequesterType, response: HTTPResponse) {
        for listener in listeners {
            listener.HTTPOnResponse(type: type, response: response)
        }
    }
    func informListenersError(type: HTTPRequesterType) {
        for listener in listeners {
            listener.HTTPOnResponseError(type: type)
        }
    }
    
    func request(_ requesterType: HTTPRequesterType, parameters: Parameters = [:]) {
        var url: String = Configuration.url
        var method: HTTPMethod = .get
        
        switch requesterType {
        case .login:
            method = .post
            url += "/\(LOGIN_URL)"
        case .invoices:
            url += "/\(INVOICES_URL)"
        }
        
        logger.debug("REQUEST - URL: \(url)")
        print("parameters: \(parameters)")
        alamoFireManager.request(url, method: method, parameters: parameters/*, headers: HTTPRequester.headersJSON*/).validate().responseJSON { response in
            switch (response.result) {
            case .success:
                var resultResponse: HTTPResponse = HTTPResponse()
                switch requesterType {
                case .login:
                    resultResponse = LoginResponse(response)
                case .invoices:
                    resultResponse = InvoicesResponse(response)
                }
                
                if resultResponse.decoded {
                    self.informListeners(type: requesterType, response: resultResponse)
                } else {
                    logger.warning("HTTPResponseType received: \(resultResponse.type)")
                    self.informListenersError(type: requesterType)
                }
            case .failure(let error):
                let returnError: NSError = (error as NSError?)!
                let statusCode = String(describing: response.response?.statusCode)
                if error._code == NSURLErrorTimedOut {
                    logger.warning("TIMEOUT - statusCode: \(statusCode) - url: \(url)")
                } else {
                    logger.error("statusCode: \(statusCode) - url: \(url) \nerror: \(returnError)")
                }
                self.informListenersError(type: requesterType)
            }
        }
    }
    
    static let headersJSON: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json",
    ]
}
