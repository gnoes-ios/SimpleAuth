import Foundation
import RxSwift
import RxRelay

enum StartAction {
    case tapStart
}

enum StartRoute {
    case signUp
    case main
}

final class StartViewModel {
    typealias Action = StartAction
    typealias Route = StartRoute

    let action = PublishRelay<Action>()
    let route = PublishRelay<Route>()

    private let disposeBag = DisposeBag()

    private let checkLoginStatusUseCase: CheckLoginStatusUseCase

    init(checkLoginStatusUseCase: CheckLoginStatusUseCase) {
        self.checkLoginStatusUseCase = checkLoginStatusUseCase
        bind()
    }

    private func bind() {
        action
            .subscribe { [weak self] action in
                guard let self else { return }

                switch action {
                case .tapStart:
                    checkLogin()
                }
            }
            .disposed(by: disposeBag)
    }

}

private extension StartViewModel {
    func checkLogin() {
        let isLogin = checkLoginStatusUseCase.execute()
        isLogin ? route.accept(.main) : route.accept(.signUp)
    }
}
