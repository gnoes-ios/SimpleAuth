# SimpleAuth

**SimpleAuth**는 UIKit 기반으로 구현된 간단한 인증 플로우 프로젝트입니다.
회원가입, 로그인, 로그아웃, 회원탈퇴까지의 흐름을 CoreData와 UserDefaults를 이용해 로컬 환경에서 완성하였습니다.

---

## 구현 기능

앱은 크게 **시작하기 화면 → 회원가입 화면 → 메인 화면**의 플로우로 구성되어 있습니다.

### 시작하기 화면

* 앱 실행 시 진입하는 화면입니다.
* **시작하기 버튼**을 누르면, UserDefaults에 저장된 로그인 정보 여부를 확인합니다.
  * 로그인 정보가 없으면 **회원가입 화면**으로 이동
  * 로그인 정보가 있으면 **메인 화면**으로 이동

### 회원가입 화면

* **아이디 입력**

  * 이메일 형식(`abc@gmail.com`)을 따라야 하며,
    `@` 앞 부분은 6\~20자의 영문 소문자와 숫자만 가능, 숫자로 시작할 수 없습니다.
  * 아이디 중복 검증은 **회원가입 버튼을 누를 때 CoreData를 통해 검사**합니다.

* **비밀번호 입력**

  * 두 개의 입력창(비밀번호 / 비밀번호 확인) 제공
  * 최소 8자 이상이어야 하며, 두 입력창 값이 일치해야 합니다.

* **닉네임 입력**

  * 단순 텍스트 입력 필드

* **회원가입 버튼**

  * 아이디, 비밀번호, 닉네임 입력 조건이 충족되어야 활성화됩니다.
  * 가입 시 CoreData에 User 엔티티가 저장됩니다.
  * 이메일이 이미 존재한다면 가입에 실패합니다.
  * 성공 시 **로그인 성공 화면**으로 이동합니다.

### 메인 화면

* "닉네임 님 환영합니다." 메시지를 표시합니다.
* **로그아웃 버튼**: UserDefaults에서 로그인 정보를 삭제하고 다시 시작하기 화면으로 이동합니다.
* **회원탈퇴 버튼**: CoreData에서 해당 사용자를 삭제한 뒤 시작하기 화면으로 이동합니다.

---

## 기술 스택

* **UIKit**: Code-base UI
* **CoreData**: 회원 정보 로컬 저장
* **UserDefaults**: 로그인 상태 관리
* **XCTest**: 단위 테스트 및 시나리오 테스트

---

## 📂 프로젝트 구조

```
SimpleAuth
├── App
│   ├── Delegate
│   ├── DIContainer
│   └── Resource
├── Data
│   ├── CoreData
│   ├── DataSource
│   ├── Model
│   ├── Protocol
│   ├── Repository
│   └── Utils
├── Domain
│   ├── Entity
│   ├── Error
│   ├── Protocol
│   ├── UseCase
│   └── Utils
├── Presentation
│   ├── Start
│   ├── SignUp
│   └── Main
SimpleAuthTests
├── Data
└── Domain
    ├── Error
    └── UseCase
```

---

## 테스트

프로젝트는 **도메인 로직**과 **로컬 데이터 저장소**를 단위 테스트로 검증합니다.

* **UserLocalDataSourceTests**

  * CoreData(InMemory) 기반 CRUD 검증
  * 이메일 중복 체크, 유저 삽입/조회/삭제 테스트

* **ValidateEmailUseCaseTests**

  * 이메일 형식 검증 (길이, 시작 문자, 도메인 유효성 등)

* **ValidatePasswordUseCaseTests**

  * 비밀번호 정책 검증 (길이, 영문자/숫자/특수문자 포함 여부, 확인 값 일치)

---

## 실행 방법

1. 저장소 클론

   ```bash
   git clone https://github.com/username/SimpleAuth.git
   ```
2. 프로젝트 열기

   ```bash
   open SimpleAuth.xcodeproj
   ```
3. 시뮬레이터 실행 (`⌘ + R`)
