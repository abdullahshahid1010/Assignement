//
//  ViewController.swift
//  Assignment
//
//  Created by Power on 07/05/2021.
//  Copyright © 2021 Abdullah Shahid. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
   var saveToken = ""
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //Hiding the Navigation Bar on the SignIn Screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let urll = "http://staging.virtualmdcanada.com:8000/api/v1/app/users/sign-in"
    
    func getData(from url : String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data, error == nil else{
                print("Something Went Wrong")
                return
            }
            print(data)
        }
        task.resume()
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        //getData(from: url)
        // prepare json data
        let json: [String: Any] = [
            "email": "\(emailTextField.text ?? "")",
            "password": "\(passwordTextField.text ?? "")"
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: urll)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")

        // insert json data to the request
        request.httpBody = jsonData
        //print(jsonData)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            //let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
           // print(responseJSON)
            //if let responseJSON = responseJSON as? [String: Any] {
              //  print(responseJSON)
                
                let deocder = JSONDecoder()
            //let JSONFromServer = try? JSONSerialization.jsonObject(with: data, options: [])
            let tokenArray = try? deocder.decode(ResponseMessage.self, from: data)
            //print(tokenArray!.body.token)
            UserDefaults.standard.set(tokenArray?.body.token, forKey: "savedToken")

            do {
               let answer = try deocder.decode(ResponseMessage.self, from: data)
                DispatchQueue.main.async {
                    
                    if answer.status.code == 200 {
                        self.saveToken = answer.body.token
                        self.performSegue(withIdentifier: "SignInSegue", sender: self)
                    }
                    else{
                        self.showError()
                    }
                }
            }
                catch{
                    DispatchQueue.main.async {
                        self.showError()
                    }
                    print("failed to convert \(error.localizedDescription)")
                    //self.showError()
                }
            
        }
        task.resume()
        
    }
    func showError() {
            let ac = UIAlertController(title: "Invalid Credentials", message: "There was a problem  Signing In, Enter valid Email and Password OR Sign Up", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
    }
    
}

struct Response : Codable{
    var code : Int
    var message : String
}
struct ResponseMessage : Codable {
    var status : Response
    var body : TokenResponse
}
struct TokenResponse: Codable {
    var token: String
}
