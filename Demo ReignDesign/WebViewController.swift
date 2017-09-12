//
//  WebViewController.swift
//  Demo ReignDesign
//
//  Created by Daniel López  on 11-09-17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import UIKit
import PKHUD

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var myWebView: UIWebView!
    var urlToOpen : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWebView.delegate = self
        
        let myURL = NSURL(string: urlToOpen)
        let myReq = NSURLRequest(url: myURL as! URL)
        myWebView.loadRequest(myReq as URLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        HUD.show(.progress, onView: self.myWebView)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide()
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
