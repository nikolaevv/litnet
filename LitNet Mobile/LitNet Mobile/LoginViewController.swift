//
//  LoginViewController.swift
//  LitNet Mobile
//
//  Created by admin on 29.07.19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

var responseString: String!
var respString: String!

class LoginViewController: UIViewController {
    
    
    @IBAction func tapping(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var emailForm: UITextField!
    
    @IBOutlet weak var passwordForm: UITextField!
    
    @IBOutlet weak var loginButtonDesign: UIButton!
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let email = emailForm.text!
        print(email)
        let password = passwordForm.text!
        print(password)
        guard let url = URL(string: "http://185.4.73.118:8000/login") else { return }
        let parameters = "email=" + email + "&password=" + password
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        // guard let httpBody = try? parameters else { return }
        request.httpBody = parameters.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data else { return }
            responseString = String(data: data, encoding: .utf8)
            print(data)
            print(responseString)
        }.resume()
        var isOpened = false
        while isOpened == false {
            if responseString == "True" {
                let loginData = email + " : " + password
                let file = "data.txt"
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent(file)
                    
                    do {
                        try loginData.write(to: fileURL, atomically: false, encoding: .utf8)
                    } catch {
                        print("Cannot write data")
                    }
                }
                print("OK")
                responseString = ""
                performSegue(withIdentifier: "showApp", sender: self)
                isOpened = true
            }
            if responseString == "False" {
                responseString = ""
                let alert = UIAlertController(title: "Ошибка", message: "Вы ввели неверные логин или пароль", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                isOpened = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonDesign.layer.cornerRadius = 10
        let file = "data.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                print(text2)
                let textData = text2.components(separatedBy: " : ")
                let email = textData[0]
                print(email)
                let password = textData[1]
                print(password)
                guard let url = URL(string: "http://185.4.73.118:8000/login") else { return }
                let parameters = "email=" + email + "&password=" + password
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                // guard let httpBody = try? parameters else { return }
                request.httpBody = parameters.data(using: .utf8)
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if let response = response {
                        print(response)
                    }
                    
                    guard let data = data else { return }
                    respString = String(data: data, encoding: .utf8)
                    print(data)
                    print(respString)
                    if respString == "True" {
                        print("Yes")
                        respString = ""
                        self.performSegue(withIdentifier: "showApp", sender: self)
                    } else {
                        print("No")
                    }
                }.resume()
            } catch {
                print("Error reading")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
