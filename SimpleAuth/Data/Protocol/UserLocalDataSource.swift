protocol UserLocalDataSource {
    func isEmailDuplicate(_ email: String) async throws -> Bool
    func insertUser(email: String, nickname: String, passwordHash: String) async throws -> UserMO
    func fetchUser(byEmail email: String) async throws -> UserMO?
    func deleteUser(byEmail email: String) async throws
}
