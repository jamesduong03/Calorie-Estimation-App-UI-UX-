import SwiftUI

struct RecipeResultsView: View {
    let recipes: [Recipe]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Suggested Recipes")
                .font(.headline)
                .foregroundColor(.green)

            ForEach(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    HStack {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .fontWeight(.semibold)
                            Text("\(recipe.calories) kcal")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
        }
    }
}
