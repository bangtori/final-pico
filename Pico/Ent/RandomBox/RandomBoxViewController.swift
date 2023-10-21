//
//  RandomBoxViewController.swift
//  Pico
//
//  Created by 오영석 on 2023/09/25.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RandomBoxViewController: UIViewController {
    
    private let randomBoxManager = RandomBoxManager()
    let disposeBag = DisposeBag()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "gameBackground"))
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.7
        return imageView
    }()
    
    private let goToStoreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.square"), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private let normalInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private let advancedInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private let randomBoxTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.text = "Random Box"
        label.textColor = .picoBlue
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.picoSubTitleFont
        label.text = "랜덤박스를 열어 부족한 츄를 획득해보세요!\n꽝은 절대 없다!\n최대 100츄 획득의 기회를 놓치지 마세요!"
        label.numberOfLines = 0
        return label
    }()
    
    private let randomBoxImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chu")
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    private let normalBoxButton: CommonButton = {
        let button = CommonButton()
        button.setTitle("일반 뽑기", for: .normal)
        return button
    }()
    
    private let advancedBoxButton: CommonButton = {
        let button = CommonButton()
        button.setTitle("고급 뽑기", for: .normal)
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.picoLargeTitleFont
        label.textColor = .picoBlue
        label.text = "1"
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.picoBlue, for: .normal)
        button.titleLabel?.font = UIFont.picoLargeTitleFont
        return button
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.picoBlue, for: .normal)
        button.titleLabel?.font = UIFont.picoLargeTitleFont
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.configBackgroundColor()
        configNavigationBackButton()
        addViews()
        makeConstraints()
        bind()
    }
    
    private func addViews() {
        [backgroundImageView, goToStoreButton, normalInfoButton, advancedInfoButton, randomBoxTitleLabel, contentLabel, randomBoxImage, normalBoxButton, advancedBoxButton, countLabel, plusButton, minusButton].forEach { item in
            view.addSubview(item)
        }
    }
    
    private func makeConstraints() {
        let padding: CGFloat = 20
        let half: CGFloat = 0.5
        let buttonWidth: CGFloat = Screen.width / 2 - padding - 10
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        goToStoreButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().offset(-padding * half)
            make.width.height.equalTo(padding * 2)
        }
        
        randomBoxTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Screen.height / 12)
            make.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(randomBoxTitleLabel.snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
        }
        
        randomBoxImage.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
            make.width.equalTo(randomBoxImage.snp.height)
            make.height.equalTo(Screen.height / 3)
        }
        
        normalInfoButton.snp.makeConstraints { make in
            make.trailing.equalTo(normalBoxButton.snp.trailing)
            make.bottom.equalTo(normalBoxButton.snp.top)
            make.width.height.equalTo(padding * 2)
        }
        
        advancedInfoButton.snp.makeConstraints { make in
            make.trailing.equalTo(advancedBoxButton.snp.trailing)
            make.bottom.equalTo(normalBoxButton.snp.top)
            make.width.height.equalTo(padding * 2)
        }
        
        normalBoxButton.snp.makeConstraints { make in
            make.top.equalTo(randomBoxImage.snp.bottom).offset(padding)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(padding)
            make.trailing.equalTo(advancedBoxButton.snp.leading).offset(-padding)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(padding * 2)
        }
        
        advancedBoxButton.snp.makeConstraints { make in
            make.top.equalTo(randomBoxImage.snp.bottom).offset(padding)
            make.leading.equalTo(normalBoxButton.snp.trailing).offset(padding)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(padding * 2)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(advancedBoxButton.snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(advancedBoxButton.snp.bottom).offset(padding)
            make.leading.equalTo(countLabel.snp.trailing)
            make.width.height.equalTo(30)
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(advancedBoxButton.snp.bottom).offset(padding)
            make.trailing.equalTo(countLabel.snp.leading)
            make.width.height.equalTo(30)
        }
    }
    
    private func increaseCount() {
        guard let currentQuantity = Int(countLabel.text ?? "0"), currentQuantity < 10 else { return }
        let newQuantity = currentQuantity + 1
        countLabel.text = "\(newQuantity)"
    }
    
    private func decreaseCount() {
        guard let currentQuantity = Int(countLabel.text ?? "0"), currentQuantity > 1 else { return }
        let newQuantity = currentQuantity - 1
        countLabel.text = "\(newQuantity)"
    }
    
    private func tappedNormalBox(count: Int) {
        guard UserDefaultsManager.shared.getChuCount() >= 10 else {
            enoughChuAlert()
            return
        }
        
        var boxHistory: [Int] = []
        
        self.normalBoxButton.isEnabled = false
        self.advancedBoxButton.isEnabled = false
        
        randomBoxManager.shake(view: self.randomBoxImage) {
            for _ in 0 ..< count {
                let randomValue = self.randomBoxManager.getRandomValue(index: 1)
                boxHistory.append(randomValue)
            }
            
            let sumBoxHistory = boxHistory.reduce(0, +)
            self.randomBoxManager.obtainChu(with: sumBoxHistory, number: 10)
            
            let updatedChuCount = UserDefaultsManager.shared.getChuCount() - 10
            UserDefaultsManager.shared.updateChuCount(updatedChuCount)
            
            self.showAlert(with: sumBoxHistory)
            
            self.normalBoxButton.isEnabled = true
            self.advancedBoxButton.isEnabled = true
        }
    }
    
    private func tappedAdvancedBox(count: Int) {
        guard UserDefaultsManager.shared.getChuCount() >= 30 else {
            enoughChuAlert()
            return
        }
        
        var boxHistory: [Int] = []
        
        self.normalBoxButton.isEnabled = false
        self.advancedBoxButton.isEnabled = false
        
        randomBoxManager.shake(view: self.randomBoxImage) {
            for _ in 0 ..< count {
                let randomValue = self.randomBoxManager.getRandomValue(index: 1)
                boxHistory.append(randomValue)
            }
            
            let sumBoxHistory = boxHistory.reduce(0, +)
            self.randomBoxManager.obtainChu(with: sumBoxHistory, number: 10)
            
            let updatedChuCount = UserDefaultsManager.shared.getChuCount() - 10
            UserDefaultsManager.shared.updateChuCount(updatedChuCount)
            
            self.showAlert(with: sumBoxHistory)
            
            self.normalBoxButton.isEnabled = true
            self.advancedBoxButton.isEnabled = true
        }
    }
    
    private func showAlert(with message: Int) {
        let messageSting: String = "\(message)"
        showCustomAlert(alertType: .onlyConfirm, titleText: "결과", messageText: "\(messageSting) 츄를 획득하셨습니다!", confirmButtonText: "닫기", comfrimAction: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    private func enoughChuAlert() {
        let alert = UIAlertController(title: "츄 부족", message: "츄가 부족합니다. 더 구매하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "구매하기", style: .default) { _ in
            let storeViewController = StoreViewController(viewModel: StoreViewModel())
            self.navigationController?.pushViewController(storeViewController, animated: true)
        })
        
        present(alert, animated: true, completion: nil)
    }
}

