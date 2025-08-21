import CoreData

final class InMemoryCoreDataStack {
    let container: NSPersistentContainer
    var backgroundContext: NSManagedObjectContext

    init() {
        container = NSPersistentContainer(name: "SimpleAuth")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data 로드 실패: \(error.localizedDescription)")
            }
        }
        backgroundContext = container.newBackgroundContext()
    }
}
