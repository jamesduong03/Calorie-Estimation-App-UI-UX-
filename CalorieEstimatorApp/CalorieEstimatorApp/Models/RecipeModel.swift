//import Foundation
//import SwiftData
//
//@Model
//final class RecipeModel {
//    var id: UUID
//    var name: String
//    var calories: Int
//    var protein: Int
//    var carbs: Int
//    var fats: Int
//    var date: Date
//
//    init(name: String, calories: Int, protein: Int, carbs: Int, fats: Int) {
//        self.id = UUID()
//        self.name = name
//        self.calories = calories
//        self.protein = protein
//        self.carbs = carbs
//        self.fats = fats
//        self.date = Date()
//    }
//}

import Foundation
import SwiftData

@Model
final class RecipeModel {
    var id: UUID
    var name: String
    var calories: Int
    var protein: Int
    var carbs: Int
    var fats: Int
    var date: Date

    init(name: String, calories: Int, protein: Int, carbs: Int, fats: Int) {
        self.id = UUID()
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.date = Date()
    }
}
