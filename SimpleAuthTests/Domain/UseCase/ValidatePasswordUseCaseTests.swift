import XCTest
@testable import SimpleAuth

final class ValidatePasswordUseCaseTests: XCTestCase {
    private var useCase: ValidatePasswordUseCaseImpl!

    override func setUp() {
        super.setUp()
        useCase = ValidatePasswordUseCaseImpl()
    }

    override func tearDown() {
        useCase = nil
        super.tearDown()
    }

    func test_비밀번호가_정책에_맞으면_성공() {
        // given
        let password = "Passw0rd!"
        let confirm = "Passw0rd!"

        // when
        let result = Result { try useCase.execute(password, confirm: confirm) }

        // then
        XCTAssertNoThrow(try result.get())
    }

    func test_비밀번호가_너무짧으면_실패() {
        // given
        let password = "Pw1!"
        let confirm = "Pw1!"

        // when
        let result = Result { try useCase.execute(password, confirm: confirm) }

        // then
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? ValidationError,
                           .invalidPassword("비밀번호는 최소 8자 이상이어야 합니다."))
        }
    }

    func test_영문자가_없으면_실패() {
        // given
        let password = "12345678!"
        let confirm = "12345678!"

        // when
        let result = Result { try useCase.execute(password, confirm: confirm) }

        // then
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? ValidationError,
                           .invalidPassword("비밀번호에는 영문자가 최소 1개 포함되어야 합니다."))
        }
    }

    func test_숫자가_없으면_실패() {
        // given
        let password = "Password!"
        let confirm = "Password!"

        // when
        let result = Result { try useCase.execute(password, confirm: confirm) }

        // then
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? ValidationError,
                           .invalidPassword("비밀번호에는 숫자가 최소 1개 포함되어야 합니다."))
        }
    }

    func test_특수문자가_없으면_실패() {
        // given
        let password = "Password1"
        let confirm = "Password1"

        // when
        let result = Result { try useCase.execute(password, confirm: confirm) }

        // then
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? ValidationError,
                           .invalidPassword("비밀번호에는 특수문자가 최소 1개 포함되어야 합니다."))
        }
    }

    func test_비밀번호와_확인값이_다르면_실패() {
        // given
        let password = "Passw0rd!"
        let confirm = "Different!"

        // when
        let result = Result { try useCase.execute(password, confirm: confirm) }

        // then
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? ValidationError, .passwordMismatch)
        }
    }
}
