//
//  BaseViewController.swift
//  Pico
//
//  Created by 최하늘 on 2023/09/26.
//

import UIKit
import SnapKit
/*
 사용법: 상속해서 사용하시면 됩니다
 class MainViewController: BaseViewController {
*/

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configLogoBarItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }
    
    private func configUI() {
        configBgColor()
        configNavigationBgColor()
        configBackButton()
        tappedDismissKeyboard()
    }
    
    private func configBgColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigationBgColor() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemBackground
        navigationBarAppearance.shadowColor = .clear // 밑줄 제거
        navigationBarAppearance.shadowImage = UIImage() // 밑줄 제거
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        // 네비게이션 바의 밑줄을 없앱니다.
//        navigationController?.navigationBar.compactAppearance?.backgroundImage = UIImage()
//        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundImage = UIImage()

    }
}