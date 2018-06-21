//
//  SecondViewController.swift
//  InnovationAdvocates
//
//  Created by Neil on 14/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import SVProgressHUD

class VideoFeedController: UITableViewController {

    let cellID = "VideoFeedCell"
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"VideoFeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        Network.shared.retrieveVideos { (returnedVideos) in
            self.videos = returnedVideos
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
        title = "Videos"
        tabBarController?.tabBar.barTintColor = UIColor(named: "Red")
        navigationController?.navigationBar.barTintColor = UIColor(named: "Red")
    }
    
}

extension VideoFeedController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let videoCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! VideoFeedTableViewCell
        let video = videos.reversed()[indexPath.row]
        videoCell.thumbnailImageView.sd_setImage(with: URL(string: video.thumbnailURL!), completed: nil)
        videoCell.videoTitleLabel.text = video.title
        
        return videoCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos.reversed()[indexPath.row]
        let videoURL = URL(string: video.videoURL! )
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

}

