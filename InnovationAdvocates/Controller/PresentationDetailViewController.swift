//
//  PresentationDetailViewController.swift
//  InnovationAdvocates
//
//  Created by Neil on 21/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import Foundation
import WebKit
import SVProgressHUD

class PresentationDetailViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    
    var url = String()
    
    @IBOutlet weak var dismissButtonView: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.load(URLRequest(url:
            URL(string: url)!))
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.delegate = self
        runStyles()
    }
        
    func runStyles(){
        dismissButtonView.layer.cornerRadius = dismissButtonView.frame.height / 2
        dismissButtonView.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            SVProgressHUD.showProgress(Float(webView.estimatedProgress), status: "Loading...")
            if webView.estimatedProgress == 1 {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.1) {
            self.dismissButtonView.layer.opacity = 0
            self.dismissButtonView.isUserInteractionEnabled = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseIn, animations: {
            self.dismissButtonView.layer.opacity = 1
            self.dismissButtonView.isUserInteractionEnabled = true
        }, completion: nil)
    }


    @IBAction func dismissViewButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    
    
    

}
