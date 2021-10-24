//
//  BackgroundTask.swift
//  PomodoroPro
//
//  Created by Ostap on 15.08.2021.
//

import Foundation
import AVKit

class BackgroundTask {
    var player = AVAudioPlayer()
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(interruptedAudio), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        playAudio()
    }
    
    func stop() {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
        player.stop()
    }
    
    @objc fileprivate func interruptedAudio(_ notification: Notification) {
        if notification.name == AVAudioSession.interruptionNotification && notification.userInfo != nil {
            let info = notification.userInfo!
            var intValue = 0
            (info[AVAudioSessionInterruptionTypeKey]! as AnyObject).getValue(&intValue)
            if intValue == 1 { playAudio() }
        }
    }
    
    func playAudio() {
        player.play()
    }
    
    init() {
        player = AVAudioPlayer.silence
        player.numberOfLoops = -1
    }
    
    deinit {
        stop()
    }
}
