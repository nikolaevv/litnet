//
//  BooksTableViewController.swift
//  LitNet Mobile
//
//  Created by admin on 06.08.19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import WebKit

let url = URL(string: "http://185.4.73.118:8000/api/book/get")

var bookNames: [String] = ["Капитанская дочка"]
var authorNames: [String] = ["Пушкин"]
var files: [String] = ["firstUpload"]
var fileNumber: Int!
var searchRequest: String!

class BooksTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var search: UISearchBar!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchRequest = search.text
        print(searchRequest)
        if searchRequest == "" {
            let session = URLSession.shared
            session.dataTask(with: url!) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                
                guard let data = data else { return }
                print(data)
                type(of: data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(type(of: json))
                    guard let jsonArray = json as? [[String: Any]] else { return }
                    print(type(of: jsonArray))
                    var iteration = 0
                    bookNames = []
                    authorNames = []
                    files = []
                    while (iteration+1) <= jsonArray.count {
                        guard let bookname = jsonArray[iteration]["bookname"] as? String else { return }
                        bookNames.append(bookname)
                        guard let author = jsonArray[iteration]["author"] as? String else { return }
                        authorNames.append(author)
                        guard let file = jsonArray[iteration]["book"] as? String else { return }
                        files.append(file)
                        print(bookname + "-" + author)
                        print(1)
                        iteration += 1
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                    print(5)
                }
            }.resume()
        } else {
            guard let url = URL(string: "http://185.4.73.118:8000/api/book/search") else { return }
            let parameters = "text=" + searchRequest
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
                print(data)
                print(type(of: data))
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(type(of: json))
                    print(json)
                    print("BB")
                    let jsonArray = json as! [[String: Any]]
                    print(type(of: jsonArray))
                    print("GG")
                    var iteration = 0
                    bookNames = []
                    authorNames = []
                    files = []
                    while (iteration+1) <= (jsonArray.count) {
                        guard let bookname = jsonArray[iteration]["bookname"] as? String else { return }
                        bookNames.append(bookname)
                        guard let author = jsonArray[iteration]["author"] as? String else { return }
                        authorNames.append(author)
                        guard let file = jsonArray[iteration]["book"] as? String else { return }
                        files.append(file)
                        print(bookname + "-" + author)
                        print(1)
                        iteration += 1
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                    print(5)
                }
            }.resume()
        }
    }
    
    func getBooks() {
        let session = URLSession.shared
        session.dataTask(with: url!) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data else { return }
            print(data)
            type(of: data)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(type(of: json))
                guard let jsonArray = json as? [[String: Any]] else { return }
                print(type(of: jsonArray))
                var iteration = 0
                bookNames.popLast()
                authorNames.popLast()
                files.popLast()
                while (iteration+1) <= jsonArray.count {
                    guard let bookname = jsonArray[iteration]["bookname"] as? String else { return }
                    bookNames.append(bookname)
                    guard let author = jsonArray[iteration]["author"] as? String else { return }
                    authorNames.append(author)
                    guard let file = jsonArray[iteration]["book"] as? String else { return }
                    files.append(file)
                    print(bookname + "-" + author)
                    print(1)
                    iteration += 1
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
                print(5)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBooks()
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookItem", for: indexPath)
        cell.textLabel?.text = bookNames[indexPath.row]
        cell.detailTextLabel?.text = authorNames[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fileNumber = indexPath.row
    }
    
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
