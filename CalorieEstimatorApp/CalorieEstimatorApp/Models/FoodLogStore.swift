import SwiftUI

@MainActor
class FoodLogStore: ObservableObject {
    @Published var logs: [String: [FoodEntry]] = [
        "Breakfast": [],
        "Lunch": [],
        "Dinner": [],
        "Snacks": []
    ]

    func add(_ entry: FoodEntry, to meal: String) {
        logs[meal, default: []].append(entry)
    }
}
