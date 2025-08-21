enum ValidationError: Error {
    case invalidEmail(String)
    case invalidPassword(String)
    case passwordMismatch
}
