//
//  VideoManager.swift
//  VideoPlayerSample
//
//  Created by Yehoshua Nagel on 1/10/18.
//  Copyright © 2018 Yehoshua Nagel. All rights reserved.
//

import Foundation
import AVKit

protocol VideoManagerDelegate {
    func currentlyPlayingVideoChanged(newVideo : Int?)
}

struct VideoManager {
    private var players : [AVPlayer] = []
    
    public var currentlyPlaying : Int? {
        willSet {
            if currentlyPlaying != newValue {
                delegate?.currentlyPlayingVideoChanged(newVideo: newValue)
            }
        }
    }
    
    var numberOfVideos = 3
    var delegate : VideoManagerDelegate?
    
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
    
    public func add(videoNumber index : Int, toView view : UIView) {
        if let playerLayers = view.layer.sublayers?.filter({$0 is AVPlayerLayer}),
            playerLayers.count > 0 {
            return
        }
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: players[index])
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.sublayers?.filter{ $0 is AVPlayerLayer }.forEach{ $0.removeFromSuperlayer() }
        view.layer.addSublayer(layer)
    }
    
    public mutating func playPause(videoNumber index : Int) {
        let player = players[index]
        if player.isPlaying {
            player.pause()
            currentlyPlaying = nil
        } else {
            play(videoNumber: index)
        }
    }
    
    public mutating func play(videoNumber index : Int) {
        let player = players[index]
        players.forEach({ (eachPlayer) in
            if eachPlayer == player {
                eachPlayer.play()
                currentlyPlaying = index
            } else {
                eachPlayer.pause()
            }
        })
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

