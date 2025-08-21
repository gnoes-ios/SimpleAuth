import Foundation

final class UserRepositoryImpl: UserRepository {
    private let local: UserLocalDataSource

    init(local: UserLocalDataSource) {
        self.local = local
    }

    func checkDuplicateEmail(_ email: String) async throws -> Bool {
        try await local.isEmailDuplicate(email)
    }

    func signUp(email: String, nickname: String, password: String) async throws -> User {
        let hash = PasswordHasher.hash(password)
        let userMO = try await local.insertUser(email: email, nickname: nickname, passwordHash: hash)
        return try toEntity(userMO)
    }

    func getUser(byEmail email: String) async throws -> User {
        let userMO = try await local.fetchUser(byEmail: email)
        return try toEntity(userMO)
    }

    func deleteAccount(email: String) async throws {
        try await local.deleteUser(byEmail: email)
    }
}

private extension UserRepositoryImpl {
    func toEntity(_ mo: UserMO?) throws -> User {
        guard let mo else { throw AuthError.userNotFound }

        return User(
            id: mo.id,
            email: mo.email,
            nickname: mo.nickname,
            createdAt: mo.createdAt
        )
    }
}
