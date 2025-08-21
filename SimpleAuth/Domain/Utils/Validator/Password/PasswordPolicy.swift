import Foundation

struct PasswordPolicy {
    let minLength: Int
    let requireLetter: Bool
    let requireNumber: Bool
    let requireSpecial: Bool

    init(
        minLength: Int = 8,
        requireLetter: Bool = true,
        requireNumber: Bool = true,
        requireSpecial: Bool = true
    ) {
        self.minLength = minLength
        self.requireLetter = requireLetter
        self.requireNumber = requireNumber
        self.requireSpecial = requireSpecial
    }
}
