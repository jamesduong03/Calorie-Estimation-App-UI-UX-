import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .foregroundColor(.green.opacity(0.9))
                    .shadow(radius: 5)

                Text(auth.user?.name ?? "User")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(auth.user?.email ?? "")
                    .foregroundColor(.gray)

                Button {
                    auth.logout()
                } label: {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

