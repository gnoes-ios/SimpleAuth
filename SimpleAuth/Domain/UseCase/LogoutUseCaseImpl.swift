final class LogoutUseCaseImpl: LogoutUseCase {
    private let session: SessionRepository

    init(session: SessionRepository) {
        self.session = session
    }

    func execute() {
        session.clear()
    }
}
