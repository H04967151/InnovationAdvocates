//
//  PostDetailViewController.swift
//  InnovationAdvocates
//
//  Created by Neil on 19/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import SDWebImage

class PostDetailViewController: UIViewController {
    
    var username = String()
    var date = Date()
    var content = String()
    var image = String()
    var profileImage = String()
    let colorArray = [UIColor(named: "Red"), UIColor(named: "Grey"), UIColor(named: "Blue"), UIColor(named: "Green"), UIColor(named: "Yellow")]
    var tap = false
    
    
    @IBOutlet weak var dismissBtnView: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyContentLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var contentBottomConstraint: NSLayoutConstraint!
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)

    

    override func viewDidLoad() {
        super.viewDidLoad()
        if image != "nil" {
            tapGestureInit()
        }
        runStyles()
    }
    
    func tapGestureInit(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        tap = !self.tap
        if tap == true{
            UIView.animate(withDuration: 0.3) {
                self.dismissBtnView.layer.opacity = 0
                self.usernameLabel.layer.opacity = 0
                self.dateLabel.layer.opacity = 0
                self.bodyContentLabel.layer.opacity = 0
                self.profileImageView.layer.opacity = 0
            }
            
        }else{
            UIView.animate(withDuration: 0.3) {
                self.dismissBtnView.layer.opacity = 1
                self.usernameLabel.layer.opacity = 1
                self.dateLabel.layer.opacity = 1
                self.bodyContentLabel.layer.opacity = 1
                self.profileImageView.layer.opacity = 1
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func runStyles(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd - H:mm"
        let dateString = formatter.string(from: date)
        dismissBtnView.layer.cornerRadius = dismissBtnView.frame.height / 2
        dismissBtnView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        let randomIndex = Int(arc4random_uniform(UInt32(colorArray.count)))
        let bgColor = colorArray[randomIndex]
        self.view.backgroundColor = bgColor
        usernameLabel.text = username
        dateLabel.text = "June 18"
        bodyContentLabel.text = content
        dateLabel.text = dateString
        profileImageView.sd_setImage(with: URL(string: profileImage), completed: nil)
        
        if image != "nil" {
            postImageView.sd_setImage(with: URL(string: image), completed: nil)
            contentBottomConstraint.constant = 32
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
            gradientLayer.locations = [0.6, 1 ]
            gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.bounds.height + 25)
            postImageView.layer.addSublayer(gradientLayer)
            
            if let postImage = postImageView.image{
                if Int((postImage.size.height)) > Int((postImage.size.width)) {
                    postImageView.contentMode = .scaleAspectFill
                }
            }
           
        }else{
            contentBottomConstraint.constant = 250
        }
            self.view.layoutIfNeeded()
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        if sender.state == UIGestureRecognizerState.began{
            initialTouchPoint = touchPoint
        }else if sender.state == UIGestureRecognizerState.changed{
            if touchPoint.y - initialTouchPoint.y > 0{
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.width, height: self.view.frame.height)
                let opacity = ((self.view.frame.height - self.view.frame.minY) / self.view.frame.height)
                self.view.layer.opacity = Float(opacity + 0.4)
            }
            
        }else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled{
            if touchPoint.y - initialTouchPoint.y > 100{
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
        
    }

    @IBAction func dismiisViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
