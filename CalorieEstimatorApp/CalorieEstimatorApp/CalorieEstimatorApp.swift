//import SwiftUI
//
//@main
//struct CalorieEstimatorApp: App {
//    @StateObject private var authViewModel = AuthViewModel()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(authViewModel)
//                .modelContainer(for: RecipeModel.self)
//        }
//    }
//}
//

//import SwiftUI
//import SwiftData
//
//@main
//struct CalorieEstimatorApp: App {
//    @StateObject private var authViewModel = AuthViewModel()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentViewWrapper()
//                .environmentObject(authViewModel)
//                .modelContainer(for: RecipeModel.self)
//        }
//    }
//}
//
//struct ContentViewWrapper: View {
//    @Environment(\.modelContext) private var context
//    @StateObject private var dataObserver: DataObserver
//
//    init() {
//        // StateObject must be initialized in the init() of the View
//        _dataObserver = StateObject(wrappedValue: DataObserver())
//    }
//
//    var body: some View {
//        ContentView()
//            .environmentObject(dataObserver)
//            .onAppear {
//                dataObserver.startObserving(context: context)
//            }
//    }
//}

import SwiftUI
import SwiftData

@main
struct CalorieEstimatorApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var foodLogStore = FoodLogStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .modelContainer(for: [RecipeModel.self])   // one container, app-wide
                .environmentObject(foodLogStore)
        }
    }
}

