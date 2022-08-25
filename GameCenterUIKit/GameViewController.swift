//
//  GameViewController.swift
//  GameCenterUIKit
//
//  Created by Ardian Pramudya Alphita on 25/08/22.
//

import UIKit
import GameKit

class GameViewController: UIViewController {
    
    var match: GKMatch?

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        match?.delegate = self
        if let match = match {
            self.descriptionLabel?.text = "Musuhmu adalah: \(match.players.first?.displayName)"
        }
    }
}

extension GameViewController: GKMatchDelegate {
    // disini ngolah data
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        print(match)
    }
}
