import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class StartViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let diContainer: DIContainer

    private let startView = StartView()
    private let viewModel: StartViewModel

    init(
        viewModel: StartViewModel,
        diContainer: DIContainer
    ) {
        self.viewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = startView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension StartViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        startView.action
            .bind(to: viewModel.action)
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
                case .signUp:
                    let vm = diContainer.makeSignUpViewModel()
                    let vc = SignUpViewController(viewModel: vm, diContainer: diContainer)
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
