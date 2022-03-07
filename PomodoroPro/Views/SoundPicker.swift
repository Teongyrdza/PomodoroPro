//
//  SoundPicker.swift
//  PomodoroPro
//
//  Created by Ostap on 31.05.2021.
//

import SwiftUI
import AVKit

class PickerModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var playing = false
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playing = false
    }
}

struct SoundPicker: View {
    static let sounds = [
        Sound(named: "Beep"),
        Sound(named: "Ding"),
        Sound(named: "Chimes"),
        Sound(named: "Meditation bell"),
        Sound(named: "Deep bell"),
        Sound(named: "Large gong"),
        Sound(named: "Japanese bell"),
        Sound(named: "Medieval bell"),
        Sound(named: "Small bell jingling"),
        Sound(named: "Noah bells")
    ]
    
    @Binding var selection: Sound
    @StateObject var model = PickerModel()
    
    var player: AVAudioPlayer {
        selection.player
    }
    
    func stopSound() {
        player.stop()
        model.playing = false
    }
    
    var body: some View {
        List {
            ForEach(Self.sounds) { sound in
                Button {
                    if selection != sound {
                        stopSound()
                        selection = sound
                    }
                    
                    if model.playing {
                        stopSound()
                    }
                    else {
                        model.playing = true
                        player.delegate = model
                        player.currentTime = .zero
                        player.play()
                    }
                } label: {
                    Text(sound.description)
                        .foregroundColor(.primary)
                }
                .if(selection == sound)
                .listRowBackground(Color.accentColor)
                .endif()
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Sound")
    }
}

#if DEBUG
struct SoundPicker_Previews: PreviewProvider {
    @State static var sound = Sound(named: "Beep")
    
    static var previews: some View {
        NavigationView {
            SoundPicker(selection: $sound)
        }
        .navigationViewStyle(.stack)
    }
}
#endif
