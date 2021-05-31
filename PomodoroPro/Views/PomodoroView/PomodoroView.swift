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
    
    var body: some View {
        VStack {
            ZStack {
                ProgressView(value: viewModel.progresssValue)
                    .progressViewStyle(CircularProgressViewStyle(thickness: 30))
                
                Text(viewModel.progressText)
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
            .buttonStyle(RoundedButtonStyle())
            .frame(height: 50)
        }
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#if DEBUG
struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(viewModel: .init(pomodoroTime: 30, breakTime: 5, showing: .constant(true)))
    }
}
#endif

