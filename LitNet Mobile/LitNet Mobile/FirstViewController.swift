//
//  FirstViewController.swift
//  LitNet Mobile
//
//  Created by admin on 24.07.19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

var books: [String] = ["Капитанская дочка"]
var authors: [String] = ["Пушкин"]
var refresher: UIRefreshControl!
var textOfSearch: String!


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    @objc func getBook() {
        let url = URL(string: "http://127.0.0.1:8000/api/book/get")
        let session = URLSession.shared
        session.dataTask(with: url!) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data else { return }
            print(data)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                guard let jsonArray = json as? [[String: Any]] else { return }
                print(jsonArray)
                var iteration = 0
                books = []
                authors = []
                while (iteration+1) <= jsonArray.count {
                    guard let bookname = jsonArray[iteration]["bookname"] as? String else { return }
                    books.append(bookname)
                    guard let author = jsonArray[iteration]["author"] as? String else { return }
                    authors.append(author)
                    print(bookname + "-" + author)
                    print(1)
                    iteration += 1
                }
            } catch {
                print(error)
                print(5)
            }
            self.tableView.reloadData()
            }.resume()
        refresher.endRefreshing()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    var isSearched = true
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookItem", for: indexPath)
        cell.textLabel?.text = books[indexPath.row]
        cell.detailTextLabel?.text = authors[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://127.0.0.1:8000/api/book/get")
        let session = URLSession.shared
        session.dataTask(with: url!) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data else { return }
            print(data)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                guard let jsonArray = json as? [[String: Any]] else { return }
                print(jsonArray)
                var iteration = 0
                books = []
                authors = []
                while (iteration+1) <= jsonArray.count {
                    guard let bookname = jsonArray[iteration]["bookname"] as? String else { return }
                    books.append(bookname)
                    guard let author = jsonArray[iteration]["author"] as? String else { return }
                    authors.append(author)
                    print(bookname + "-" + author)
                    print(1)
                    iteration += 1
                }
                self.tableView.reloadData()
            } catch {
                print(error)
                print(5)
            }
        }.resume()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Обновление...")
        refresher.addTarget(self, action: #selector(FirstViewController.getBook), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        while true {
            guard var textOfSearch = searchBar.text else { return }
            print(textOfSearch)
            sleep(5)
        }
        // show(UIViewController, sender: Any?)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

