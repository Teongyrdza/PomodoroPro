//
//  TimePicker.swift
//  PomodoroPro
//
//  Created by Ostap on 05.04.2021.
//

import SwiftUI

class TimePickerView: UIPickerView {
    let width: CGFloat
    
    override var intrinsicContentSize: CGSize {
        .init(width: width, height: super.intrinsicContentSize.height)
    }
    
    init(width: CGFloat) {
        self.width = width
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct TimePickerRepresentable: UIViewRepresentable {
    typealias RangeType = ClosedRange
    
    @Binding var selection: Time
    let range: RangeType<Time>
    let shownComponents: [TimeComponent]
    let size: CGSize
    
    func numberOfComponents() -> Int {
        shownComponents.count * 2 // values plus labels
    }
    
    func makeUIView(context: Context) -> TimePickerView {
        let picker = TimePickerView(width: size.width)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: TimePickerView, context: Context) {
        for (index, component) in shownComponents.enumerated() {
            uiView.selectRow(selection[component], inComponent: index * 2, animated: false)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    init(
        selection: Binding<Time>,
        in range: RangeType<Time>,
        shownComponents: [TimeComponent],
        size: CGSize
    ) {
        self._selection = selection
        self.range = range
        self.shownComponents = shownComponents
        self.size = size
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: TimePickerRepresentable

        init(parent: TimePickerRepresentable) {
            self.parent = parent
        }
        
        func isLabel(_ column: Int) -> Bool {
            column == 1 || column == 3 || column == 5
        }

        //numberOfComponents(in:)
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return parent.numberOfComponents()
        }

        //pickerView(_:numberOfRowsInComponent:)
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent column: Int) -> Int {
            if isLabel(column) {
                return 1
            }
            
            let timeComponent = self.timeComponent(for: column)
            let lowerBound = parent.range.lowerBound[timeComponent]
            let upperBound = parent.range.upperBound[timeComponent] + 1
            return upperBound - lowerBound
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return parent.size.width / CGFloat(parent.numberOfComponents())
        }
        
        func title(for component: TimeComponent) -> String {
            switch component {
                case .hours:
                    let hours = parent.selection[.hours]
                    if hours == 1 {
                        return "hour"
                    }
                    return "hours"
                case .minutes:
                    return "min"
                case .seconds:
                    return "sec"
            }
        }

        func title(for column: Int) -> String {
            switch column {
                case 1:
                    return title(for: parent.shownComponents[0])
                case 3:
                    return title(for: parent.shownComponents[1])
                case 5:
                    return title(for: parent.shownComponents[2])
                default:
                    fatalError()
            }
        }
        
        func timeComponent(for column: Int) -> TimeComponent {
            switch column {
                case 0:
                    return parent.shownComponents[0]
                case 2:
                    return parent.shownComponents[1]
                case 4:
                    return parent.shownComponents[2]
                default:
                    fatalError()
            }
        }
        
        //pickerView(_:titleForRow:forComponent:)
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if isLabel(component) {
                return title(for: component)
            }
            return "\(row)"
        }
        
        //pickerView(_:didSelectRow:inComponent:)
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent column: Int) {
            if isLabel(column) {
                return
            }
            let timeComponent = timeComponent(for: column)
            parent.selection[timeComponent] = row
            pickerView.reloadComponent(column + 1) // Reload title
        }
    }
}

struct TimePicker: View {
    typealias RangeType = ClosedRange
    
    @Binding var selection: Time
    let range: RangeType<Time>
    
    var body: some View {
        GeometryReader { geo in
            TimePickerRepresentable(
                selection: $selection,
                in: range,
                shownComponents: [.minutes, .seconds],
                size: geo.size
            )
        }
    }
    
    init(selection: Binding<Time>, in range: RangeType<Time>) {
        self._selection = selection
        self.range = range
    }
}

#if DEBUG
struct TimePicker_Previews: PreviewProvider {
    @State static var time = Time(2, 35, 6)
    
    static var previews: some View {
        TimePicker(selection: $time, in: Time(0, 0, 0)...Time(3, 59, 30))
    }
 }
#endif
