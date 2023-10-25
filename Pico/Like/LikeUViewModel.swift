//
//  LikeUViewViewModel.swift
//  Pico
//
//  Created by 방유빈 on 2023/10/05.
//

import RxSwift
import UIKit
import FirebaseFirestore

final class LikeUViewModel: ViewModelType {
    enum LikeUError: Error {
        case notFound
    }
    struct Input {
        let listLoad: Observable<Void>
        let refresh: Observable<Void>
        let checkEmpty: Observable<Void>
    }
    
    struct Output {
        let likeUIsEmpty: Observable<Bool>
        let reloadCollectionView: Observable<Void>
    }
    
    private(set) var likeUList: [Like.LikeInfo] = [] {
        didSet {
            if likeUList.isEmpty {
                isEmptyPublisher.onNext(true)
            } else {
                isEmptyPublisher.onNext(false)
            }
        }
    }
    private var isEmptyPublisher = PublishSubject<Bool>()
    private let reloadTableViewPublisher = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let currentUser = UserDefaultsManager.shared.getUserData()
    private let pageSize = 6
    var startIndex = 0

    func transform(input: Input) -> Output {
        input.refresh
            .withUnretained(self)
            .subscribe { viewModel, _ in
                viewModel.refresh()
            }
            .disposed(by: disposeBag)
        
        input.listLoad
            .withUnretained(self)
            .subscribe { viewModel, _ in
                viewModel.loadNextPage()
            }
            .disposed(by: disposeBag)
        
        let didset = isEmptyPublisher.asObservable()
            .map { result in
                return result
            }
        
        let check = input.checkEmpty
            .withUnretained(self)
            .map { viewModel, _ -> Bool in
                if viewModel.likeUList.isEmpty {
                    return true
                } else {
                    return false
                }
            }
        
        let isEmpty = Observable.of(didset, check).merge()
            .flatMapLatest { bool -> Observable<Bool> in
                return Observable.create { emitter in
                    emitter.onNext(bool)
                    return Disposables.create()
                }
            }
        
        return Output(likeUIsEmpty: isEmpty, reloadCollectionView: reloadTableViewPublisher.asObservable())
    }
    
    private func loadNextPage() {
        let dbRef = Firestore.firestore()
        let ref = dbRef.collection(Collections.likes.name).document(currentUser.userId)
        let endIndex = startIndex + pageSize
        
        DispatchQueue.global().async {
            ref.getDocument { [weak self] document, error in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                    return
                }
                
                if let document = document, document.exists {
                    if let datas = try? document.data(as: Like.self).sendedlikes?.filter({ $0.likeType == .like }) {
                        if startIndex > datas.count - 1 {
                            return
                        }
                        let currentPageDatas: [Like.LikeInfo] = Array(datas[startIndex..<min(endIndex, datas.count)])
                        likeUList.append(contentsOf: currentPageDatas)
                        startIndex += currentPageDatas.count
                        reloadTableViewPublisher.onNext(())
                    }
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
        }
    }
    
    private func refresh() {
        let didSet = isEmptyPublisher
        isEmptyPublisher = PublishSubject<Bool>()
        self.likeUList = []
        self.startIndex = 0
        isEmptyPublisher = didSet
        loadNextPage()
    }
}