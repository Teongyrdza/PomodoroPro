//
//  WheelPicker.swift
//  PomodoroPro
//
//  Created by Ostap on 09.04.2021.
//

import SwiftUI

struct WheelPicker<SelectionValue: Hashable, Content: View>: UIViewRepresentable {
    @Binding var selection: SelectionValue
    let content: Content
    
    // MARK: - Helpers
    var contentMirror: Mirror {
        return Mirror(reflecting: content)
    }
    
    var blocksCount: Int {
        return Mirror(reflecting: contentMirror.descendant("value")!).children.count
    }
    
    func row(for tag: SelectionValue) -> Int {
        for i in 0..<blocksCount {
            let tupleBlock = contentMirror.descendant("value", ".\(i)")
            let currentTag = Mirror(reflecting: tupleBlock!).descendant("modifier", "value", "tagged") as! SelectionValue
            if tag == currentTag {
                return i
            }
        }
        return 0
    }
    
    func tag(of row: Int) -> SelectionValue {
        let tupleBlock = contentMirror.descendant("value", ".\(row)")
        let tag = Mirror(reflecting: tupleBlock!).descendant("modifier", "value", "tagged") as! SelectionValue
        
        return tag
    }
    
    func view(for row: Int) -> Text {
        let tupleBlock = contentMirror.descendant("value", ".\(row)")
        let text = Mirror(reflecting: tupleBlock!).descendant("content") as! Text
        
        return text
    }
    
    // MARK: - Representable methods
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        uiView.selectRow(row(for: selection), inComponent: 0, animated: false)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    init(selection: Binding<SelectionValue>, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: WheelPicker

        init(parent: WheelPicker) {
            self.parent = parent
        }
        //numberOfComponents(in:)
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        //pickerView(_:numberOfRowsInComponent:)
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent column: Int) -> Int {
            return parent.blocksCount
        }

        //pickerView(_:viewForRow:forComponent:)
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let text = parent.view(for: row)
            
            return UIHostingController(rootView: text).view
        }

        //pickerView(_:didSelectRow:inComponent:)
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent column: Int) {
            let tag = parent.tag(of: row)
            
            parent.selection = tag
        }
    }
}

#if DEBUG
struct WheelPicker_Previews: PreviewProvider {
    @State static var selection = 0
    
    static var previews: some View {
        VStack {
            Text("Selection is \(selection)")
            
            WheelPicker(selection: $selection) {
                Text("0").tag(0)
                Text("1").tag(1)
                Text("2").tag(2)
                Text("3").tag(3)
                Text("4").tag(4)
                Text("5").tag(5)
                Text("6").tag(6)
                Text("7").tag(7)
                Text("8").tag(8)
                Text("9").tag(9)
            }
        }
    }
}
#endif
