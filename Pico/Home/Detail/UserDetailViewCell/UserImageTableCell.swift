//
//  UserImageTableViewCell.swift
//  Pico
//
//  Created by 신희권 on 2023/10/04.
//

import UIKit
final class UserImageTableCell: UITableViewCell {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        return pageControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        makeConstraints()
        configScrollView()
    }
    
    private func configScrollView() {
        scrollView.frame = UIScreen.main.bounds
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
    }
    
    func config(images: [String]) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(images.count), height: scrollView.bounds.height)
        pageControl.numberOfPages = images.count
        for (index, image) in images.enumerated() {
            let imageView = UIImageView()
            if let image = URL(string: image) {
                imageView.load(url: image)
            }
            imageView.contentMode = .scaleAspectFit
            imageView.frame = UIScreen.main.bounds
            imageView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(index)
            scrollView.addSubview(imageView)
        }
    }
    
    private func addViews() {
        [scrollView, pageControl].forEach { contentView.addSubview($0) }
    }
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserImageTableCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}