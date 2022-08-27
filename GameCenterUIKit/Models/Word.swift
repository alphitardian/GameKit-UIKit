//
//  Word.swift
//  GameCenterUIKit
//
//  Created by Ardian Pramudya Alphita on 26/08/22.
//

import Foundation

struct Word: Codable {
    var word: String
    var hint: String
}

extension Word {
    static let dataSource = [
        Word(word: "Love", hint: "Its a feeling"),
        Word(word: "Toilet", hint: "Its an object"),
        Word(word: "Apple", hint: "Its a product")
    ]
}
