//
//  GameModel.swift
//  GameCenterUIKit
//
//  Created by Ardian Pramudya Alphita on 26/08/22.
//

import Foundation

struct GameModel: Codable {
    var currentWord: Word?
    var isHost: Bool = true
}
