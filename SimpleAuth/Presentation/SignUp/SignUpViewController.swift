import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let diContainer: DIContainer

    private let signUpView = SignUpView()
    private let viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel, diContainer: DIContainer) {
        self.viewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
private extension SignUpViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        signUpView.action
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.state
            .asSignal()
            .emit { [weak self] state in
                guard let self else { return }

                switch state {
                case let .email(_, message):
                    signUpView.updateError(field: .email, message: message)
                case let .password(_, message):
                    signUpView.updateError(field: .password, message: message)
                case let .confirmPassword(_, message):
                    signUpView.updateError(field: .confirmPassword, message: message)
                case let .nickname(_, message):
                    signUpView.updateError(field: .nickname, message: message)
                case let .buttonEnabled(enabled):
                    signUpView.setSignUpButtonEnabled(enabled)
                case let .error(message):
                    guard let message else { return }
                    showErrorAlert(message)
                }
            }
            .disposed(by: disposeBag)

        viewModel.route
            .asSignal()
            .emit { [weak self] route in
                guard let self else { return }

                switch route {
                case .main:
                    let vm = diContainer.makeMainViewModel()
                    let vc = MainViewController(viewModel: vm, diContainer: diContainer)
                    navigationController?.setViewControllers([vc], animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
