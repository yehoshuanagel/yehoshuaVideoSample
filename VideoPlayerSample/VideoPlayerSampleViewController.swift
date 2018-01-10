//
//  VideoPlayerSampleViewController.swift
//  VideoPlayerSample
//
//  Created by Yehoshua Nagel on 1/9/18.
//  Copyright © 2018 Yehoshua Nagel. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerSampleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoTableViewCellDelegate, VideoManagerDelegate {
    @IBOutlet weak var videosTableView: UITableView!
    
    var numberOfVideos : Int!
    
    let videoManager = VideoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoManager.delegate = self
        numberOfVideos = videoManager.numberOfVideos
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videosTableView.reloadData()
    }
    
    //VideoManagerDelegate
    func currentlyPlayingVideoChanged(newVideo : Int?) {
        for row in 0..<numberOfVideos {
            if let cell = videosTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? VideoTableViewCell {
                cell.playPauseButton.isSelected = (newVideo == row)
            }
        }
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfVideos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as? VideoTableViewCell {
            cell.cellTitleLabel.text = "Video number: \(indexPath.row + 1)"
            
            videoManager.add(videoNumber: indexPath.row, toView: cell.videoPlayerView)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var greatestHeight : CGFloat = 0
        var mostVisibleRow : Int?
        for indexPath in videosTableView.indexPathsForVisibleRows ?? [] {
            let cellRect = videosTableView.rectForRow(at: indexPath)
            let visibleHeight = abs(videosTableView.bounds.intersection(cellRect).size.height)
            if visibleHeight > greatestHeight {
                greatestHeight = visibleHeight
                mostVisibleRow = indexPath.row
            }
        }
        if let row = mostVisibleRow {
            videoManager.play(videoNumber: row)
        }
    }
    
    //VideoTableViewCellDelegate
    func playPauseButtonTapped(_ button: UIButton) {
        if let cell = button.superview?.superview as? UITableViewCell {
            if let row = videosTableView.indexPath(for: cell)?.row {
                videoManager.playPause(videoNumber: row)
            }
        }
    }

}
