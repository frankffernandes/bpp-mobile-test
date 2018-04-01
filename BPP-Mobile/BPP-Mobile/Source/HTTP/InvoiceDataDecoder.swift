//
//  InvoiceDataDecoder.swift
//  BPP-Mobile
//
//  Created by Francisco Almeida on 03/30/2018.
//

import Foundation
import UIKit

typealias InvoiceDataDecoder = [Invoice]

class Invoice: Codable {
    let transactionID, transactionFormattedDate: String
    let transactionDate: Date
    let transactionCurrency: Currency
    let transactionAmount: Double
    let billingCurrency: Currency
    let billingAmount: Double
    let transactionStatus: TransactionStatus
    let transactionName: String
    let merchantName: String
    let mccCode: String
    let mccDescription: String
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case transactionDate, transactionFormattedDate, transactionCurrency, transactionAmount, billingCurrency, billingAmount, transactionStatus, transactionName, merchantName, mccCode, mccDescription
    }
    
    func getStatusColor() -> UIColor {
        switch transactionStatus.hashValue {
        case 0:
            return UIColor.red.withAlphaComponent(0.3)
        case 1:
            return UIColor.yellow.withAlphaComponent(0.3)
        case 2:
            return UIColor.blue.withAlphaComponent(0.3)
        case 3:
            return UIColor.green.withAlphaComponent(0.3)
        default:
            return .white
        }
    }
    
    func getAmount() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "pt_BR")
        let number = NSNumber(value: transactionAmount)
        return numberFormatter.string(from: number)!
    }
}

enum Currency: String, Codable {
    case brl = "BRL"
}

enum TransactionStatus: String, Codable {
    case declined = "Declined"
    case pending = "Pending"
    case reversed = "Reversed"
    case settled = "Settled"
}
