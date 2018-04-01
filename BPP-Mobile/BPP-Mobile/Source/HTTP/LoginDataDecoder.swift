//
//  LoginDataDecoder.swift
//  BPP-Mobile
//
//  Created by Francisco Almeida on 04/01/2018.
//

import Foundation

class LoginDataDecoder: Codable {
    let status: LoginStatus
    let message: String?
    let code: LoginCode
}

enum LoginStatus: String, Codable {
    case success
    case error
}

enum LoginCode: String, Codable {
    case code_200 = "200"
    case code_300 = "300"
}
