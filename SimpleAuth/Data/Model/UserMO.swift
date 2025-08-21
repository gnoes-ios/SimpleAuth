import Foundation
import CoreData

@objc(UserMO)
public class UserMO: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var email: String
    @NSManaged public var nickname: String
    @NSManaged public var passwordHash: String
    @NSManaged public var createdAt: Date

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "UserMO")
    }
}
