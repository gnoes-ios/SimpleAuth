import Foundation
import RxSwift
import RxRelay

enum MainAction {
    case viewWillAppear
    case logout
    case withdraw
}

enum MainState {
    case welcomeMessage(String)
    case error(String?)
}

enum MainRoute {
    case start
}

final class MainViewModel {
    typealias Action = MainAction
    typealias State = MainState
    typealias Route = MainRoute

    let action = PublishRelay<Action>()
    let state  = PublishRelay<State>()
    let route  = PublishRelay<Route>()

    private let disposeBag = DisposeBag()

    private let fetchCurrentUserUseCase: FetchCurrentUserUseCase
    private let logoutUseCase: LogoutUseCase
    private let withdrawUseCase: WithdrawUseCase

    init(
        fetchCurrentUserUseCase: FetchCurrentUserUseCase,
        logoutUseCase: LogoutUseCase,
        withdrawUseCase: WithdrawUseCase
    ) {
        self.fetchCurrentUserUseCase = fetchCurrentUserUseCase
        self.logoutUseCase = logoutUseCase
        self.withdrawUseCase = withdrawUseCase
        bind()
    }

    private func bind() {
        action
            .subscribe { [weak self] action in
                guard let self else { return }

                switch action {
                case .viewWillAppear:
                    fetchUser()
                case .logout:
                    logoutUseCase.execute()
                    route.accept(.start)
                case .withdraw:
                    withdraw()
                }
            }
            .disposed(by: disposeBag)
    }

    private func fetchUser() {
        Task {
            do {
                let user = try await fetchCurrentUserUseCase.execute()
                state.accept(.welcomeMessage("\(user.nickname) 님 환영합니다."))
            } catch {
                state.accept(.error("사용자 정보를 불러올 수 없습니다."))
            }
        }
    }

    private func withdraw() {
        Task {
            do {
                try await withdrawUseCase.execute()
                route.accept(.start)
            } catch {
                state.accept(.error("회원 탈퇴에 실패했습니다."))
            }
        }
    }
}
