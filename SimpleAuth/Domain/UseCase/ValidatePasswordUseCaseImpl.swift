final class ValidatePasswordUseCaseImpl: ValidatePasswordUseCase {
    private let validator: PasswordValidator

    init(validator: PasswordValidator = .init()) {
        self.validator = validator
    }

    func execute(_ password: String, confirm: String?) throws {
        try validator.validate(password, confirm: confirm)
    }
}
