//
//  SoundPicker.swift
//  PomodoroPro
//
//  Created by Ostap on 31.05.2021.
//

import SwiftUI
import AVKit

struct SoundPicker: View {
    static let sounds = [
        Sound(named: "beep", description: "Beep"),
        Sound(named: "ding", description: "Ding"),
        Sound(named: "meditationBell", description: "Meditation Bell")
    ]
    
    @Binding var selection: Sound
    @State var isPlaying = false
    
    var player: AVAudioPlayer {
        selection.player
    }
    
    var body: some View {
        List {
            ForEach(Self.sounds) { sound in
                Text(sound.description)
                    .onTapGesture {
                        // Stop previous sound, if playing
                        if isPlaying {
                            isPlaying = false
                            player.pause()
                        }
                        
                        if selection != sound || !isPlaying {
                            selection = sound
                            isPlaying = true
                            player.currentTime = .zero
                            player.play()
                        }
                    }
                    .if(selection == sound)
                    .listRowBackground(Color.accentColor.opacity(0.8))
                    .endif()
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Sound")
    }
}

#if DEBUG
struct SoundPicker_Previews: PreviewProvider {
    @State static var sound = Sound(named: "beep", description: "Beep")
    
    static var previews: some View {
        NavigationView {
            SoundPicker(selection: $sound)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
#endif
