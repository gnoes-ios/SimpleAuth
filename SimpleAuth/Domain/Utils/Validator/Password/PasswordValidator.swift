struct PasswordValidator {
    let policy: PasswordPolicy

    init(policy: PasswordPolicy = .init()) {
        self.policy = policy
    }

    func validate(_ password: String, confirm: String? = nil) throws {
        guard password.count >= policy.minLength else {
            throw ValidationError.invalidPassword("비밀번호는 최소 \(policy.minLength)자 이상이어야 합니다.")
        }
        if policy.requireLetter && password.range(of: #"[A-Za-z]"#, options: .regularExpression) == nil {
            throw ValidationError.invalidPassword("비밀번호에는 영문자가 최소 1개 포함되어야 합니다.")
        }
        if policy.requireNumber && password.range(of: #"[0-9]"#, options: .regularExpression) == nil {
            throw ValidationError.invalidPassword("비밀번호에는 숫자가 최소 1개 포함되어야 합니다.")
        }
        if policy.requireSpecial && password.range(of: #"[^\w]"#, options: .regularExpression) == nil {
            throw ValidationError.invalidPassword("비밀번호에는 특수문자가 최소 1개 포함되어야 합니다.")
        }
        guard password == confirm else {
            throw ValidationError.passwordMismatch
        }
    }
}
