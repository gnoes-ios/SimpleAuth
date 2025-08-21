import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let diContainer: DIContainer

    private let mainView = MainView()
    private let viewModel: MainViewModel

    init(viewModel: MainViewModel, diContainer: DIContainer) {
        self.viewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.action.accept(.viewWillAppear)
    }

    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

private extension MainViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        mainView.action
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.state
            .asSignal()
            .emit { [weak self] state in
                guard let self else { return }

                switch state {
                case .welcomeMessage(let message):
                    mainView.setWelcomeMessage(message)
                case .error(let message):
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
                case .start:
                    let vm = diContainer.makeStartViewModel()
                    let vc = StartViewController(viewModel: vm, diContainer: diContainer)
                    navigationController?.setViewControllers([vc], animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
