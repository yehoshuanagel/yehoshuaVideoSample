//
//  VideoTableViewCell.swift
//  VideoPlayerSample
//
//  Created by Yehoshua Nagel on 1/10/18.
//  Copyright © 2018 Yehoshua Nagel. All rights reserved.
//

import UIKit

protocol VideoTableViewCellDelegate : class {
    func playPauseButtonTapped(_ button: UIButton)
}

class VideoTableViewCell : UITableViewCell {
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    weak var delegate : VideoTableViewCellDelegate?
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        delegate?.playPauseButtonTapped(sender)
    }
    
}
