//
//  GFPurchaseWebViewController.swift
//  Genfare
//
//  Created by omniwyse on 06/02/19.
//  Copyright © 2019 Omniwyse. All rights reserved.
//

import UIKit
import WebKit

class GFPurchaseWebViewController: GFBaseViewController,WKNavigationDelegate{
    
    var weburl:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paymentWebview = WKWebView()
        paymentWebview.frame  = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.view = paymentWebview
        paymentWebview.navigationDelegate = self
        
        let token:String = KeychainWrapper.standard.string(forKey: Constants.KeyChain.SecretKey)!
        let url =  self.weburl
        var request = URLRequest(url: URL.init(string: url!)!)
        request.setValue(String(format: "bearer %@", token), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Utilities.appCurrentVersion(), forHTTPHeaderField: "app_version")
        request.setValue("iOS", forHTTPHeaderField: "app_os")
        request.setValue(Utilities.deviceId(), forHTTPHeaderField: "DeviceId")
        paymentWebview.load(request)
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        paymentWebview.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: WKWebview Delegate Methods
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        
        let request = navigationAction.request
        let urlString = request.url?.absoluteString
        guard weburl != nil else{
            decisionHandler(WKNavigationActionPolicy.cancel);
            return
        }
        
        if ((urlString?.contains("coocoo://"))!) && ((urlString?.contains("ticketshome"))!) {
            navigationController?.popToRootViewController(animated: true)
        }
        
        decisionHandler(WKNavigationActionPolicy.allow);
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
        let urlString = webView.url?.absoluteString
        if (urlString?.contains("purchase/proxy_form"))!{
            //Do progress dialog
            self.attachSpinner(value: true)
            
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        self.attachSpinner(value: false)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        self.attachSpinner(value: false)
    }
    
}