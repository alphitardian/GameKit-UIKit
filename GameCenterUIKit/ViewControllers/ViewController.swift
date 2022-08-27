//
//  ViewController.swift
//  GameCenterUIKit
//
//  Created by Ardian Pramudya Alphita on 23/08/22.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    
    var gameCenter = GameCenterHelper.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        gameCenter.delegate = self
    }
    
    @IBAction func createRoom(_ sender: UIButton) {
        gameCenter.presentMatchmaker()
    }
    
    @IBAction func joinRoom(_ sender: UIButton) {
    }
}

extension ViewController: GameCenterHelperDelegate {
    func presentAuth(_ gameCenter: GameCenterHelper, viewController: UIViewController?) {
        if let viewController = viewController {
            self.present(viewController, animated: true)
        }
    }
    
    func presentMatchmaker(_ gameCenter: GameCenterHelper, viewController: UIViewController?) {
        if let viewController = viewController {
            self.present(viewController, animated: true)
        }
    }
    
    func presentGame(_ gameCenter: GameCenterHelper, match: GKMatch?) {
        self.performSegue(withIdentifier: "goToGame", sender: match)
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            if let controller = segue.destination as? GameViewController {
                controller.match = sender as? GKMatch
            }
        }
    }
}

