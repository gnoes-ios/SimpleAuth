@testable import SimpleAuth

extension ValidationError: @retroactive Equatable {
    public static func == (lhs: ValidationError, rhs: ValidationError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidEmail(let m1), .invalidEmail(let m2)):
            return m1 == m2
        case (.invalidPassword(let m1), .invalidPassword(let m2)):
            return m1 == m2
        case (.passwordMismatch, .passwordMismatch):
            return true
        default:
            return false
        }
    }
}
