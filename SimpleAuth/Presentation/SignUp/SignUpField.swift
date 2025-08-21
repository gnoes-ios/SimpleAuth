import UIKit

enum SignUpField: CaseIterable {
    case email
    case password
    case confirmPassword
    case nickname
}

extension SignUpField {
    var placeholder: String {
        switch self {
        case .email: return "이메일"
        case .password: return "비밀번호"
        case .confirmPassword: return "비밀번호 확인"
        case .nickname: return "닉네임"
        }
    }

    var keyboard: UIKeyboardType {
        switch self {
        case .email: return .emailAddress
        default: return .default
        }
    }

    var isSecure: Bool {
        switch self {
        case .password,
             .confirmPassword: return true
        default: return false
        }
    }

    func makeAction(text: String) -> SignUpAction {
        switch self {
        case .email: return .setEmail(text)
        case .password: return .setPassword(text)
        case .confirmPassword: return .setConfirmPassword(text)
        case .nickname: return .setNickname(text)
        }
    }
}
