//
//  VerifyEmailViewController.swift
//  LitNet Mobile
//
//  Created by admin on 09.08.19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

// var oldEmail: String!

class VerifyEmailViewController: UIViewController {

    @IBOutlet weak var code: UITextField!
    
    @IBOutlet weak var verifyButtonDesign: UIButton!
    
    
    @IBAction func tapEmailVerify(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyButtonDesign.layer.cornerRadius = 10
        let file = "data.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                print(text2)
                let textData = text2.components(separatedBy: " : ")
                oldEmail = textData[0]
                password = textData[1]
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
    
    @IBAction func verifyEmail(_ sender: UIButton) {
        if code.text != "" && code.text != "" {
            guard let url = URL(string: "http://185.4.73.118:8000/verifynewemail") else { return }
            let parameters = "oldEmail=\(oldEmail!)&verifyCode=\(code.text!)"
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            // guard let httpBody = try? parameters else { return }
            request.httpBody = parameters.data(using: .utf8)
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print("response")
                }
                
                guard let data = data else { return }
                resp = String(data: data, encoding: .utf8)
            }.resume()
            var i = true
            while i == true {
                if resp != "False" && resp != "Invalid" {
                    let loginData = resp + " : " + password
                    let file = "data.txt"
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent(file)
                        
                        do {
                            try loginData.write(to: fileURL, atomically: false, encoding: .utf8)
                        } catch {
                            print("Cannot write data")
                        }
                    }
                    let alertSuccess = UIAlertController(title: "Успешно", message: "Электронная почта изменена", preferredStyle: .alert)
                    alertSuccess.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    self.present(alertSuccess, animated: true, completion: nil)
                    i = false
                } else if resp == "False" {
                    let alertError = UIAlertController(title: "Ошибка", message: "Проверьте корректность введённых данных", preferredStyle: .alert)
                    alertError.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    self.present(alertError, animated: true, completion: nil)
                    i = false
                }
            }
        }
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
