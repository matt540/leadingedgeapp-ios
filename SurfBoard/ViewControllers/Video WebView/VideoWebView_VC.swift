//
//  VideoWebView_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 1/29/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import WebKit

class VideoWebView_VC: BaseViewController,WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    var StrURL:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setLeftBarBackItem()
        setTranspertNavigation()

        let mywkwebviewConfig = WKWebViewConfiguration()
        mywkwebviewConfig.allowsInlineMediaPlayback = true
        
        let myBlog = StrURL
        let url = NSURL(string: myBlog!)
        let request = NSURLRequest(url: url! as URL)
        
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
    }
    

    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        AppDelegate.shared().ShowSpinnerView()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        AppDelegate.shared().HideSpinnerView()
    }

}
