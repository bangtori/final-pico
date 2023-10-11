//
//  HomeUserCardViewModel.swift
//  Pico
//
//  Created by 임대진 on 10/5/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class HomeUserCardViewModel {
    private let loginUser = UserDefaultsManager.shared.getUserData()
    private let sendedlikesUpdateFiled = "sendedlikes"
    private let recivedlikesUpdateFiled = "recivedlikes"
    private let docRef = Firestore.firestore().collection(Collections.likes.name)
    static var passedMyData: [[String: Any]] = []
    static var passedUserData: [[String: Any]] = []
    
    func saveLikeData(receiveUserInfo: User, likeType: Like.LikeType) {
        let myLikeUser: Like.LikeInfo = Like.LikeInfo(likedUserId: receiveUserInfo.id,
                                                      likeType: likeType,
                                                      birth: receiveUserInfo.birth,
                                                      nickName: receiveUserInfo.nickName,
                                                      mbti: receiveUserInfo.mbti,
                                                      imageURL: receiveUserInfo.imageURLs[0])
        let myLikeUserDic = myLikeUser.asDictionary()
        let myInfo: Like.LikeInfo = Like.LikeInfo(likedUserId: loginUser.userId,
                                                  likeType: likeType,
                                                  birth: loginUser.birth,
                                                  nickName: loginUser.nickName,
                                                  mbti: MBTIType(rawValue: loginUser.mbti) ?? .entp,
                                                  imageURL: loginUser.imageURL)
        let myInfoDic = myInfo.asDictionary()
        HomeUserCardViewModel.passedMyData.append(myLikeUserDic)
        HomeUserCardViewModel.passedUserData.append(myInfoDic)
        
        docRef.document(loginUser.userId).setData(
            [
                "userId": loginUser.userId,
                sendedlikesUpdateFiled: FieldValue.arrayUnion([myLikeUserDic])
            ], merge: true) { error in
                if let error = error {
                    print("평가 업데이트 에러: \(error)")
                }
            }
        docRef.document(receiveUserInfo.id).setData(
            [
                "userId": receiveUserInfo.id,
                recivedlikesUpdateFiled: FieldValue.arrayUnion([myInfoDic])
            ], merge: true) { error in
                if let error = error {
                    print("평가 업데이트 에러: \(error)")
                }
            }
    }
    
    func deleteLikeData() {
        if let myData = HomeUserCardViewModel.passedMyData.last,
           let userData = HomeUserCardViewModel.passedUserData.last,
           let userId = myData["likedUserId"] as? String {
            docRef.document(loginUser.userId).updateData(
                [
                    sendedlikesUpdateFiled: FieldValue.arrayRemove([myData])
                ]) { error in
                    if let error = error {
                        print("삭제 my 에러: \(error)")
                    } else {
                        HomeUserCardViewModel.passedMyData.removeLast()
                    }
                }
            
            docRef.document(userId).updateData(
                [
                    recivedlikesUpdateFiled: FieldValue.arrayRemove([userData])
                ]) { error in
                    if let error = error {
                        print("삭제 user 에러: \(error)")
                    } else {
                        HomeUserCardViewModel.passedUserData.removeLast()
                    }
                }
        } else {
            print("삭제할 데이터가 없습니다.")
        }
    }
    
}
