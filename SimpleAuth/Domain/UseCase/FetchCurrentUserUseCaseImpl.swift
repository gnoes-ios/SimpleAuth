final class FetchCurrentUserUseCaseImpl: FetchCurrentUserUseCase {
    private let userRepo: UserRepository
    private let session: SessionRepository

    init(userRepo: UserRepository, session: SessionRepository) {
        self.userRepo = userRepo
        self.session = session
    }

    func execute() async throws -> User {
        guard let email = session.currentEmail else { throw DomainError.notLoggedIn }
        return try await userRepo.getUser(byEmail: email)
    }
}
