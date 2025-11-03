import SwiftUI

struct FoodLogView: View {
//    @State private var foodLogs: [String: [FoodEntry]] = [
//        "Breakfast": [], "Lunch": [], "Dinner": [], "Snacks": []
//    ]
    @EnvironmentObject var foodLogStore: FoodLogStore
    @State private var selectedMeal: String? = nil
    @State private var showAddOptions = false
    @State private var showAddFoodSheet = false
    @State private var goToCamera = false
    @State private var pendingMealFromCamera: FoodEntry? = nil

    var totalCalories: Int {
        foodLogStore.logs.values.flatMap { $0 }.reduce(0) { $0 + $1.calories }
    }
    var totalProtein: Int {
        foodLogStore.logs.values.flatMap { $0 }.reduce(0) { $0 + $1.protein }
    }
    var totalCarbs: Int {
        foodLogStore.logs.values.flatMap { $0 }.reduce(0) { $0 + $1.carbs }
    }
    var totalFat: Int {
        foodLogStore.logs.values.flatMap { $0 }.reduce(0) { $0 + $1.fat }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Daily Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Food Summary")
                            .font(.title2).fontWeight(.bold)
                        HStack(spacing: 20) {
                            NutrientSummary(title: "Calories", value: "\(totalCalories)", color: .orange)
                            NutrientSummary(title: "Protein", value: "\(totalProtein)g", color: .purple)
                            NutrientSummary(title: "Carbs", value: "\(totalCarbs)g", color: .blue)
                            NutrientSummary(title: "Fat", value: "\(totalFat)g", color: .pink)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 4)
                    .padding(.horizontal)

                    // All meal sections
                    ForEach(["Breakfast", "Lunch", "Dinner", "Snacks"], id: \.self) { meal in
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(meal)
                                    .font(.headline)
                                Spacer()
                                Button {
                                    selectedMeal = meal
                                    showAddOptions = true
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 22))
                                }
                            }

                            if let items = foodLogStore.logs[meal], !items.isEmpty {
                                ForEach(items) { food in
                                    FoodRow(food: food)
                                }
                            } else {
                                Text("No foods logged yet.")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.05), radius: 3)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Food Log")
            .confirmationDialog("Add Meal Entry", isPresented: $showAddOptions, titleVisibility: .visible) {
                Button("Use Camera") { goToCamera = true }
                Button("Manual Entry") { showAddFoodSheet = true }
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showAddFoodSheet) {
                if let meal = selectedMeal {
                    AddFoodSheet { newFood in
                        foodLogStore.add(newFood, to: meal)
                    }
                }
            }
            // Navigate to MealCameraView and receive data back
            .navigationDestination(isPresented: $goToCamera) {
                if let meal = selectedMeal {
                    MealCameraView(onMealCaptured: { name, calories, protein, carbs, fat in
                        let entry = FoodEntry(
                            name: name,
                            calories: calories,
                            protein: protein,
                            carbs: carbs,
                            fat: fat
                        )
                        foodLogStore.add(entry, to: meal)
                    })
                } else {
                    MealCameraView()
                }
            }
        }
    }
}

// MARK: - Data model
struct FoodEntry: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
}

// MARK: - Manual entry sheet
struct AddFoodSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    var onAdd: (FoodEntry) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Meal Info") {
                    TextField("Food name", text: $name)
                    TextField("Calories", text: $calories).keyboardType(.numberPad)
                    TextField("Protein (g)", text: $protein).keyboardType(.numberPad)
                    TextField("Carbs (g)", text: $carbs).keyboardType(.numberPad)
                    TextField("Fat (g)", text: $fat).keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Food")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let cal = Int(calories),
                              let pro = Int(protein),
                              let carb = Int(carbs),
                              let fa = Int(fat),
                              !name.isEmpty else { return }
                        let newFood = FoodEntry(name: name,
                                                calories: cal,
                                                protein: pro,
                                                carbs: carb,
                                                fat: fa)
                        onAdd(newFood)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - UI Components
struct FoodRow: View {
    let food: FoodEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(food.name).fontWeight(.semibold)
            HStack(spacing: 16) {
                Label("\(food.calories)", systemImage: "flame.fill").foregroundColor(.orange)
                Label("\(food.protein)g", systemImage: "bolt.fill").foregroundColor(.purple)
                Label("\(food.carbs)g", systemImage: "leaf.fill").foregroundColor(.blue)
                Label("\(food.fat)g", systemImage: "drop.fill").foregroundColor(.pink)
            }
            .font(.footnote)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2)
    }
}

struct NutrientSummary: View {
    let title: String
    let value: String
    let color: Color
    var body: some View {
        VStack {
            Text(title).font(.footnote).foregroundColor(.gray)
            Text(value).font(.headline).foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}