extension RandomBoxViewController {
    private func bind() {
        normalInfoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let messageText = self.randomBoxManager.boxInfo(index: 0)
                showCustomAlert(alertType: .onlyConfirm, titleText: "일반 상자 목록", messageText: messageText, confirmButtonText: "닫기", comfrimAction: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
            .disposed(by: disposeBag)
        
        advancedInfoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let messageText = self.randomBoxManager.boxInfo(index: 1)
                showCustomAlert(alertType: .onlyConfirm, titleText: "고급 상자 목록", messageText: messageText, confirmButtonText: "닫기", comfrimAction: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
            .disposed(by: disposeBag)
        
        goToStoreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let storeViewController = StoreViewController(viewModel: StoreViewModel())
                self.navigationController?.pushViewController(storeViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        normalBoxButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                if UserDefaultsManager.shared.getChuCount() < 10 {
                    self.showCustomAlert(alertType: .canCancel, titleText: "보유 츄 부족", messageText: "보유하고 있는 츄가 부족합니다. \n현재 츄 : \(UserDefaultsManager.shared.getChuCount()) 개", cancelButtonText: "보내기 취소", confirmButtonText: "스토어로 이동", comfrimAction: {
                        let storeViewController = StoreViewController(viewModel: StoreViewModel())
                        self.navigationController?.pushViewController(storeViewController, animated: true)
                    })
                } else {
                    self.showCustomAlert(alertType: .canCancel, titleText: "중급 박스", messageText: "중급 박스 \(self.countLabel.text ?? "0")개 구매합니다", cancelButtonText: "취소", confirmButtonText: "구매하기", comfrimAction: {
                        self.tappedNormalBox(count: Int(self.countLabel.text ?? "0") ?? 0)
                    })
                }
            })
            .disposed(by: disposeBag)
        
        advancedBoxButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                if UserDefaultsManager.shared.getChuCount() < 30 {
                    self.showCustomAlert(alertType: .canCancel, titleText: "보유 츄 부족", messageText: "보유하고 있는 츄가 부족합니다. \n현재 츄 : \(UserDefaultsManager.shared.getChuCount()) 개", cancelButtonText: "보내기 취소", confirmButtonText: "스토어로 이동", comfrimAction: {
                        let storeViewController = StoreViewController(viewModel: StoreViewModel())
                        self.navigationController?.pushViewController(storeViewController, animated: true)
                    })
                } else {
                    self.showCustomAlert(alertType: .canCancel, titleText: "고급 박스", messageText: "고급 박스 \(self.countLabel.text ?? "0")개 구매합니다", cancelButtonText: "취소", confirmButtonText: "구매하기", comfrimAction: {
                        self.tappedAdvancedBox(count: Int(self.countLabel.text ?? "0") ?? 0)
                    })
                }
            })
            .disposed(by: disposeBag)
        
        plusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.increaseCount()
            })
            .disposed(by: disposeBag)
        
        minusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.decreaseCount()
            })
            .disposed(by: disposeBag)
    }
}
