import UIKit
import RxSwift
import RxRelay
import SnapKit

final class MainView: UIView {
    typealias Action = MainAction

    let action = PublishRelay<Action>()
    private let disposeBag = DisposeBag()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()

    private let withdrawButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setWelcomeMessage(_ message: String) {
        welcomeLabel.text = message
    }
}

private extension MainView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        backgroundColor = .systemBackground
    }

    func setHierarchy() {
        [
            welcomeLabel,
            logoutButton,
            withdrawButton
        ].forEach { addSubview($0) }
    }

    func setConstraints() {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(40)
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(60)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(48)
        }

        withdrawButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(48)
        }
    }

    func setBindings() {
        logoutButton.rx.tap
            .map { Action.logout }
            .bind(to: action)
            .disposed(by: disposeBag)

        withdrawButton.rx.tap
            .map { Action.withdraw }
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
