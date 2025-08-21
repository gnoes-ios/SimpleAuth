import Foundation

struct User: Hashable {
    let id: UUID
    let email: String
    var nickname: String
    let createdAt: Date
}
