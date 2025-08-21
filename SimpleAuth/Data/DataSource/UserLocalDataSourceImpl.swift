import CoreData

actor UserLocalDataSourceImpl: UserLocalDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func isEmailDuplicate(_ email: String) async throws -> Bool {
        try await context.perform {
            let fetchRequest = UserMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", email)
            fetchRequest.fetchLimit = 1
            return try self.context.count(for: fetchRequest) > 0
        }
    }

    func insertUser(email: String, nickname: String, passwordHash: String) async throws -> UserMO {
        try await context.perform {
            let fetchRequest = UserMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", email)
            fetchRequest.fetchLimit = 1
            guard try self.context.count(for: fetchRequest) == 0 else {
                throw SignUpError.duplicateEmail
            }

            let mo = UserMO(context: self.context)
            mo.id = UUID()
            mo.email = email
            mo.nickname = nickname
            mo.passwordHash = passwordHash
            mo.createdAt = Date()

            do {
                try self.context.save()
                return mo
            }
            catch {
                throw SignUpError.duplicateEmail
            }
        }
    }

    func fetchUser(byEmail email: String) async throws -> UserMO? {
        try await context.perform {
            let fetchRequest = UserMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", email)
            fetchRequest.fetchLimit = 1
            return try self.context.fetch(fetchRequest).first
        }
    }

    func deleteUser(byEmail email: String) async throws {
        try await context.perform {
            let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", email)

            let users = try self.context.fetch(fetchRequest)
            users.forEach { self.context.delete($0) }

            try self.context.save()
        }
    }
}
