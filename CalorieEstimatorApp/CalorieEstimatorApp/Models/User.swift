import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    var email: String
    var name: String
}

