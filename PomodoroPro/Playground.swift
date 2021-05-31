//
//  Playground.swift
//  PomodoroPro
//
//  Created by Ostap on 25.10.2020.
//

import SwiftUI
/*
struct Playground: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        let angle = Double(geo.frame(in: .global).minY / 5)
                        
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(width: fullView.size.width)
                            .background(self.colors[index % 7])
                            .rotationEffect(.degrees(angle), anchor: .center)
                            //.offset(x: 0, y: geo.size.width * cos(angle - 5))
                            .offset(x: 0, y: geo.size.width * cos((angle - 5) / 57))
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

#if DEBUG
struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground()
    }
}
 #endif
*/
