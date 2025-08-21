protocol UserRepository {
    func checkDuplicateEmail(_ email: String) async throws -> Bool
    func signUp(email: String, nickname: String, password: String) async throws -> User
    func getUser(byEmail email: String) async throws -> User
    func deleteAccount(email: String) async throws
}
