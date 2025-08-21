final class CheckLoginStatusUseCaseImpl: CheckLoginStatusUseCase {
    private let session: SessionRepository

    init(session: SessionRepository) {
        self.session = session
    }

    func execute() -> Bool {
        session.isLoggedIn
    }
}
