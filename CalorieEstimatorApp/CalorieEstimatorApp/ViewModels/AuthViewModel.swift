import Foundation

final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""

    func login() {
        guard !email.isEmpty, !password.isEmpty else { return }
        user = User(email: email, name: "James")
        isAuthenticated = true
    }

    func signUp() {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else { return }
        user = User(email: email, name: name)
        isAuthenticated = true
    }

    func logout() {
        user = nil
        isAuthenticated = false
        email = ""
        password = ""
        name = ""
    }
}
