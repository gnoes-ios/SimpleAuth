protocol SessionRepository {
    var isLoggedIn: Bool { get }
    var currentEmail: String? { get }
    func setLoggedIn(_ email: String)
    func clear()
}
