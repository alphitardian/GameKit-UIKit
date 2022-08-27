//
//  GameViewController.swift
//  GameCenterUIKit
//
//  Created by Ardian Pramudya Alphita on 25/08/22.
//

import UIKit
import GameKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var match: GKMatch?
    var hostPlayer: GKPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        match?.delegate = self
        descriptionTextField.delegate = self
        
        GKAccessPoint.shared.isActive = false
        
        setupUI()
    }
    
    @IBAction func sendDescription(_ sender: Any) {
        sendMessage(content: descriptionTextField.text ?? "")
    }
    
    @IBAction func eraseDescription(_ sender: Any) {
        descriptionTextField.text = ""
    }
    
    func setupUI() {
        let word = Word.dataSource.randomElement()
        wordLabel.text = word?.word ?? ""
        hintLabel.text = word?.hint ?? ""
    }
    
    func presentAlert() {
        let alert = UIAlertController(
            title: "You've been disconnected",
            message: "Connection time-out",
            preferredStyle: .alert
        )
        let leaveGame = UIAlertAction(title: "Leave Game", style: .cancel) { _ in
            self.match?.disconnect()
            self.dismiss(animated: true)
        }
        let closeAlert = UIAlertAction(title: "Close", style: .destructive)
        alert.addAction(leaveGame)
        alert.addAction(closeAlert)
        present(alert, animated: true)
    }
}

extension GameViewController: GKMatchDelegate {
    // disini ngolah data
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        print("match: \(match)")
        
        let parsedData = String(decoding: data, as: UTF8.self)
        print("data: \(parsedData)")
        
    }
    
    // ngurusin state player
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        print("Available player: \(String(match.expectedPlayerCount))")
        
        switch state {
        case .unknown:
            print("unknown")
        case .connected:
            print("connected")
        case .disconnected:
            // bisa kejadian kalo ga ada aktivitas
            DispatchQueue.main.async {
                self.presentAlert()
            }
        @unknown default:
            print("error")
        }
    }
    
    func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
        print("kepanggil")
        return true
    }
    
    func sendMessage(content: String) {
        do {
            let data = content.data(using: .utf8)
            
            // dipake untuk ngirim data ke player lain yg ada di satu match
            try match?.send(data!, to: match!.players, dataMode: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension GameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
