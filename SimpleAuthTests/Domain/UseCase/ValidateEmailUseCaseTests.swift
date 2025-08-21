import XCTest
@testable import SimpleAuth

final class ValidateEmailUseCaseTests: XCTestCase {
    private var useCase: ValidateEmailUseCaseImpl!

    override func setUp() {
        super.setUp()
        useCase = ValidateEmailUseCaseImpl()
    }

    override func tearDown() {
        useCase = nil
        super.tearDown()
    }

    func test_올바른_이메일은_성공() {
        // given
        let email = "abc123@naver.com"

        // when
        let result = Result { try useCase.execute(email) }

        // then
        XCTAssertNoThrow(try result.get())
    }

    func test_골뱅이가_없으면_실패() {
        // given
        let email = "invalid.email.com"

        // when
        let result = Result { try useCase.execute(email) }

        // then
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? ValidationError,
                           .invalidEmail("유효한 이메일 형식이 아닙니다."))
        }
    }

    func test_아이디가_짧으면_실패() {
        // given
        let email = "a@naver.com"

        // when
        let result = Result { try useCase.execute(email) }

        // then
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? ValidationError,
                           .invalidEmail("아이디(이메일의 @ 이전)는 6~20자, 소문자/숫자 조합이며 숫자로 시작할 수 없습니다."))
        }
    }

    func test_아이디가_숫자로_시작하면_실패() {
        // given
        let email = "1abcde@naver.com"

        // when
        let result = Result { try useCase.execute(email) }

        // then
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? ValidationError,
                           .invalidEmail("아이디(이메일의 @ 이전)는 6~20자, 소문자/숫자 조합이며 숫자로 시작할 수 없습니다."))
        }
    }

    func test_도메인이_잘못되면_실패() {
        // given
        let email = "abcdef@naver"

        // when
        let result = Result { try useCase.execute(email) }

        // then
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as? ValidationError,
                           .invalidEmail("도메인 부분이 올바르지 않습니다."))
        }
    }
}
