//
//  ChangeEmailViewController.swift
//  LitNet Mobile
//
//  Created by admin on 09.08.19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

var oldEmail: String!
var password: String!

class ChangeEmailViewController: UIViewController {
    
    
    @IBAction func tapChangeEmail(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var newEmail: UITextField!
    
    @IBOutlet weak var changeEmailDesign: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeEmailDesign.layer.cornerRadius = 10
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

    @IBAction func changeEmail(_ sender: UIButton) {
        if newEmail.text != "" && newEmail.text != "" {
            guard let url = URL(string: "http://185.4.73.118:8000/changeemail") else { return }
            let parameters = "oldEmail=\(oldEmail!)&password=\(password!)&email=\(newEmail.text!)"
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
                resp = String(data: data, encoding: .utf8)
                print(data)
                print(resp)
            }.resume()
            var i = true
            while i == true {
                if resp == "True" {
                    // self.performSegue(withIdentifier: "checkPost", sender: self)
                    resp = ""
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
