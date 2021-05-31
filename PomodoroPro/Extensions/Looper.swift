//
//  PlayIndefinitely.swift
//  PomodoroPro
//
//  Created by Ostap on 31.05.2021.
//

import AVKit

extension AVPlayer {
    func looper() -> AVPlayerLooper {
        seek(to: .zero)
        let item = self.currentItem
        let queuePlayer = AVQueuePlayer(playerItem: item)
        return AVPlayerLooper(player: queuePlayer, templateItem: item!)
    }
}
