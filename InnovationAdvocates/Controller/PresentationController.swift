//
//  SecondViewController.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import SVProgressHUD

class PresentationController: UITableViewController{
    
    let cellID = "PresentationCell"
    var presentations = [Presentation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"PresentationTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        Network.shared.retrievePresentations { (returnedPresentations) in
            self.presentations = returnedPresentations
            self.tableView.reloadData()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runStyles()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if SVProgressHUD.isVisible(){
            SVProgressHUD.dismiss()
        }
    }
    
    func runStyles(){
        title = "Presentations"
        tabBarController?.tabBar.barTintColor = UIColor(named: "Yellow")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Yellow")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let presentationCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PresentationTableViewCell
        let presentation = presentations[indexPath.row]
        presentationCell.presentation = presentation
        
        return presentationCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentation = presentations[indexPath.row]
        
        let url = presentation.url
        if let vc = storyboard?.instantiateViewController(withIdentifier: "webView") as? PresentationDetailViewController {
            vc.url = url!
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}


