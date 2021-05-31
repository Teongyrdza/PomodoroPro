//
//  FSPicker.swift
//  PomodoroPro
//
//  Created by Ostap on 09.04.2021.
//

import SwiftUI

struct FSPicker<SelectionValue: Hashable, Content: View>: View {
    @Namespace var ns
    @Binding var selection: SelectionValue
    let content: Content

    var body: some View {
        let contentMirror = Mirror(reflecting: content)
        let blocksCount = Mirror(reflecting: contentMirror.descendant("value")!).children.count // How many children?
        HStack {
            ForEach(0..<blocksCount) { index in
                let tupleBlock = contentMirror.descendant("value", ".\(index)")
                let text = Mirror(reflecting: tupleBlock!).descendant("content") as! Text
                let tag = Mirror(reflecting: tupleBlock!).descendant("modifier", "value", "tagged") as! SelectionValue

                Button {
                  selection = tag
                } label: {
                  text
                    .padding(.vertical, 16)
                }
                .background(
                  Group {
                    if tag == selection {
                      Color.purple.frame(height: 2)
                        .matchedGeometryEffect(id: "selector", in: ns)
                    }
                  },
                  alignment: .bottom
                )
                .accentColor(tag == selection ? .purple : .black)
                .animation(.easeInOut)
            }
        }
    }
    
    init(selection: Binding<SelectionValue>, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content()
    }
}

#if DEBUG
struct FSPicker_Previews: PreviewProvider {
    @State static var selection = 0
    
    static var previews: some View {
        FSPicker(selection: $selection) {
            Text("first").tag(0)
            Text("second").tag(1)
            Text("third").tag(2)
        }
    }
}
#endif
