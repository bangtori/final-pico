//
//  LikeCollectionViewCell.swift
//  Pico
//
//  Created by 방유빈 on 2023/09/26.
//

import UIKit
import SnapKit

protocol LikeCollectionViewCellDelegate: AnyObject {
    func tappedDeleteButton(_ cell: LikeCollectionViewCell)
    func tappedMessageButton(_ cell: LikeCollectionViewCell)
}

final class LikeCollectionViewCell: UICollectionViewCell {
    weak var delegate: LikeCollectionViewCellDelegate?
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "찐 윈터임, 21"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
        configButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData(imageUrl: String, isHiddenDeleteButton: Bool, isHiddenMessageButton: Bool) {
        guard let url = URL(string: imageUrl) else { return }
        userImageView.load(url: url)
        messageButton.isHidden = isHiddenMessageButton
        deleteButton.isHidden = isHiddenDeleteButton
    }
    
    private func configButtons() {
        deleteButton.addTarget(self, action: #selector(tappedDeleteButton), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(tappedMessageButton), for: .touchUpInside)
    }
    
    private func addViews() {
        [userImageView, nameLabel, deleteButton, messageButton].forEach { item in
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
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(5)
        }
        
        messageButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func tappedDeleteButton() {
        delegate?.tappedDeleteButton(self)
    }
    
    @objc private func tappedMessageButton() {
        delegate?.tappedMessageButton(self)
    }
}