import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \RecipeModel.date, order: .reverse) private var savedRecipes: [RecipeModel]
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            if savedRecipes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock")
                        .font(.system(size: 50))
                        .foregroundColor(.green.opacity(0.7))
                    Text("No saved recipes yet.")
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                List(savedRecipes) { recipe in
                    HStack {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .fontWeight(.semibold)
                            Text("\(recipe.calories) kcal")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(Self.dateString(recipe.date))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("History")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            for item in savedRecipes {
                                context.delete(item)
                            }
                            try? context.save()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }

    static func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .none
        return f.string(from: date)
    }
}
