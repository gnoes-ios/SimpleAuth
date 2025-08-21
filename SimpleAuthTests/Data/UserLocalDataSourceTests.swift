import XCTest
import CoreData
@testable import SimpleAuth

final class UserLocalDataSourceTests: XCTestCase {
    var sut: UserLocalDataSourceImpl!

    override func setUp() async throws {
        try await super.setUp()
        let stack = InMemoryCoreDataStack()
        sut = UserLocalDataSourceImpl(context: stack.backgroundContext)
    }

    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }

    func test_이메일_중복체크_false() async throws {
        // when
        let result = try await sut.isEmailDuplicate("test@example.com")

        // then
        XCTAssertFalse(result)
    }

    func test_유저_삽입후_중복체크_true() async throws {
        // given
        _ = try await sut.insertUser(email: "test@example.com", nickname: "닉", passwordHash: "hash")

        // when
        let result = try await sut.isEmailDuplicate("test@example.com")

        // then
        XCTAssertTrue(result)
    }

    func test_유저_삽입후_fetchUser() async throws {
        // given
        let inserted = try await sut.insertUser(email: "test@example.com", nickname: "닉", passwordHash: "hash")

        // when
        let fetched = try await sut.fetchUser(byEmail: "test@example.com")

        // then
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.email, inserted.email)
        XCTAssertEqual(fetched?.nickname, inserted.nickname)
    }

    func test_유저삭제() async throws {
        // given
        _ = try await sut.insertUser(email: "test@example.com", nickname: "닉", passwordHash: "hash")

        // when
        try await sut.deleteUser(byEmail: "test@example.com")
        let user = try await sut.fetchUser(byEmail: "test@example.com")

        // then
        XCTAssertNil(user)
    }
}
