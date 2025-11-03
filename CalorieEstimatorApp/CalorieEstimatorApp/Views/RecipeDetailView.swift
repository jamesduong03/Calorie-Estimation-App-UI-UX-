//import SwiftUI
//import SwiftData
//
//struct RecipeDetailView: View {
//    let recipe: Recipe
//    var onAddToFoodLog: ((FoodEntry, String) -> Void)? = nil
//
//    @Environment(\.modelContext) private var context
//    @Environment(\.dismiss) private var dismiss
//    @State private var saved = false
//    @State private var errorText: String?
//    @State private var showMealPicker = false
//
//    var body: some View {
//        VStack(spacing: 24) {
//            // Recipe header
//            Text(recipe.name)
//                .font(.title)
//                .fontWeight(.semibold)
//
//            VStack(spacing: 8) {
//                Text("Calories: \(recipe.calories) kcal")
//                    .font(.headline)
//                    .foregroundColor(.green)
//
//                HStack {
//                    Text("\(recipe.protein)g Protein")
//                    Text("\(recipe.carbs)g Carbs")
//                    Text("\(recipe.fats)g Fat")
//                }
//                .font(.subheadline)
//            }
//
//            Spacer()
//
//            // Add to saved recipes
//            Button(saved ? "Added to Recipes" : "Add to Recipes") {
//                addRecipe()
//            }
//            .disabled(saved)
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(saved ? Color.gray.opacity(0.4) : Color.green.opacity(0.9))
//            .foregroundColor(.white)
//            .cornerRadius(12)
//
//            // Add to Food Log
//            Button {
//                showMealPicker = true
//            } label: {
//                HStack {
//                    Image(systemName: "plus.circle.fill")
//                    Text("Add to Food Log")
//                        .fontWeight(.semibold)
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.blue.opacity(0.9))
//                .foregroundColor(.white)
//                .cornerRadius(12)
//            }
//            .padding(.top, 8)
//
//            if let errorText {
//                Text(errorText)
//                    .foregroundColor(.red)
//                    .font(.footnote)
//            }
//
//            Spacer()
//        }
//        .padding()
//        .navigationTitle("Recipe Details")
//        .navigationBarTitleDisplayMode(.inline)
//        .confirmationDialog("Add to which meal?", isPresented: $showMealPicker) {
//            ForEach(["Breakfast", "Lunch", "Dinner", "Snacks"], id: \.self) { meal in
//                Button(meal) {
//                    addRecipeToFoodLog(meal: meal)
//                }
//            }
//            Button("Cancel", role: .cancel) {}
//        }
//    }
//
//    private func addRecipe() {
//        let newRecipe = RecipeModel(
//            name: recipe.name,
//            calories: recipe.calories,
//            protein: recipe.protein,
//            carbs: recipe.carbs,
//            fats: recipe.fats
//        )
//        context.insert(newRecipe)
//        try? context.save()
//        saved = true
//    }
//
//    private func addRecipeToFoodLog(meal: String) {
//        let entry = FoodEntry(
//            name: recipe.name,
//            calories: recipe.calories,
//            protein: recipe.protein,
//            carbs: recipe.carbs,
//            fat: recipe.fats
//        )
//        onAddToFoodLog?(entry, meal)
//        dismiss()
//    }
//}

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.modelContext) private var context
    @EnvironmentObject var foodLogStore: FoodLogStore
    @Environment(\.dismiss) private var dismiss

    @State private var saved = false
    @State private var errorText: String?
    @State private var showMealPicker = false

    var body: some View {
        VStack(spacing: 24) {
            Text(recipe.name)
                .font(.title)
                .fontWeight(.semibold)

            VStack(spacing: 8) {
                Text("Calories: \(recipe.calories) kcal")
                    .font(.headline)
                    .foregroundColor(.green)
                HStack {
                    Text("\(recipe.protein)g Protein")
                    Text("\(recipe.carbs)g Carbs")
                    Text("\(recipe.fats)g Fat")
                }
                .font(.subheadline)
            }

            Spacer()

            // Save to SwiftData
            Button(saved ? "Added to Recipes" : "Add to Recipes") {
                addRecipe()
            }
            .disabled(saved)
            .frame(maxWidth: .infinity)
            .padding()
            .background(saved ? Color.gray.opacity(0.4) : Color.green.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(12)

            // Add to Food Log
            Button {
                showMealPicker = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add to Food Log")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.top, 8)

            if let errorText {
                Text(errorText)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Add to which meal?", isPresented: $showMealPicker) {
            ForEach(["Breakfast", "Lunch", "Dinner", "Snacks"], id: \.self) { meal in
                Button(meal) {
                    addRecipeToFoodLog(meal: meal)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func addRecipe() {
        let newRecipe = RecipeModel(
            name: recipe.name,
            calories: recipe.calories,
            protein: recipe.protein,
            carbs: recipe.carbs,
            fats: recipe.fats
        )
        context.insert(newRecipe)
        do {
            try context.save()
            saved = true
            errorText = nil
        } catch {
            errorText = "Save failed. \(error.localizedDescription)"
        }
    }

    private func addRecipeToFoodLog(meal: String) {
        let entry = FoodEntry(
            name: recipe.name,
            calories: recipe.calories,
            protein: recipe.protein,
            carbs: recipe.carbs,
            fat: recipe.fats
        )
        foodLogStore.add(entry, to: meal)
        dismiss()
    }
}

