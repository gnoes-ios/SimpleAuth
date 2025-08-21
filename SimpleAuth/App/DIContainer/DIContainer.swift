import Foundation
import CoreData

final class DIContainer {
    private let context: NSManagedObjectContext
    private let userDefaults: UserDefaults

    init(
        context: NSManagedObjectContext,
        userDefaults: UserDefaults
    ) {
        self.context = context
        self.userDefaults = userDefaults
    }

    // MARK: - Data Source

    private func makeUserLocalDataSource() -> UserLocalDataSource {
        UserLocalDataSourceImpl(context: context)
    }

    // MARK: - Repository

    private func makeUserRepository() -> UserRepository {
        UserRepositoryImpl(local: makeUserLocalDataSource())
    }

    private func makeSessionRepository() -> SessionRepository {
        SessionRepositoryImpl(defaults: userDefaults)
    }

    // MARK: - UseCase

    private func makeCheckLoginStatusUseCase() -> CheckLoginStatusUseCase {
        CheckLoginStatusUseCaseImpl(session: makeSessionRepository())
    }

    private func makeWithdrawUseCase() -> WithdrawUseCase {
        WithdrawUseCaseImpl(
            userRepo: makeUserRepository(),
            session: makeSessionRepository()
        )
    }

    private func makeFetchCurrentUserUseCase() -> FetchCurrentUserUseCase {
        FetchCurrentUserUseCaseImpl(
            userRepo: makeUserRepository(),
            session: makeSessionRepository()
        )
    }


    private func makeLogoutUseCase() -> LogoutUseCase {
        LogoutUseCaseImpl(session: makeSessionRepository())
    }

    private func makeSignUpUseCase() -> SignUpUseCase {
        SignUpUseCaseImpl(
            userRepo: makeUserRepository(),
            session: makeSessionRepository()
        )
    }

    private func makeValidateEmailUseCase() -> ValidateEmailUseCase {
        ValidateEmailUseCaseImpl()
    }

    private func makeValidatePasswordUseCase() -> ValidatePasswordUseCase {
        ValidatePasswordUseCaseImpl()
    }

    // MARK: - ViewModel

    func makeStartViewModel() -> StartViewModel {
        StartViewModel(checkLoginStatusUseCase: makeCheckLoginStatusUseCase())
    }

    func makeSignUpViewModel() -> SignUpViewModel {
        SignUpViewModel(
            signUpUseCase: makeSignUpUseCase(),
            validateEmailUseCase: makeValidateEmailUseCase(),
            validatePasswordUseCase: makeValidatePasswordUseCase()
        )
    }

    func makeMainViewModel() -> MainViewModel {
        MainViewModel(
            fetchCurrentUserUseCase: makeFetchCurrentUserUseCase(),
            logoutUseCase: makeLogoutUseCase(),
            withdrawUseCase: makeWithdrawUseCase()
        )
    }
}
