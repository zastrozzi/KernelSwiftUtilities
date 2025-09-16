//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/08/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

@available(iOS 17.0, macOS 14.0, *)
public struct CalendarDateInputView: View {
    @KernelDI.Injected(\.inputService) var inputService
    @Binding var selectedDate: Date?
    @Binding var before: Date?
    @Binding var after: Date?
    @Binding var isEditing: Bool
    var onEditingChanged: (Bool) -> Void
    var inputTouched: () -> Void = {}
    var label: String
    var tintColor: Color
    @State private var canSubmit: Bool = false
    
    public init(label: String, tintColor: Color, selectedDate: Binding<Date?>, before: Binding<Date?>, after: Binding<Date?>, isEditing: Binding<Bool>, editingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.label = label
        self._selectedDate = selectedDate
        self._isEditing = isEditing
        self.onEditingChanged = editingChanged
        self._before = before
        self._after = after
        self.tintColor = tintColor
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                if (selectedDate != nil && !isEditing) {
                    VStack(alignment: .leading) {
                        Text(label).font(.caption).fontWeight(.bold).foregroundStyle(Color.tertiaryLabel)
                        HStack {
                            Image(systemName: "calendar")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(tintColor)
                            Text(inputText).foregroundStyle(Color.label)
                        }.font(.title3).fixedSize(horizontal: true, vertical: false)
                    }.onTapGesture { setIsEditing(true) }.padding([.horizontal, .bottom], 10).padding(.top, 5)
                }
                Spacer()
            }
            if selectedDate == nil || isEditing {
                DatePicker(label, selection: datePickerBinding, in: inputRange.wrappedValue, displayedComponents: .date)
                    .datePickerStyle(.graphical).padding(.horizontal, 5)
            }
        }
        .tint(tintColor)
        .padding(5).background(Color.quaternarySystemFill)
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .padding(.horizontal)
        .onChange(of: isEditing, { oldValue, newValue in
            if oldValue != newValue { setIsEditing(newValue) }
        })
        .transition(
            .asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing)
            ).combined(with: .opacity)
        )
    }
    
    var inputText: String {
        guard let selectedDate else { return "Choose a date" }
        if selectedDate.startOfDay == .now.startOfDay { return "Today" }
        if selectedDate.startOfDay == Calendar.current.date(byAdding: .day, value: -1, to: .now.startOfDay) { return "Yesterday" }
        if selectedDate.startOfDay == Calendar.current.date(byAdding: .day, value: 1, to: .now.startOfDay) { return "Tomorrow" }
        return selectedDate.formatted(date: .long, time: .omitted)
    }
    
    var datePickerBinding: Binding<Date> {
        .init(
            get: { selectedDate ?? .init() },
            set: { newValue in
                withAnimation(.smooth) {
                    selectedDate = newValue
                    if isEditing != true {
                        isEditing = true
                        onEditingChanged(true)
                    }
                }
                updateInputCanSubmit()
            }
        )
    }
    
    func updateInputCanSubmit() {
        let canSubmitChange = selectedDate != nil
        canSubmit = canSubmitChange
        inputService.setCurrentInputCanSubmit(canSubmit)
    }
    
    func resetDate() {
        withAnimation(.smooth) {
            selectedDate = nil
            isEditing = true
            onEditingChanged(true)
        }
    }
    
    func setIsEditing(_ val: Bool) {
        withAnimation(.smooth) {
            isEditing = val
            onEditingChanged(val)
        }
    }
    
    var inputRange: Binding<ClosedRange<Date>> {
        .init(get: {
            .init(uncheckedBounds: (lower: after ?? .distantPast, upper: before ?? .distantFuture))
        }, set: { _ in })
    }
}
