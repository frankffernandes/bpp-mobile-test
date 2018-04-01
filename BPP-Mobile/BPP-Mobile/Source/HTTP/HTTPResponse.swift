//
//  HTTPResponse.swift
//  EiTV Play
//
//  Created by Francisco Almeida on 03/30/2018.
//  Copyright © 2018 EiTV Entretenimento e Interatividade para TV Digital. All rights reserved.
//

import UIKit
import Alamofire

class HTTPResponse {    
    var type: HTTPRequesterType!
    
    let decoder = MyJSONDecoder()
    var decoded: Bool = false
}

/*
 * LOGIN
 */
class LoginResponse: HTTPResponse {
    var status: LoginStatus = .error
    var message: String = ""
    var code: LoginCode = .code_300
    
    override init() {
        super.init()
        type = .login
    }
    convenience init(_ response: Alamofire.DataResponse<Any>) {
        self.init()
        do {
            let decodedInfo = try decoder.decode(LoginDataDecoder.self, from: response.data!)
            decoded = true
            status = decodedInfo.status
            code = decodedInfo.code
            if let _ = decodedInfo.message {
                message = decodedInfo.message!
            }
        } catch {
            logger.error(error)
        }
    }
}

/*
 * INVOICE
 */
class InvoicesResponse: HTTPResponse {
    var invoices: [Invoice] = []
    override init() {
        super.init()
        type = .invoices
    }
    convenience init(_ response: Alamofire.DataResponse<Any>) {
        self.init()
        do {
            let decodedInfo = try decoder.decode(InvoiceDataDecoder.self, from: response.data!)
            decoded = true
            invoices = decodedInfo
        } catch {
            logger.error(error)
        }
    }
}

class MyJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "ddMMyyyy HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        self.dateDecodingStrategy = .formatted(formatter)
    }
}
