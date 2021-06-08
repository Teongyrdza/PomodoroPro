//
//  PomodoroView.swift
//  PomodoroPro
//
//  Created by Ostap on 24.10.2020.
//

import SwiftUI
import StarUI
import Foundation
import AVKit

struct PomodoroView: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    
    var body: some View {
        VStack {
            ZStack {
                ProgressView(value: viewModel.progresssValue)
                    .progressViewStyle(CircularProgressViewStyle(thickness: 30))
                
                Text(viewModel.progressText)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Button("Cancel") {
                    viewModel.leftButtonTapped()
                }
                .frame(width: 90)
                .accentColor(.gray)
                
                Spacer()
                
                Button(viewModel.rightButtonText) {
                    viewModel.rightButtonTapped()
                }
                .accentColor(viewModel.rightButtonColor)
                .frame(width: 90)
            }
            .buttonStyle(RoundedCornersButtonStyle())
            .frame(height: 50)
        }
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: scenePhase) { phase in
            viewModel.scenePhase(changedTo: phase)
        }
    }
}

#if DEBUG
struct PomodoroView_Previews: PreviewProvider {
    @StateObject static var timerSettings = TimerSettings()
    
    static var previews: some View {
        PomodoroView(viewModel: .init(settings: timerSettings, showing: .constant(true)))
    }
}
#endif

