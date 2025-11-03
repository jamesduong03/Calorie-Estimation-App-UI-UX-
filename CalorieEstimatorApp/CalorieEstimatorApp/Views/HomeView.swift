//import SwiftUI
//
//struct HomeView: View {
//    @EnvironmentObject var auth: AuthViewModel
//    @EnvironmentObject var foodLogStore: FoodLogStore
//
//    // Daily stats
//    @State private var mealsToday = 0
//    @State private var scansTaken = 0
//    @State private var recipesSaved = 0
//
//    // Goal tracking
//    @State private var weightGoal = 70.0
//    @State private var currentWeight = 73.5
//    @State private var proteinGoal = 150
//    @State private var proteinConsumed = 90
//    @State private var fatGoal = 70
//    @State private var fatConsumed = 40
//    @State private var carbGoal = 300
//    @State private var carbConsumed = 180
//    @State private var calorieGoal = 2500
//
//    // Computed values
//    private var totalCalories: Int {
//        foodLogStore.logs.values.flatMap { $0 }.reduce(0) { $0 + $1.calories }
//    }
//
//    private var caloriesRemaining: Int {
//        max(calorieGoal - totalCalories, 0)
//    }
//
//    private var caloriesProgress: Double {
//        guard calorieGoal > 0 else { return 0 }
//        return min(Double(totalCalories) / Double(calorieGoal), 1.0)
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 32) {
//
//                // Welcome header
//                VStack(spacing: 20) {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Welcome,")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                            Text(auth.user?.name ?? "User")
//                                .font(.title)
//                                .fontWeight(.semibold)
//                        }
//                        Spacer()
//                        Image(systemName: "leaf.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50)
//                            .foregroundColor(.green)
//                    }
//                }
//                .padding(.horizontal)
//
//                // CALORIE RING CARD
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Daily Calorie Summary")
//                        .font(.title2)
//                        .fontWeight(.bold)
//
//                    HStack {
//                        Spacer()
//                        ZStack {
//                            Circle()
//                                .stroke(Color.gray.opacity(0.15), lineWidth: 20)
//                                .frame(width: 240, height: 240)
//
//                            Circle()
//                                .trim(from: 0, to: CGFloat(caloriesProgress))
//                                .stroke(
//                                    AngularGradient(
//                                        gradient: Gradient(colors: [.green, .blue]),
//                                        center: .center
//                                    ),
//                                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
//                                )
//                                .rotationEffect(.degrees(-90))
//                                .frame(width: 240, height: 240)
//                                .animation(.easeInOut(duration: 0.8), value: totalCalories)
//
//                            VStack {
//                                Text("\(caloriesRemaining)")
//                                    .font(.system(size: 42, weight: .bold))
//                                Text("Remaining")
//                                    .font(.footnote)
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        Spacer()
//                    }
//
//                    HStack(spacing: 24) {
//                        MetricView(icon: "flag.fill", label: "Goal", value: "\(calorieGoal)", color: .gray)
//                        MetricView(icon: "flame.fill", label: "Consumed", value: "\(totalCalories)", color: .orange)
//                        MetricView(icon: "arrow.down.circle.fill", label: "Remaining", value: "\(caloriesRemaining)", color: .blue)
//                    }
//                    .padding(.top, 12)
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.white)
//                .cornerRadius(20)
//                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
//                .padding(.horizontal)
//
//                // QUICK STATS
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Quick Stats")
//                        .font(.headline)
//                        .padding(.horizontal)
//
//                    HStack(spacing: 12) {
//                        StatCard(title: "Meals Logged", value: "\(foodLogStore.logs.values.flatMap { $0 }.count)", icon: "fork.knife.circle.fill", color: .green)
//                        StatCard(title: "Scans Taken", value: "\(scansTaken)", icon: "camera.fill", color: .blue)
//                        StatCard(title: "Recipes Saved", value: "\(recipesSaved)", icon: "book.fill", color: .orange)
//                    }
//                    .padding(.horizontal)
//                }
//            }
//            .padding(.vertical)
//        }
//        .background(Color(.systemGroupedBackground))
//    }
//}
//
//// MARK: - Subviews
//struct MetricView: View {
//    let icon: String
//    let label: String
//    let value: String
//    let color: Color
//
//    var body: some View {
//        VStack(spacing: 6) {
//            Image(systemName: icon)
//                .foregroundColor(color)
//                .font(.system(size: 20))
//            Text(label)
//                .font(.footnote)
//                .foregroundColor(.gray)
//            Text(value)
//                .fontWeight(.semibold)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//
//struct StatCard: View {
//    let title: String
//    let value: String
//    let icon: String
//    let color: Color
//
//    var body: some View {
//        VStack(spacing: 8) {
//            Image(systemName: icon)
//                .font(.system(size: 26))
//                .foregroundColor(color)
//            Text(value)
//                .font(.title2)
//                .fontWeight(.semibold)
//            Text(title)
//                .font(.footnote)
//                .foregroundColor(.gray)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(Color.white)
//        .cornerRadius(14)
//        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//    }
//}
//
//struct DashboardGoalCard: View {
//    let title: String
//    let subtitle: String
//    let progress: Double
//    let icon: String
//    let color: Color
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Image(systemName: icon)
//                    .font(.system(size: 32))
//                    .foregroundColor(color)
//                VStack(alignment: .leading) {
//                    Text(title)
//                        .font(.headline)
//                    Text(subtitle)
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//                Spacer()
//            }
//
//            ProgressView(value: progress)
//                .progressViewStyle(LinearProgressViewStyle(tint: color))
//                .scaleEffect(x: 1, y: 3, anchor: .center)
//                .animation(.easeInOut(duration: 0.6), value: progress)
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(Color.white)
//        .cornerRadius(18)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
//        .padding(.horizontal)
//    }
//}
//
//struct DashboardMacroRow: View {
//    let name: String
//    let consumed: Int
//    let goal: Int
//    let color: Color
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            HStack {
//                Text(name)
//                    .font(.subheadline)
//                Spacer()
//                Text("\(consumed) / \(goal) g")
//                    .font(.footnote)
//                    .foregroundColor(.gray)
//            }
//            ProgressView(value: Double(consumed) / Double(goal))
//                .progressViewStyle(LinearProgressViewStyle(tint: color))
//                .scaleEffect(x: 1, y: 2, anchor: .center)
//                .animation(.easeInOut(duration: 0.5), value: consumed)
//        }
//        .padding(.horizontal)
//    }
//}

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var foodLogStore: FoodLogStore

    // Quick stats
    @State private var mealsToday = 0
    @State private var scansTaken = 0
    @State private var recipesSaved = 0

    // Goals
    @State private var calorieGoal = 2500
    @State private var showEditGoalSheet = false

    // MARK: - Computed values
    private var totalCalories: Int {
        foodLogStore.logs.values.flatMap { $0 }.reduce(0) { $0 + $1.calories }
    }

    private var caloriesRemaining: Int {
        max(calorieGoal - totalCalories, 0)
    }

    private var caloriesProgress: Double {
        guard calorieGoal > 0 else { return 0 }
        return min(Double(totalCalories) / Double(calorieGoal), 1.0)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                // Welcome header
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome,")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(auth.user?.name ?? "User")
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        Image(systemName: "leaf.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)

                // CALORIE RING CARD
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Daily Calorie Summary")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            showEditGoalSheet = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.blue)
                        }
                        .accessibilityLabel("Edit calorie goal")
                    }

                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.15), lineWidth: 20)
                                .frame(width: 240, height: 240)

                            Circle()
                                .trim(from: 0, to: CGFloat(caloriesProgress))
                                .stroke(
                                    AngularGradient(
                                        gradient: Gradient(colors: [.green, .blue]),
                                        center: .center
                                    ),
                                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .frame(width: 240, height: 240)
                                .animation(.easeInOut(duration: 0.8), value: totalCalories)

                            VStack {
                                Text("\(caloriesRemaining)")
                                    .font(.system(size: 42, weight: .bold))
                                Text("Remaining")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                    }

                    HStack(spacing: 24) {
                        MetricView(icon: "flag.fill", label: "Goal", value: "\(calorieGoal)", color: .gray)
                        MetricView(icon: "flame.fill", label: "Consumed", value: "\(totalCalories)", color: .orange)
                        MetricView(icon: "arrow.down.circle.fill", label: "Remaining", value: "\(caloriesRemaining)", color: .blue)
                    }
                    .padding(.top, 12)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                .padding(.horizontal)

                // QUICK STATS
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Stats")
                        .font(.headline)
                        .padding(.horizontal)

                    HStack(spacing: 12) {
                        StatCard(title: "Meals Logged", value: "\(foodLogStore.logs.values.flatMap { $0 }.count)", icon: "fork.knife.circle.fill", color: .green)
                        StatCard(title: "Scans Taken", value: "\(scansTaken)", icon: "camera.fill", color: .blue)
                        StatCard(title: "Recipes Saved", value: "\(recipesSaved)", icon: "book.fill", color: .orange)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showEditGoalSheet) {
            EditCalorieGoalView(currentGoal: $calorieGoal)
                .presentationDetents([.fraction(0.25)])
        }
    }
}

// MARK: - Subviews
struct MetricView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 20))
            Text(label)
                .font(.footnote)
                .foregroundColor(.gray)
            Text(value)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundColor(color)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct DashboardGoalCard: View {
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

struct DashboardMacroRow: View {
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

struct EditCalorieGoalView: View {
    @Binding var currentGoal: Int
    @Environment(\.dismiss) private var dismiss
    @State private var tempGoal: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Edit Calorie Goal")
                .font(.headline)
                .padding(.top)

            TextField("Enter new goal", text: $tempGoal)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Save") {
                if let newGoal = Int(tempGoal), newGoal > 0 {
                    currentGoal = newGoal
                }
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()
        }
        .onAppear { tempGoal = "\(currentGoal)" }
    }
}
