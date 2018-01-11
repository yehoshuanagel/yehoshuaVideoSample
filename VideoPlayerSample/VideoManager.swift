//
//  VideoManager.swift
//  VideoPlayerSample
//
//  Created by Yehoshua Nagel on 1/10/18.
//  Copyright © 2018 Yehoshua Nagel. All rights reserved.
//

import Foundation
import AVKit

protocol VideoManagerDelegate : class {
    func currentlyPlayingVideoChanged(newVideoIndex : Int?, previouslyPlayingIndex : Int?)
}

class VideoManager {
    private var players : [AVPlayer] = []
    
    public private(set) var currentlyPlaying : Int? {
        willSet {
            if currentlyPlaying != newValue {
                delegate?.currentlyPlayingVideoChanged(newVideoIndex: newValue, previouslyPlayingIndex: currentlyPlaying)
            }
        }
    }
    
    let numberOfVideos = 3
    weak var delegate : VideoManagerDelegate?
    
    init() {
        for index in 0..<numberOfVideos {
            guard let path = Bundle.main.path(forResource: "video\(index + 1)", ofType:"MOV") else {
                debugPrint("video\(index + 1).mov not found")
                return
            }
            
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                player.seek(to: kCMTimeZero)
                player.play()
            }
            
            players.append(player)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func add(videoNumber index : Int, toView view : UIView) {
        if let playerLayers = view.layer.sublayers?.filter({$0 is AVPlayerLayer}),
            playerLayers.count > 0 {
            return
        }
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: players[index])
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
    }
    
    public func playPause(videoNumber index : Int) {
        let player = players[index]
        if player.isPlaying {
            player.pause()
            currentlyPlaying = nil
        } else {
            play(videoNumber: index)
        }
    }
    
    public func play(videoNumber index : Int) {
        if index != currentlyPlaying {
            if let toPause = currentlyPlaying {
                players[toPause].pause()
            }
            players[index].play()
            currentlyPlaying = index
        }
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

