//
//  EventDetailViewController.swift
//  InnovationAdvocates
//
//  Created by Neil on 20/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD

class EventDetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var descriptionLabelView: UILabel!
    @IBOutlet weak var startTimeLabelView: UILabel!
    @IBOutlet weak var attendBtnView: UIButton!
    @IBOutlet weak var dismissBtnView: UIButton!
    @IBOutlet weak var QRCodeView: UIImageView!
    
    var eventTitle = String()
    var eventDescription = String()
    var date = Date()
    var startTime = Date()
    var endTime = Date()
    var key = String()
    var isAttending = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runStyles()
        isAttendingEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if SVProgressHUD.isVisible(){
            SVProgressHUD.dismiss()
        }
    }
    
    func isAttendingEvent(){
        
        if isAttending == true {
            attendBtnView.setTitle("TICKET RESERVED", for: .normal)
            attendBtnView.backgroundColor = UIColor(named: "Green")
            attendBtnView.layer.opacity = 0.7
            attendBtnView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
            attendBtnView.layer.borderWidth = 1
            view.backgroundColor = UIColor(named: "Green")
            titleLabelView.textColor = UIColor(white: 1, alpha: 1)
            descriptionLabelView.textColor = UIColor(white: 1, alpha: 1)
            startTimeLabelView.textColor = UIColor(white: 1, alpha: 1)
            attendBtnView.isEnabled = false
            createQRCode(key: (Network.currentUser?.uid)!)
            self.view.layoutIfNeeded()
        }else{
            attendBtnView.setTitle("ATTEND", for: .normal)
            attendBtnView.backgroundColor = UIColor(named: "Green")
            attendBtnView.isEnabled = true
        }
    }

    

        func runStyles(){
            let formatter = DateFormatter()
            let timeFormatter = DateFormatter()
            formatter.dateFormat = "MMMM dd - h:mma"
            timeFormatter.dateFormat = "h:mma"
            let startDateString = formatter.string(from: startTime)
            let endDateString = timeFormatter.string(from: (endTime))
            attendBtnView.layer.cornerRadius = attendBtnView.frame.height / 2
            titleLabelView.text = eventTitle
            descriptionLabelView.text = eventDescription
            startTimeLabelView.text = "\(startDateString) to \(endDateString)"
            dismissBtnView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            dismissBtnView.layer.cornerRadius = dismissBtnView.bounds.height / 2
        }
    
        @IBAction func attendEvent(_ sender: UIButton) {
            Network.shared.attendEvent(key: key, view: self) { (completed) in
                if completed == true {
                    self.isAttending = true
                    self.isAttendingEvent()
                    self.runStyles()
                }
            }
        }
    
    func createQRCode(key: String){
        var filter:CIFilter
        let data = key.data(using: .ascii, allowLossyConversion: false)
        filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(data, forKey: "inputMessage")
        let image = UIImage(ciImage: filter.outputImage!.transformed(by: CGAffineTransform(scaleX: 20, y: 20)))
        QRCodeView.image = image
    }
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        dismiss(animated: true) {

        }
    }
}





















