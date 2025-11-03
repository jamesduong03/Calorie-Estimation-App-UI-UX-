import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        ZStack {
            LinearGradient(colors: [.green.opacity(0.1), .mint.opacity(0.3)], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Spacer()

                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .foregroundColor(.green)
                        .shadow(radius: 4)

                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }

                VStack(spacing: 16) {
                    TextField("Full Name", text: $auth.name)
                        .textFieldStyle(.roundedBorder)

                    TextField("Email", text: $auth.email)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)

                    SecureField("Password", text: $auth.password)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)

                Button {
                    auth.signUp()
                } label: {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}
