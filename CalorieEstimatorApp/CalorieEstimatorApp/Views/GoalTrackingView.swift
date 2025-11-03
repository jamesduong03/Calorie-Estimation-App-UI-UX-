import SwiftUI

struct GoalTrackingView: View {
    @EnvironmentObject var auth: AuthViewModel

    // Main goals
    @State private var calorieGoal = 2500
    @State private var caloriesConsumed = 1620
    @State private var weightGoal = 70.0
    @State private var currentWeight = 73.5
    @State private var mealsGoal = 3
    @State private var mealsCompleted = 2

    // Macronutrient goals
    @State private var proteinGoal = 150
    @State private var proteinConsumed = 90
    @State private var fatGoal = 70
    @State private var fatConsumed = 40
    @State private var carbGoal = 300
    @State private var carbConsumed = 180

    // Computed progress values
    private var caloriesProgress: Double { Double(caloriesConsumed) / Double(calorieGoal) }
    private var weightProgress: Double { max(0, min(1, 1 - (currentWeight - weightGoal) / 10)) }
    private var mealsProgress: Double { Double(mealsCompleted) / Double(mealsGoal) }
    private var proteinProgress: Double { Double(proteinConsumed) / Double(proteinGoal) }
    private var fatProgress: Double { Double(fatConsumed) / Double(fatGoal) }
    private var carbProgress: Double { Double(carbConsumed) / Double(carbGoal) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                // Header
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Goal Tracking")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Hi, \(auth.user?.name ?? "User")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "target")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)

                // Calorie Goal
                GoalCard(
                    title: "Calorie Goal",
                    subtitle: "\(caloriesConsumed) / \(calorieGoal) kcal",
                    progress: caloriesProgress,
                    icon: "flame.fill",
                    color: .orange
                )

                // Macronutrient Breakdown
                VStack(alignment: .leading, spacing: 16) {
                    Text("Macronutrients")
                        .font(.headline)
                        .padding(.horizontal)

                    MacroGoalRow(
                        name: "Protein",
                        consumed: proteinConsumed,
                        goal: proteinGoal,
                        color: .purple
                    )

                    MacroGoalRow(
                        name: "Fat",
                        consumed: fatConsumed,
                        goal: fatGoal,
                        color: .pink
                    )

                    MacroGoalRow(
                        name: "Carbs",
                        consumed: carbConsumed,
                        goal: carbGoal,
                        color: .blue
                    )
                }
                .padding(.vertical, 6)

                // Weight Goal
                GoalCard(
                    title: "Weight Goal",
                    subtitle: String(format: "%.1f / %.1f kg", currentWeight, weightGoal),
                    progress: weightProgress,
                    icon: "scalemass.fill",
                    color: .blue
                )

                // Meals Goal
                GoalCard(
                    title: "Meals Today",
                    subtitle: "\(mealsCompleted) / \(mealsGoal) meals",
                    progress: mealsProgress,
                    icon: "fork.knife.circle.fill",
                    color: .green
                )

                // Add new goal button
                Button {
                    // Future: open goal editing screen
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Goal")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// Reusable Goal Progress Card
struct GoalCard: View {
    let title: String
    let subtitle: String
    let progress: Double
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }

            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .scaleEffect(x: 1, y: 3, anchor: .center)
                .animation(.easeInOut(duration: 0.6), value: progress)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}

// Macronutrient progress row
struct MacroGoalRow: View {
    let name: String
    let consumed: Int
    let goal: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(name)
                    .font(.subheadline)
                Spacer()
                Text("\(consumed) / \(goal) g")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            ProgressView(value: Double(consumed) / Double(goal))
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .animation(.easeInOut(duration: 0.5), value: consumed)
        }
        .padding(.horizontal)
    }
}

