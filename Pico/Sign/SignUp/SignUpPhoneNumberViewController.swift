//
//  SingUpPhoneNumberViewController.swift
//  Pico
//
//  Created by LJh on 2023/09/26.
//

import UIKit
import SnapKit
import RxSwift

final class SignUpPhoneNumberViewController: UIViewController {
    var viewModel: SignUpViewModel = .shared
    private var userPhoneNumber: String = ""
    private var isFullPhoneNumber: Bool = false
    private var isTappedCheckButton: Bool = false
    private var messageButtons: [UIButton] = []
    
    private let notifyLabel: UILabel = {
        let label = UILabel()
        label.text = "가입하실 전화번호를 입력하세요."
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.picoTitleFont
        return label
    }()
    
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .picoBetaBlue
        view.progressTintColor = .picoBlue
        view.progress = 0.284
        view.layer.cornerRadius = SignView.progressViewCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let phoneTextFieldstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = .picoTitleFont
        textField.textColor = .gray
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let phoneNumberCheckButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("  인증  ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 13
        button.backgroundColor = .picoBlue
        button.isHidden = true
        return button
    }()
    
    private let cancleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight:
                .bold)
        return button
    }()
    
    private let phoneMessageHorizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
    private let nextButton: UIButton = {
        let button = CommonButton(type: .custom)
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .picoGray
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.configBackgroundColor()
        view.tappedDismissKeyboard()
        configNavigationBackButton()
        addSubViews()
        makeConstraints()
        configButtons()
        configTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboard()
        phoneNumberTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboard()
    }
}
// MARK: - Config
extension SignUpPhoneNumberViewController {
  
    private func configButtons() {
        phoneNumberCheckButton.addTarget(self, action: #selector(tappedPhoneNumberCheckButton), for: .touchUpInside)
        cancleButton.addTarget(self, action: #selector(tappedPhoneNumberCancleButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
    }
    
    private func configTextField() {
        phoneNumberTextField.delegate = self
    }
    
    private func updateNextButton(isCheck: Bool) {
        switch isCheck {
        case true:
            phoneMessageHorizontalStack.isHidden = false
            phoneNumberTextField.textColor = .picoBlue
            nextButton.backgroundColor = .picoBlue
            isTappedCheckButton = true
        case false:
            phoneMessageHorizontalStack.isHidden = true
            isTappedCheckButton = false
            nextButton.backgroundColor = .picoGray
        }
    }
    
    private func updateCheckButton(isFull: Bool) {
        switch isFull {
        case true:
            phoneNumberCheckButton.isHidden = false
            isFullPhoneNumber = true
        case false:
            phoneNumberCheckButton.isHidden = true
            isFullPhoneNumber = false
        }
    }
    
    private func updateCancleButton(isTrue: Bool) {
        // 참일 때 버튼이 사라짐
        switch isTrue {
        case true:
            self.phoneNumberCheckButton.isEnabled = false
            self.phoneNumberCheckButton.backgroundColor = .picoGray
            self.cancleButton.isHidden = true
        case false:
            self.phoneNumberCheckButton.isEnabled = true
            self.phoneNumberCheckButton.backgroundColor = .picoBlue
            self.cancleButton.isHidden = false
        }
    }
    
    private func updatePhoneNumberTextField(isTrue: Bool) {
        // 참일 때 텍스트 필드가 비활성화 되고 텍스트가 파래짐
        switch isTrue {
        case true:
            self.phoneNumberTextField.isEnabled = false
            self.phoneNumberTextField.textColor = .picoBlue
        case false:
            self.phoneNumberTextField.isEnabled = true
            self.phoneNumberTextField.textColor = .gray
        }
    }
    // MARK: - @objc
    @objc private func tappedPhoneNumberCheckButton(_ sender: UIButton) {
        sender.tappedAnimation()
        showAlert(message: "\(phoneNumberTextField.text ?? "") 번호로 인증번호를 전송합니다.", isCancelButton: true) {
            self.updateCancleButton(isTrue: true)
            self.updatePhoneNumberTextField(isTrue: true)
            self.updateNextButton(isCheck: true)
        }
    }
    
    @objc private func tappedPhoneNumberCancleButton(_ sender: UIButton) {
        sender.tappedAnimation()
        phoneNumberTextField.text = ""
        updateCheckButton(isFull: false)
    }
    
    private func reset() {
        // 초기상태로 가는거임
        self.registerKeyboard()
        self.phoneNumberTextField.becomeFirstResponder()
        self.phoneNumberTextField.text = ""
        self.userPhoneNumber = ""
        self.isFullPhoneNumber = false
        self.isTappedCheckButton = false
        self.updatePhoneNumberTextField(isTrue: false)
        self.updateCancleButton(isTrue: false)
        self.updateCheckButton(isFull: false)
        self.updateNextButton(isCheck: false)
    }
    
    @objc private func tappedNextButton(_ sender: UIButton) {
        if isFullPhoneNumber && isTappedCheckButton {
            sender.tappedAnimation()
            guard let text = phoneNumberTextField.text else { return }
            viewModel.checkPhoneNumber(userNumber: text) {
                guard self.viewModel.isRightUser else {
                    Loading.hideLoading()
                    self.showAlert(message: "이미 등록된 번호입니다.") {
                        self.reset()
                    }
                    return
                }
                Loading.hideLoading()
                self.viewModel.phoneNumber = text
                   
                let viewController = SignUpGenderViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

// MARK: - 텍스트필드 관련
extension SignUpPhoneNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isChangeValue = changePhoneNumDigits(textField, shouldChangeCharactersIn: range, replacementString: string) { isFull in
            updateCheckButton(isFull: isFull)
        }
        
        return isChangeValue
    }
}

// MARK: - 키보드 관련
extension SignUpPhoneNumberViewController {
    
    private func registerKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 50)
                }
            )
        }
    }
    
    @objc private func keyboardDown() {
        self.nextButton.transform = .identity
    }
}

