import SwiftUI

struct ResultCard: View {
    let calories: Int
    let nutrients: [String: String]

    var body: some View {
        VStack(spacing: 12) {
            Text("Estimated Calories")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("\(calories) kcal")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.green)

            ForEach(nutrients.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    Text(value)
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}
