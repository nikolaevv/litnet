//
//  ProfileViewController.swift
//  LitNet Mobile
//
//  Created by admin on 05.08.19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

let site = URL(string: "http://185.4.73.118:8000")!
var nickResponse: String!
var mailViewText: String!

class ProfileViewController: UITableViewController {
    
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var mailView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let file = "data.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                print(text2)
                let textData = text2.components(separatedBy: " : ")
                let email = textData[0]
                print(email)
                mailViewText = email
                let password = textData[1]
                print(password)
                guard let url = URL(string: "http:185.4.73.118:8000/getnickname") else { return }
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
                    nickResponse = String(data: data, encoding: .utf8)
                    print(data)
                    print(nickResponse)
                }.resume()
            } catch {
                print("Error reading")
            }
            var u = false
            while u == false {
                if nickname.text == "True" {
                    if nickResponse != "" && nickResponse != nil {
                        mailView.text = mailViewText
                        nickname.text = nickResponse
                    }
                } else {
                    u = true
                }
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0 && indexPath.section == 0 {
            UIApplication.shared.open(site)
        } else if indexPath.row == 0 && indexPath.section == 2 {
            let loginData = " : "
            let file = "data.txt"
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent(file)
                
                do {
                    try loginData.write(to: fileURL, atomically: false, encoding: .utf8)
                } catch {
                    print("Cannot write data")
                }
            }
            performSegue(withIdentifier: "exit", sender: self)
        }
    }

    // MARK: - Table view data source

    /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
 */
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
