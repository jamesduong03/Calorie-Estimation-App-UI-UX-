import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var showSignUp = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.mint.opacity(0.3), .green.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()

                    VStack(spacing: 10) {
                        Image(systemName: "leaf.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .foregroundColor(.green)
                            .shadow(radius: 6)
                        Text("Calorie Estimator")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }

                    VStack(spacing: 16) {
                        TextField("Email", text: $auth.email)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.none)

                        SecureField("Password", text: $auth.password)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)

                    Button {
                        auth.login()
                    } label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    .padding(.horizontal)

                    Button {
                        showSignUp = true
                    } label: {
                        Text("Create Account")
                            .foregroundColor(.green)
                            .font(.callout)
                    }

                    Spacer()
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}
