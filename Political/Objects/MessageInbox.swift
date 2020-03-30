//
//  MessageInbox.swift
//  Political
//
//  Created by Gavin Wolfe on 8/10/19.
//  Copyright © 2019 Gavin Wolfe. All rights reserved.
//

import UIKit

class MessageInbox: NSObject {
    var type: String!
    var message: String!
    
    var senderId: String!
    var senderName: String!
    var timeSent: Int!
    var publisher: String!
    var time: String!
    var imageUrl: String!
    var titler: String!
    var mainUrl: String!
    var caption: String?
    var aid: String?
    var key: String?
    var bias: Int?
    var unseen: String?
    var personalLikeDis: String?
    var reaction: Int?
}
