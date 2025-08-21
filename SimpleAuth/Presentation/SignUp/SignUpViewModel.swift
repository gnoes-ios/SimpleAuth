import Foundation
import RxSwift
import RxRelay

enum SignUpAction {
    case setEmail(String)
    case setPassword(String)
    case setConfirmPassword(String)
    case setNickname(String)
    case submit(email: String, password: String, confirm: String, nickname: String)
}

enum SignUpState {
    case email(valid: Bool, message: String?)
    case password(valid: Bool, message: String?)
    case confirmPassword(valid: Bool, message: String?)
    case nickname(valid: Bool, message: String?)
    case buttonEnabled(Bool)
    case error(String?)
}

enum SignUpRoute {
    case main
}

final class SignUpViewModel {
    typealias Action = SignUpAction
    typealias State = SignUpState
    typealias Route = SignUpRoute

    let action = PublishRelay<Action>()
    let state  = PublishRelay<State>()
    let route  = PublishRelay<Route>()

    private let disposeBag = DisposeBag()

    private let signUp: SignUpUseCase
    private let emailValidator: ValidateEmailUseCase
    private let passwordValidator: ValidatePasswordUseCase

    private var currentEmail: String = ""
    private var currentPassword: String = ""
    private var currentConfirmPassword: String = ""
    private var currentNickname: String = ""

    init(
        signUpUseCase: SignUpUseCase,
        validateEmailUseCase: ValidateEmailUseCase,
        validatePasswordUseCase: ValidatePasswordUseCase
    ) {
        self.signUp = signUpUseCase
        self.emailValidator = validateEmailUseCase
        self.passwordValidator = validatePasswordUseCase
        bind()
    }

    private func bind() {
        action
            .subscribe { [weak self] action in
                guard let self else { return }

                switch action {
                case .setEmail(let email):
                    currentEmail = email
                    validateEmail(email)
                    updateButtonEnabled()
                case .setPassword(let password):
                    currentPassword = password
                    validatePassword(password, confirm: currentConfirmPassword)
                    updateButtonEnabled()
                case .setConfirmPassword(let confirm):
                    currentConfirmPassword = confirm
                    validatePassword(currentPassword, confirm: confirm)
                    updateButtonEnabled()
                case .setNickname(let nickname):
                    currentNickname = nickname
                    validateNickname(nickname)
                    updateButtonEnabled()
                case .submit(let email, let password, let confirm, let nickname):
                    submit(email: email, password: password, confirm: confirm, nickname: nickname)
                }
            }
            .disposed(by: disposeBag)
    }

    private func validateEmail(_ email: String) {
        do {
            try emailValidator.execute(email)
            state.accept(.email(valid: true, message: nil))
        } catch let error as ValidationError {
            state.accept(.email(valid: false, message: mapValidationError(error)))
        } catch {
            state.accept(.email(valid: false, message: "알 수 없는 오류"))
        }
    }

    private func validatePassword(_ password: String, confirm: String) {
        do {
            try passwordValidator.execute(password, confirm: confirm)
            state.accept(.password(valid: true, message: nil))
            state.accept(.confirmPassword(valid: true, message: nil))
        } catch let error as ValidationError {
            switch error {
            case .invalidPassword:
                state.accept(.password(valid: false, message: mapValidationError(error)))
            case .passwordMismatch:
                state.accept(.confirmPassword(valid: false, message: mapValidationError(error)))
            case .invalidEmail:
                break
            }
        } catch {
            state.accept(.password(valid: false, message: "알 수 없는 오류"))
        }
    }

    private func validateNickname(_ nickname: String) {
        if nickname.isEmpty {
            state.accept(.nickname(valid: false, message: "닉네임을 입력해주세요."))
        } else {
            state.accept(.nickname(valid: true, message: nil))
        }
    }

    private func submit(email: String, password: String, confirm: String, nickname: String) {
        do {
            try emailValidator.execute(email)
            try passwordValidator.execute(password, confirm: confirm)
            guard !nickname.isEmpty else {
                state.accept(.nickname(valid: false, message: "닉네임을 입력해주세요."))
                state.accept(.error("입력값을 다시 확인해주세요."))
                return
            }
        } catch let error as ValidationError {
            state.accept(.error(mapValidationError(error)))
            return
        } catch {
            state.accept(.error("입력값을 다시 확인해주세요."))
            return
        }

        Task {
            do {
                _ = try await self.signUp.execute(email: email, password: password, confirm: confirm, nickname: nickname)
                self.route.accept(.main)
            } catch let error as SignUpError {
                switch error {
                case .duplicateEmail:
                    self.state.accept(.error("이미 가입된 이메일입니다."))
                }
            } catch {
                self.state.accept(.error("회원가입 실패"))
            }
        }
    }

    private func updateButtonEnabled() {
        let isValid = !currentEmail.isEmpty
            && !currentPassword.isEmpty
            && !currentConfirmPassword.isEmpty
            && !currentNickname.isEmpty
        state.accept(.buttonEnabled(isValid))
    }

    private func mapValidationError(_ error: ValidationError) -> String {
        switch error {
        case .invalidEmail:
            return "유효한 이메일 형식이 아닙니다."
        case .invalidPassword:
            return "비밀번호 조건을 확인해주세요."
        case .passwordMismatch:
            return "비밀번호가 일치하지 않습니다."
        }
    }
}
