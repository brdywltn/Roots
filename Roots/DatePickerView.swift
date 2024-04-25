//
//  DatePickerView.swift
//  Roots
//
//  Created by Brody Wilton on 28/03/2024.
//

import SwiftUI
import CoreData

struct DatePickerView: View {
    var plant: Plant
    var dateType: PlantDetailView.DateType
    var context: NSManagedObjectContext

    @Environment(\.dismiss) var dismiss

    var body: some View {
        // Example DatePicker content
        DatePicker("Select Date", selection: Binding<Date>(
            get: {
                switch dateType {
                case .lastWatered:
                    return plant.lastWateredDate ?? Date()
                case .lastFed:
                    return plant.lastFedDate ?? Date()
                }
            },
            set: { newValue in
                switch dateType {
                case .lastWatered:
                    plant.lastWateredDate = newValue
                    plant.timesWatered += 1
                case .lastFed:
                    plant.lastFedDate = newValue
                    plant.timesFed += 1
                }
                try? context.save()
                dismiss()
            }), displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .background {
                Color.softLimeGreen.ignoresSafeArea()
            }
    }
}
