import UIKit
import RxSwift
import RxRelay
import SnapKit

final class SignUpView: UIView {
    typealias Action = SignUpAction

    let action = PublishRelay<Action>()
    private let disposeBag = DisposeBag()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var textFields: [SignUpField: UITextField] = [:]
    private var errorLabels: [SignUpField: UILabel] = [:]

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGray3
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateError(field: SignUpField, message: String?) {
        if let text = textFields[field]?.text, text.isEmpty {
            errorLabels[field]?.text = nil
            errorLabels[field]?.isHidden = true
        } else {
            errorLabels[field]?.text = message
            errorLabels[field]?.isHidden = (message == nil)
        }
    }

    func setSignUpButtonEnabled(_ enabled: Bool) {
        signUpButton.isEnabled = enabled
        signUpButton.backgroundColor = enabled ? .systemBlue : .systemGray3
    }
}

private extension SignUpView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
        setKeyboardObservers()
        setDismissKeyboardOnTap()
    }

    func setAttributes() {
        backgroundColor = .systemBackground

        SignUpField.allCases.forEach { field in
            let (textField, errorLabel) = makeTextFieldSet(
                placeholder: field.placeholder,
                keyboard: field.keyboard,
                secure: field.isSecure
            )

            textFields[field] = textField
            errorLabels[field] = errorLabel

            contentView.addSubview(textField)
            contentView.addSubview(errorLabel)
        }
    }

    func setHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(signUpButton)

        SignUpField.allCases.forEach { field in
            guard let textField = textFields[field],
                  let errorLabel = errorLabels[field] else { return }

            contentView.addSubview(textField)
            contentView.addSubview(errorLabel)
        }
    }

    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        var lastBottom = contentView.snp.top

        SignUpField.allCases.forEach { field in
            guard let textField = textFields[field],
                  let errorLabel = errorLabels[field] else { return }

            textField.snp.makeConstraints { make in
                make.top.equalTo(lastBottom).offset(24)
                make.horizontalEdges.equalToSuperview().inset(24)
            }

            errorLabel.snp.makeConstraints { make in
                make.top.equalTo(textField.snp.bottom).offset(4)
                make.horizontalEdges.equalToSuperview().inset(24)
            }

            lastBottom = errorLabel.snp.bottom
        }

        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(lastBottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-24)
        }
    }

    func setBindings() {
        SignUpField.allCases.forEach { field in
            textFields[field]?.rx.text.orEmpty
                .map { field.makeAction(text: $0) }
                .bind(to: action)
                .disposed(by: disposeBag)
        }

        let emailObs = textFields[.email]?.rx.text.orEmpty.asObservable() ?? .just("")
        let passwordObs = textFields[.password]?.rx.text.orEmpty.asObservable() ?? .just("")
        let confirmObs = textFields[.confirmPassword]?.rx.text.orEmpty.asObservable() ?? .just("")
        let nicknameObs = textFields[.nickname]?.rx.text.orEmpty.asObservable() ?? .just("")

        signUpButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    emailObs,
                    passwordObs,
                    confirmObs,
                    nicknameObs
                )
            )
            .map { Action.submit(email: $0, password: $1, confirm: $2, nickname: $3) }
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}

private extension SignUpView {
    func setKeyboardObservers() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .subscribe { [weak self] height in
                guard let self else { return }

                scrollView.contentInset.bottom = height + 16
                scrollView.verticalScrollIndicatorInsets.bottom = height + 16
            }
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe { [weak self] _ in
                guard let self else { return }

                scrollView.contentInset.bottom = .zero
                scrollView.verticalScrollIndicatorInsets.bottom = .zero
            }
            .disposed(by: disposeBag)
    }

    func setDismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)

        tap.rx.event
            .bind { [weak self] _ in
                self?.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}

private extension SignUpView {
    func makeTextFieldSet(
        placeholder: String,
        keyboard: UIKeyboardType = .default,
        secure: Bool = false
    ) -> (UITextField, UILabel) {
        let textField: UITextField = {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.backgroundColor = .secondarySystemBackground
            textField.clearButtonMode = .whileEditing
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.placeholder = placeholder
            textField.keyboardType = keyboard
            textField.isSecureTextEntry = secure
            textField.snp.makeConstraints { $0.height.equalTo(44) }
            return textField
        }()

        let errorLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12)
            label.textColor = .systemRed
            label.numberOfLines = 0
            return label
        }()

        return (textField, errorLabel)
    }
}
