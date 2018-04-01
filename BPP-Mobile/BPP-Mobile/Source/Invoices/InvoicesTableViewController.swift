//
//  InvoicesTableViewController.swift
//  BPP-Mobile
//
//  Created by Francisco Almeida on 04/01/2018.
//

import UIKit

class InvoicesTableViewController: UITableViewController {
    var invoices: [Invoice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        
        HTTPRequester.shared.registerListener(self)
        refresh(sender: self)
    }
    
    @objc func refresh(sender: Any?) {
        invoices = []
        tableView.reloadData()
        HTTPRequester.shared.request(.invoices)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell", for: indexPath) as! InvoiceTableViewCell
        
        if indexPath.row == 0 {
            cell.setupHeader()
        } else {
            cell.setup(invoices[indexPath.row - 1])
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "InvoiceView") as! InvoiceViewController
            viewController.invoice = invoices[indexPath.row - 1]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func logout(sender: Any?) {
        UserDefaults.standard.removeObject(forKey: "UserLogged")
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        //dismiss(animated: true, completion: nil)
    }
}

extension InvoicesTableViewController: HTTPResponseProtocol {
    func HTTPOnResponse(type: HTTPRequesterType, response: HTTPResponse) {
        logger.debug("type: \(type) - response: \(response)")
        if type == .invoices, let response = response as? InvoicesResponse {
            invoices = response.invoices
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }
    
    func HTTPOnResponseError(type: HTTPRequesterType) {
        logger.debug("type: \(type)")
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
}
