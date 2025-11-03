import SwiftUI
import SwiftData

struct RecipeDetailStoredView: View {
    let recipe: RecipeModel

    var body: some View {
        VStack(spacing: 24) {
            Text(recipe.name)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            VStack(spacing: 8) {
                Text("Calories: \(recipe.calories) kcal")
                    .font(.headline)
                    .foregroundColor(.green)
                HStack {
                    Label("\(recipe.protein)g Protein", systemImage: "bolt.fill")
                        .foregroundColor(.blue)
                    Label("\(recipe.carbs)g Carbs", systemImage: "leaf.fill")
                        .foregroundColor(.mint)
                    Label("\(recipe.fats)g Fat", systemImage: "drop.fill")
                        .foregroundColor(.pink)
                }
                .font(.subheadline)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
