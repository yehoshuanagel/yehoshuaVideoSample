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
    
    private let videoManager = VideoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videosTableView.reloadData()
    }
    
    //VideoManagerDelegate
    func currentlyPlayingVideoChanged(newVideoIndex : Int?, previouslyPlayingIndex : Int?) {
        if let row = previouslyPlayingIndex, let cell = videosTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? VideoTableViewCell {
            cell.playPauseButton.isSelected = false
        }
        if let row = newVideoIndex, let cell = videosTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? VideoTableViewCell {
            cell.playPauseButton.isSelected = true
        }
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoManager.numberOfVideos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as? VideoTableViewCell {
            cell.cellTitleLabel.text = "Video number: \(indexPath.row + 1)"
            cell.cellRow = indexPath.row
            
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
        videoManager.play(videoNumber: indexPath.row)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var shortestDistanceToMidpoint : CGFloat = self.view.frame.height
        var mostCentralRow : Int?
        videosTableView.indexPathsForVisibleRows?.forEach({ (indexPath) in
            let rectOfCell = videosTableView.rectForRow(at: indexPath)
            let cellMidPoint = videosTableView.convert(rectOfCell, to: videosTableView.superview).midY
            
            let distance = abs(videosTableView.frame.midY - cellMidPoint)
            if distance < shortestDistanceToMidpoint {
                shortestDistanceToMidpoint = distance
                mostCentralRow = indexPath.row
            }
        })
        
        if let row = mostCentralRow {
            videoManager.play(videoNumber: row)
        }
    }
    
    //VideoTableViewCellDelegate
    func playPauseButtonTapped(cellRow : Int?) {
        if let row = cellRow {
            videoManager.playPause(videoNumber: row)
        }
    }
}
