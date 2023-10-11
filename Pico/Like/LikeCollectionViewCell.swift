//
//  LikeCollectionViewCell.swift
//  Pico
//
//  Created by 방유빈 on 2023/09/26.
//

import UIKit
import SnapKit
import RxSwift

final class LikeCollectionViewCell: UICollectionViewCell {
    
    var deleteButtonTapObservable: Observable<Void> {
        return deleteButton.rx.tap.asObservable()
    }
    
    var messageButtonTapObservable: Observable<Void> {
        return messageButton.rx.tap.asObservable()
    }
    
    var likeBurttonTapObservalbe: Observable<Void> {
        return likeButton.rx.tap.asObservable()
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    private var likeMeViewModel: LikeMeViewModel?
    private var likeUViewModel: LikeUViewModel?
    private var user: User?
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let mbtiLabel: MBTILabelView = MBTILabelView(mbti: .enfj, scale: .small)
    
    private let deleteButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white.withAlphaComponent(0.8)
        return button
    }()
    
    private let messageButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage(systemName: "paperplane.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage(systemName: "heart.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        likeMeViewModel = nil
        likeUViewModel = nil
        user = nil
        userImageView.image = UIImage(named: "chu")
        nameLabel.text = ""
    }
    
    func configData(image: String, nameText: String, isHiddenDeleteButton: Bool, isHiddenMessageButton: Bool, mbti: MBTIType) {
        userImageView.loadImage(url: image, disposeBag: self.disposeBag)
        nameLabel.text = nameText
        mbtiLabel.setMbti(mbti: mbti)
        messageButton.isHidden = isHiddenMessageButton
        deleteButton.isHidden = isHiddenDeleteButton
        likeButton.isHidden = isHiddenDeleteButton
    }
    
    private func addViews() {
        [userImageView, nameLabel, mbtiLabel, deleteButton, messageButton, likeButton].forEach { item in
            addSubview(item)
        }
    }
    
    private func makeConstraints() {
        userImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            
        }
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        mbtiLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(nameLabel.snp.top).offset(-5)
            make.width.equalTo(mbtiLabel.frame.size.width)
            make.height.equalTo(mbtiLabel.frame.size.height)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(5)
        }
        
        messageButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.trailing.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(messageButton.snp.height)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.trailing.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(messageButton.snp.height)
        }
    }
}
