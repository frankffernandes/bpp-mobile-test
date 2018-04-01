//
//  InvoiceViewController.swift
//  BPP-Mobile
//
//  Created by Francisco Almeida on 04/01/2018.
//

import UIKit

class InvoiceViewController: UIViewController {
    var invoice: Invoice!

    @IBOutlet weak var transactionIDLabel: UILabel!
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionIDLabel.text = "Transaction ID: \(invoice.transactionID)"
        transactionIDLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        merchantLabel.text = "\(invoice.mccCode) - \(invoice.merchantName)\n\(invoice.mccDescription)"
        merchantLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatter.string(from: invoice.transactionDate)
        dateLabel.text = "Date: \(date)"
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        
        amountLabel.text = invoice.getAmount()
        amountLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        // Status
        statusLabel.text = invoice.transactionStatus.rawValue.uppercased()
        statusLabel.font = UIFont.boldSystemFont(ofSize: 14)
        statusLabel.backgroundColor = invoice.getStatusColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
