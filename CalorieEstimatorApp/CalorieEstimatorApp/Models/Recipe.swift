import Foundation

struct Recipe: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fats: Int
}
