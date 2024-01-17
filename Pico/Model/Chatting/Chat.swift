//
//  Chat.swift
//  Pico
//
//  Created by 최하늘 on 1/17/24.
//

import Foundation

struct ChatRoom: Codable {
    let roomInfo: [RoomInfo]
    
    struct RoomInfo: Codable {
        var roomId: String
        /// 대화상대 아이디
        let opponentId: String
        /// 마지막 메시지
        let lastMessage: String
        let sendedDate: Double
    }
}

struct ChatDetail: Codable {
    let chatInfo: [ChatInfo]
    
    struct ChatInfo: Codable {
        /// 보낸 사람
        let sendUserId: String
        let message: String
        let sendedDate: Double
        let isReading: Bool
    }
}
