//
//  WebViewController.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 16.01.24.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func showUrl(link: String) {
        let url = URL(string: link)
        if let url = url {
            loadWebView(url)
        }
    }
        
    private func loadWebView(_ url: URL) {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest as URLRequest)
        }
}
