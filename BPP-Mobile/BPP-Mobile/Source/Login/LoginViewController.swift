//
//  LoginViewController.swift
//  BPP-Mobile
//
//  Created by Francisco Almeida on 04/01/2018.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var emailLabel: FormTextField!
    @IBOutlet weak var passwordLabel: FormTextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var logged: Bool = false
        if let value = defaults.object(forKey: "UserLogged") as? Bool {
            logged = value
        }
        
        if logged {
            performSegue(withIdentifier: "goto_navigation", sender: self)
        }
        
        emailLabel.delegate = self
        passwordLabel.delegate = self
        
        emailLabel.text = "waldisney@brasilprepagos.com.br"
        passwordLabel.text = "Br@silPP123"
    }
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) { }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {        
        HTTPRequester.shared.registerListener(self)
        messageLabel.text = ""
        
        let email: String = emailLabel.text!
        let password: String = passwordLabel.text!
        if !email.isEmpty && !password.isEmpty {
            let basedPassword = Data(password.utf8).base64EncodedString()
            let parameters: Parameters = [
                "email": email,
                "password": basedPassword
            ]
            HTTPRequester.shared.request(.login, parameters: parameters)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController: HTTPResponseProtocol {
    func HTTPOnResponse(type: HTTPRequesterType, response: HTTPResponse) {
        logger.debug("type: \(type) - response: \(response)")
        if type == .login, let response = response as? LoginResponse {
            if response.code == .code_200 && response.status == .success {
                defaults.set(true, forKey: "UserLogged")
                defaults.synchronize()
                
                performSegue(withIdentifier: "goto_navigation", sender: self)
            } else {
                logger.debug(" MESSAGE: \(response.message) - \(response.code)")
                messageLabel.text = response.message
            }
            HTTPRequester.shared.removeListener(self)
        }
    }
    
    func HTTPOnResponseError(type: HTTPRequesterType) {
        logger.debug("type: \(type)")
        HTTPRequester.shared.removeListener(self)
    }
}