// MARK: - UI 관련
extension SignUpPhoneNumberViewController {
    
    private func addSubViews() {
        configMessageButtons()
        for pmStkItem in messageButtons {
            phoneMessageHorizontalStack.addArrangedSubview(pmStkItem)
        }
        
        for stackViewItem in [phoneNumberTextField, cancleButton, phoneNumberCheckButton] {
            phoneTextFieldstackView.addArrangedSubview(stackViewItem)
        }
        for viewItem in [notifyLabel, progressView, phoneTextFieldstackView, nextButton, phoneMessageHorizontalStack] {
            view.addSubview(viewItem)
        }
    }
    
    private func configMessageButtons() {
        for tag in 0...5 {
            let button = UIButton()
            button.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
            button.setTitleColor(.picoFontBlack, for: .normal)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.layer.borderColor = UIColor.picoGray.cgColor
            button.tag = tag
            button.clipsToBounds = true
            messageButtons.append(button)
        }
    }
    
    private func makeConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(SignView.progressViewTopPadding)
            make.leading.equalTo(SignView.padding)
            make.trailing.equalTo(-SignView.padding)
            make.height.equalTo(8)
        }
        
        notifyLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(SignView.padding)
            make.leading.equalTo(SignView.padding)
            make.trailing.equalTo(-SignView.padding)
        }
        
        phoneTextFieldstackView.snp.makeConstraints { make in
            make.top.equalTo(notifyLabel.snp.bottom).offset(SignView.contentPadding)
            make.leading.equalTo(SignView.contentPadding)
            make.trailing.equalTo(-SignView.contentPadding)
            make.height.equalTo(30)
        }
        
        phoneNumberCheckButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        phoneMessageHorizontalStack.snp.makeConstraints { make in
            make.top.equalTo(phoneTextFieldstackView.snp.bottom).offset(SignView.contentPadding)
            make.leading.equalTo(SignView.contentPadding)
            make.trailing.equalTo(-SignView.contentPadding)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(notifyLabel.snp.leading)
            make.trailing.equalTo(notifyLabel.snp.trailing)
            make.bottom.equalTo(safeArea).offset(SignView.bottomPadding)
            make.height.equalTo(CommonConstraints.buttonHeight)
        }
    }
}
