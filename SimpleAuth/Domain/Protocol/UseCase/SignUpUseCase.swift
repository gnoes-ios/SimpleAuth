protocol SignUpUseCase {
    func execute(email: String, password: String, confirm: String, nickname: String) async throws -> User
}
