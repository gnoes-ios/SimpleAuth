final class WithdrawUseCaseImpl: WithdrawUseCase {
    private let userRepo: UserRepository
    private let session: SessionRepository

    init(userRepo: UserRepository, session: SessionRepository) {
        self.userRepo = userRepo
        self.session = session
    }

    func execute() async throws {
        guard let email = session.currentEmail else { throw DomainError.notLoggedIn }
        try await userRepo.deleteAccount(email: email)
        session.clear()
    }
}
