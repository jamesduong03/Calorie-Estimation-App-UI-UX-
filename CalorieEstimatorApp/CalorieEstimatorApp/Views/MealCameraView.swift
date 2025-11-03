import SwiftUI
import AVFoundation
import PhotosUI
import SwiftData

enum MLMode: String, CaseIterable {
    case calories = "Calorie Estimation"
    case recipe = "Recipe Generation"
}

struct MealCameraView: View {
    @StateObject private var cameraModel = CameraViewModel()
    @Environment(\.modelContext) private var context
    @State private var showImagePicker = false
    @State private var selectedImage: Image?
    @State private var estimatedCalories: Int?
    @State private var nutrients: [String: String] = [:]
    @State private var isProcessing = false
    @State private var currentMode: MLMode = .calories
    @State private var generatedRecipes: [Recipe] = []
    var onMealCaptured: ((String, Int, Int, Int, Int) -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var showMealPicker = false
    @EnvironmentObject var foodLogStore: FoodLogStore
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Live camera feed
                CameraPreview(session: cameraModel.session)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Mode switcher at top
                    HStack {
                        Spacer()
                        Picker("Mode", selection: $currentMode) {
                            ForEach(MLMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 320)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    
                    Spacer()
                    
                    // Captured or uploaded preview
                    if let captured = cameraModel.capturedImage {
                        captured
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    } else if let uploaded = selectedImage {
                        uploaded
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    
                    // Dynamic output
                    if currentMode == .calories, let calories = estimatedCalories {
                        VStack(spacing: 10) {
                            ResultCard(calories: calories, nutrients: nutrients)
                                .transition(.opacity)

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
                                .background(Color.green.opacity(0.9))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    
                    if currentMode == .recipe, !generatedRecipes.isEmpty {
                        RecipeResultsView(recipes: generatedRecipes)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    // Capture + upload controls
                    ZStack {
                        // Capture button centered
                        Button {
                            cameraModel.capturePhoto()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                runModel()
                            }
                        } label: {
                            Circle()
                                .fill(Color.green.opacity(0.9))
                                .frame(width: 75, height: 75)
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                .shadow(radius: 5)
                        }
                        
                        // Upload button bottom-right
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    showImagePicker = true
                                } label: {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 26))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.black.opacity(0.4))
                                        .clipShape(Circle())
                                        .shadow(radius: 3)
                                }
                                .padding(.trailing, 25)
                                .padding(.bottom, 30)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 120)
                }
                
                // Processing overlay
                if isProcessing {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ProgressView(currentMode == .calories ? "Estimating Calories…" : "Generating Recipe…")
                        .tint(.green)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { cameraModel.configure() }
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(image: $selectedImage, onComplete: { runModel() })
            }
            .confirmationDialog("Add to which meal?", isPresented: $showMealPicker) {
                ForEach(["Breakfast", "Lunch", "Dinner", "Snacks"], id: \.self) { meal in
                    Button(meal) {
                        addToFoodLog(meal: meal)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    // MARK: - Mock Model Simulation
    private func runModel() {
        isProcessing = true
        estimatedCalories = nil
        nutrients = [:]
        generatedRecipes = []

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if currentMode == .calories {
                estimatedCalories = Int.random(in: 400...850)
                nutrients = [
                    "Protein": "\(Int.random(in: 15...40)) g",
                    "Carbohydrates": "\(Int.random(in: 40...90)) g",
                    "Fats": "\(Int.random(in: 10...30)) g"
                ]
            } else {
                generatedRecipes = [
                    Recipe(name: "Grilled Chicken Bowl", calories: 480, protein: 35, carbs: 42, fats: 18),
                    Recipe(name: "Chicken & Veg Stir-Fry", calories: 520, protein: 40, carbs: 50, fats: 15),
                    Recipe(name: "Avocado Rice Wrap", calories: 460, protein: 28, carbs: 48, fats: 17)
                ]
            }
            isProcessing = false
        }
    }

    
    private func addToFoodLog(meal: String) {
        if currentMode == .calories {
            guard let calories = estimatedCalories else { return }

            let protein = Int(nutrients["Protein"]?.replacingOccurrences(of: " g", with: "") ?? "0") ?? 0
            let carbs = Int(nutrients["Carbohydrates"]?.replacingOccurrences(of: " g", with: "") ?? "0") ?? 0
            let fat = Int(nutrients["Fats"]?.replacingOccurrences(of: " g", with: "") ?? "0") ?? 0

            let entry = FoodEntry(
                name: "Estimated Meal",
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat
            )
            foodLogStore.add(entry, to: meal)
            dismiss()
        }

        else if currentMode == .recipe, !generatedRecipes.isEmpty {
            // Add first generated recipe to Food Log
            let recipe = generatedRecipes.first!
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
}
