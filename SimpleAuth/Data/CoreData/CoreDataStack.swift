import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext

    private init() {
        container = NSPersistentContainer(name: "SimpleAuth")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data 로드 실패: \(error.localizedDescription)")
            }
        }
        backgroundContext = container.newBackgroundContext()
    }
}
