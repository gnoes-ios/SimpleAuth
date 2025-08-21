protocol FetchCurrentUserUseCase {
    func execute() async throws -> User
}
