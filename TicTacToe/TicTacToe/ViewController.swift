//
//  ViewController.swift
//  TicTacToe
//
//  Created by Apurva Patel on 3/2/19.
//  Copyright © 2019 Apurva Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var player1nameTextField: UITextField!
    @IBOutlet var player2nameTextField: UITextField!
    @IBOutlet var objectSegment: UISegmentedControl!
    @IBOutlet var firstMoveSegment: UISegmentedControl!
    @IBOutlet var gridSizeSegment: UISegmentedControl!
    @IBOutlet var infoView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func twoPlayerTapped(_ sender: Any) {
        animateIn_InfoView()
    }
    
    @IBAction func startGameTapped(_ sender: Any) {
        let playerInfo = PlayerInfo()
        if (getPlayerData(playerInfo: playerInfo)) {
            animateOut_InfoView()
            loadGameZoneViewController(data: playerInfo)
        }
    }
   
    @IBAction func cancelOnInfoViewTapped(_ sender: Any) {
        animateOut_InfoView()
    }
    
    //Go to GameZone VC
    private func loadGameZoneViewController(data playerInfo: PlayerInfo) {
        guard let gameZoneVC = storyboard?.instantiateViewController(withIdentifier: "GameZoneViewController") as? GameZoneViewController else {showAlert(title: "Game Zone Error", message: "Had trouble loading Game Zone. Please restart or check for an Update"); return}
        gameZoneVC.playerInfo = playerInfo
        present(gameZoneVC, animated: true, completion: nil)
    }
    
    //Get User input data and store them to playerInfo
    private func getPlayerData (playerInfo: PlayerInfo) -> Bool{
        guard let player1name = player1nameTextField.text, !player1name.isEmpty else {showAlert(title: "Missing Info.", message: "Please enter in player 1 name."); return false}
        guard let player2name = player2nameTextField.text, !player2name.isEmpty else {showAlert(title: "Missing Info.", message: "Please enter in player 2 name."); return false}
        
        playerInfo.player1name = player1name
        playerInfo.player2name = player2name
        
        setTurnIndicators(of: playerInfo)
        setPlayersObjects(of: playerInfo)
        
        playerInfo.gridSize = getGridSize()
        return true
    }
    
    private func setPlayersObjects(of playerInfo: PlayerInfo) {
        switch objectSegment.selectedSegmentIndex {
        case 0: playerInfo.player1Object = "Cross"
        playerInfo.player2Object = "Round"
            break
        case 1: playerInfo.player1Object = "Round"
        playerInfo.player2Object = "Cross"
            break
        default: break
        }
    }
    
    private func setTurnIndicators(of playerInfo: PlayerInfo) {
        switch firstMoveSegment.selectedSegmentIndex {
        case 0: playerInfo.turnIndicator = State.CROSS
            break
        case 1: playerInfo.turnIndicator = State.ROUND
            break
        default: break
        }
    }
    
    private func getGridSize() -> Int {
        switch gridSizeSegment.selectedSegmentIndex {
        case 0: return 3
        case 1: return 4
        case 2: return 5
        default: return 0
        }
    }
}

extension ViewController {
    private func animateIn_InfoView () {
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.layer.borderWidth = 2
        infoView.layer.borderColor = UIColor(red: 3/255, green: 98/255, blue: 204/255, alpha: 1.0).cgColor
        infoView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        infoView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.infoView.alpha = 1
            self.infoView.transform = CGAffineTransform.identity
        }
    }
    
    private func animateOut_InfoView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.infoView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            self.infoView.alpha = 0
        }) { (success: Bool) in
            self.infoView.removeFromSuperview()
        }
        resetToDefaultValue()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func resetToDefaultValue () {
        player1nameTextField.text = ""
        player2nameTextField.text = ""
        objectSegment.selectedSegmentIndex = 0
        firstMoveSegment.selectedSegmentIndex = 0
        gridSizeSegment.selectedSegmentIndex = 0
    }
    
    private func showAlert(title: String, message: String){
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        Alert.addAction(ok)
        present(Alert, animated: true, completion: nil)
    }
}

