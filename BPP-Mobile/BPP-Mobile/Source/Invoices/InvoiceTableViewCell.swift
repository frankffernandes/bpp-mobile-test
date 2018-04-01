//
//  InvoiceTableViewCell.swift
//  BPP-Mobile
//
//  Created by Francisco Almeida on 04/01/2018.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupHeader() {
        selectionStyle = .none
        backgroundColor = .none
        
        codeLabel.text = "PRICE"
        codeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        nameLabel.text = "NAME"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        dateLabel.text = "DATE"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        statusLabel.text = "STATUS"
        statusLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func setup(_ invoice: Invoice) {
        selectionStyle = .none
        
        codeLabel.text = invoice.getAmount() //invoice.mccCode
        codeLabel.font = UIFont.systemFont(ofSize: 11)
        
        nameLabel.text = invoice.merchantName
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        
        // Status
        statusLabel.text = invoice.transactionStatus.rawValue
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        backgroundColor = invoice.getStatusColor()
        
        // Date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: invoice.transactionDate)
        dateLabel.font = UIFont.systemFont(ofSize: 11)
    }
}
