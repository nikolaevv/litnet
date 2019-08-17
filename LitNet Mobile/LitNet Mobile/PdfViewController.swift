//
//  PdfViewController.swift
//  LitNet Mobile
//
//  Created by admin on 11.08.19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import PDFKit

class ReadViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        do{
            view.addSubview(pdfView)
            
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            // let path = Bundle.main.url(forResource: "mercedes", withExtension: "pdf")
            let url = "http://185.4.73.118:8000/books/" + files[fileNumber]
            let path = URL(string: url)
            
            let document = PDFDocument(url: path!)
            pdfView.document = document
            print("OK")
        } catch {
            print("GF")
        }
        
        /*
         
        let url = Bundle.main.url(forResource: "mercedes", withExtension: "pdf")
        if let url = url {
            let webView = WKWebView(frame: view.frame)
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            view.addSubview(webView)
        } */
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
