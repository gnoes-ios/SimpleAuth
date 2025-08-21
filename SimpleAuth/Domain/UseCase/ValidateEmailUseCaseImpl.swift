final class ValidateEmailUseCaseImpl: ValidateEmailUseCase {
    private let validator: EmailValidator

    init(validator: EmailValidator = .init()) {
        self.validator = validator
    }

    func execute(_ email: String) throws {
        try validator.validate(email)
    }
}
