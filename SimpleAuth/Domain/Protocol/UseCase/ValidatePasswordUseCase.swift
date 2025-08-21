protocol ValidatePasswordUseCase {
    func execute(_ password: String, confirm: String?) throws
}
