//
//  GameCenterHelper.swift
//  GameCenterUIKit
//
//  Created by Ardian Pramudya Alphita on 23/08/22.
//

import GameKit

protocol GameCenterHelperDelegate {
    func presentAuth(_ gameCenter: GameCenterHelper, viewController: UIViewController?)
    func presentMatchmaker(_ gameCenter: GameCenterHelper, viewController: UIViewController?)
    func presentGame(_ gameCenter: GameCenterHelper, match: GKMatch?)
}

class GameCenterHelper: NSObject {
    
    static var shared = GameCenterHelper()
    
    var delegate: GameCenterHelperDelegate?
    
    var isAuthenticated: Bool {
        GKLocalPlayer.local.isAuthenticated
    }
    
    override init() {
        super.init()
        GKLocalPlayer.local.authenticateHandler = { authVC, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let authVC = authVC {
                self.delegate?.presentAuth(self, viewController: authVC)
            }
            GKLocalPlayer.local.register(self)
            GKAccessPoint.shared.location = .topLeading
            GKAccessPoint.shared.isActive = self.isAuthenticated
        }
    }
    
    func presentMatchmaker() {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 5
        request.inviteMessage = "Yuk main"
        
        let vc = GKMatchmakerViewController(matchRequest: request)!
        vc.matchmakerDelegate = self
        self.delegate?.presentMatchmaker(self, viewController: vc)
    }
    
    func joinAvailableGame() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 5
        request.inviteMessage = "Yuk main"

        // nyari room random yg lagi proses matchmaking
        GKMatchmaker.shared().findMatch(for: request) { match, error in
            if let match = match {
                self.delegate?.presentGame(self, match: match)
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension GameCenterHelper: GKMatchmakerViewControllerDelegate {
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(
        _ viewController: GKMatchmakerViewController,
        didFailWithError error: Error
    ) {
        print(error.localizedDescription)
    }
    
    func matchmakerViewController(
        _ viewController: GKMatchmakerViewController,
        didFind match: GKMatch
    ) {
        viewController.dismiss(animated: true)
        self.delegate?.presentGame(self, match: match)
    }
}

extension GameCenterHelper: GKLocalPlayerListener {
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        if let vc = GKMatchmakerViewController(invite: invite) {
            vc.matchmakerDelegate = self
            self.delegate?.presentMatchmaker(self, viewController: vc)
        }
    }
}
