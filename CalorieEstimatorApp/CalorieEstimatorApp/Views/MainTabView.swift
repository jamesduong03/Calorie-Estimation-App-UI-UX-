import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            RecipeView()
                .tabItem {
                    Label("Recipes", systemImage: "book.closed.fill")
                }
            
            MealCameraView()
                .tabItem {
                    Label("Camera", systemImage: "camera.fill")
                }

            FoodLogView()
                .tabItem {
                    Label("Log", systemImage: "target")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }

            UserProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .tint(.green)
    }
}

