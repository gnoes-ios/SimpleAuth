import Foundation

struct EmailValidator {
    func validate(_ email: String) throws {
        let parts = email.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: false)
        guard parts.count == 2 else {
            throw ValidationError.invalidEmail("유효한 이메일 형식이 아닙니다.")
        }

        let local = String(parts[0])
        let domain = String(parts[1])

        let localPattern = #"^[a-z][a-z0-9]{5,19}$"#
        if local.range(of: localPattern, options: .regularExpression) == nil {
            throw ValidationError.invalidEmail("아이디(이메일의 @ 이전)는 6~20자, 소문자/숫자 조합이며 숫자로 시작할 수 없습니다.")
        }

        let domainPattern = #"^[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        if domain.range(of: domainPattern, options: .regularExpression) == nil {
            throw ValidationError.invalidEmail("도메인 부분이 올바르지 않습니다.")
        }
    }
}
