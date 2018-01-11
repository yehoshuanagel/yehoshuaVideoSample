//
//  VideoTableViewCell.swift
//  VideoPlayerSample
//
//  Created by Yehoshua Nagel on 1/10/18.
//  Copyright © 2018 Yehoshua Nagel. All rights reserved.
//

import UIKit

protocol VideoTableViewCellDelegate : class {
    func playPauseButtonTapped(cellRow: Int?)
}

class VideoTableViewCell : UITableViewCell {
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    weak var delegate : VideoTableViewCellDelegate?
    var cellRow : Int?
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        delegate?.playPauseButtonTapped(cellRow: cellRow)
    }
    
}
