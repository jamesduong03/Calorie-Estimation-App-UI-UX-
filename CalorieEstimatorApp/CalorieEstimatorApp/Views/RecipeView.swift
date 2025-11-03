//import SwiftUI
//import SwiftData
//import Combine
//
//struct RecipeView: View {
//    @Environment(\.modelContext) private var context
//    @EnvironmentObject var dataObserver: DataObserver
//
//    @State private var searchText = ""
//    @State private var recipes: [Recipe] = []
//    @State private var isLoading = false
//    @State private var showingSaved = true
//    @State private var storedRecipes: [RecipeModel] = []
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                // Toggle between saved and search
//                Picker("Mode", selection: $showingSaved) {
//                    Text("Saved Recipes").tag(true)
//                    Text("Search").tag(false)
//                }
//                .pickerStyle(.segmented)
//                .padding(.horizontal)
//
//                if showingSaved {
//                    // Persistent recipes
//                    if storedRecipes.isEmpty {
//                        Spacer()
//                        VStack(spacing: 12) {
//                            Image(systemName: "book.closed")
//                                .font(.system(size: 60))
//                                .foregroundColor(.green.opacity(0.7))
//                            Text("No saved recipes yet.")
//                                .foregroundColor(.gray)
//                        }
//                        Spacer()
//                    } else {
//                        List(storedRecipes) { recipe in
//                            NavigationLink(destination: RecipeDetailStoredView(recipe: recipe)) {
//                                HStack {
//                                    Image(systemName: "fork.knife.circle.fill")
//                                        .foregroundColor(.green)
//                                    VStack(alignment: .leading) {
//                                        Text(recipe.name)
//                                            .fontWeight(.semibold)
//                                        Text("\(recipe.calories) kcal")
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
//                                    }
//                                }
//                            }
//                        }
//                        .listStyle(.insetGrouped)
//                    }
//                } else {
//                    // Manual search
//                    HStack {
//                        TextField("Enter ingredient (e.g. chicken)", text: $searchText)
//                            .textFieldStyle(.roundedBorder)
//                        Button {
//                            searchRecipes()
//                        } label: {
//                            Image(systemName: "magnifyingglass.circle.fill")
//                                .font(.system(size: 28))
//                                .foregroundColor(.green)
//                        }
//                    }
//                    .padding(.horizontal)
//
//                    if isLoading {
//                        ProgressView("Finding Recipes…")
//                            .padding()
//                    }
//
//                    List(recipes) { recipe in
//                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
//                            HStack {
//                                Image(systemName: "fork.knife.circle.fill")
//                                    .foregroundColor(.green)
//                                VStack(alignment: .leading) {
//                                    Text(recipe.name)
//                                        .fontWeight(.semibold)
//                                    Text("\(recipe.calories) kcal")
//                                        .foregroundColor(.gray)
//                                        .font(.subheadline)
//                                }
//                            }
//                        }
//                    }
//                    .listStyle(.insetGrouped)
//                }
//            }
//            .navigationTitle("Recipes")
//        }
//        .onAppear(perform: loadStoredRecipes)
//        .onChange(of: dataObserver.refreshTrigger) { _ in
//            loadStoredRecipes()
//        }
//        .onChange(of: showingSaved) { newValue in
//            if newValue {
//                loadStoredRecipes()
//            }
//        }
//    }
//
//    // MARK: - Mock Search Logic
//    private func searchRecipes() {
//        guard !searchText.isEmpty else { return }
//        isLoading = true
//        recipes.removeAll()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
//            recipes = [
//                Recipe(name: "\(searchText.capitalized) Power Bowl", calories: 480, protein: 35, carbs: 42, fats: 18),
//                Recipe(name: "\(searchText.capitalized) Stir-Fry", calories: 520, protein: 40, carbs: 50, fats: 15),
//                Recipe(name: "\(searchText.capitalized) Wrap", calories: 460, protein: 28, carbs: 48, fats: 17)
//            ]
//            isLoading = false
//        }
//    }
//
//    private func loadStoredRecipes() {
//        let descriptor = FetchDescriptor<RecipeModel>(
//            sortBy: [SortDescriptor(\RecipeModel.date, order: .reverse)]
//        )
//        storedRecipes = (try? context.fetch(descriptor)) ?? []
//    }
//}

import SwiftUI
import SwiftData

struct RecipeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \RecipeModel.date, order: .reverse) private var savedRecipes: [RecipeModel]

    @State private var searchText = ""
    @State private var recipes: [Recipe] = []
    @State private var isLoading = false
    @State private var showingSaved = true

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Mode", selection: $showingSaved) {
                    Text("Saved Recipes").tag(true)
                    Text("Search").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if showingSaved {
                    if savedRecipes.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 60))
                                .foregroundColor(.green.opacity(0.7))
                            Text("No saved recipes yet.")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    } else {
                        List(savedRecipes) { r in
                            NavigationLink(destination: RecipeDetailStoredView(recipe: r).modelContext(context)) {
                                HStack {
                                    Image(systemName: "fork.knife.circle.fill")
                                        .foregroundColor(.green)
                                    VStack(alignment: .leading) {
                                        Text(r.name).fontWeight(.semibold)
                                        Text("\(r.calories) kcal")
                                            .font(.subheadline).foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                } else {
                    HStack {
                        TextField("Enter ingredient (e.g. chicken)", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                        Button { searchRecipes() } label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.system(size: 28)).foregroundColor(.green)
                        }
                    }
                    .padding(.horizontal)

                    if isLoading { ProgressView("Finding Recipes…").padding() }

                    List(recipes) { r in
                        NavigationLink(destination: RecipeDetailView(recipe: r).modelContext(context)) {
                            HStack {
                                Image(systemName: "fork.knife.circle.fill").foregroundColor(.green)
                                VStack(alignment: .leading) {
                                    Text(r.name).fontWeight(.semibold)
                                    Text("\(r.calories) kcal").font(.subheadline).foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Recipes")
        }
    }

    private func searchRecipes() {
        guard !searchText.isEmpty else { return }
        isLoading = true
        recipes.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            recipes = [
                Recipe(name: "\(searchText.capitalized) Power Bowl", calories: 480, protein: 35, carbs: 42, fats: 18),
                Recipe(name: "\(searchText.capitalized) Stir-Fry", calories: 520, protein: 40, carbs: 50, fats: 15),
                Recipe(name: "\(searchText.capitalized) Wrap", calories: 460, protein: 28, carbs: 48, fats: 17)
            ]
            isLoading = false
        }
    }
}
