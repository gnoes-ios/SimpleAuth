import Foundation

final class SessionRepositoryImpl: SessionRepository {
    private let defaults: UserDefaults
    private let key = "current_user_email"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isLoggedIn: Bool {
        return currentEmail != nil
    }

    var currentEmail: String? {
        return defaults.string(forKey: key)
    }

    func setLoggedIn(_ email: String) {
        defaults.set(email, forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
