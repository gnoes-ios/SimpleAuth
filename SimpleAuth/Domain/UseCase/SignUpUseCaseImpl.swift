struct SignUpUseCaseImpl: SignUpUseCase {
    private let userRepo: UserRepository
    private let session: SessionRepository
    private let emailValidator: EmailValidator
    private let passwordValidator: PasswordValidator

    init(
        userRepo: UserRepository,
        session: SessionRepository,
        emailValidator: EmailValidator = .init(),
        passwordValidator: PasswordValidator = .init()
    ) {
        self.userRepo = userRepo
        self.session = session
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
    }

    func execute(email: String, password: String, confirm: String, nickname: String) async throws -> User {
        try emailValidator.validate(email)
        try passwordValidator.validate(password, confirm: confirm)

        if try await userRepo.checkDuplicateEmail(email) {
            throw SignUpError.duplicateEmail
        }

        let user = try await userRepo.signUp(email: email, nickname: nickname, password: password)
        session.setLoggedIn(email)
        return user
    }
}
