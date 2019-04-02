//
//  GameZoneViewController.swift
//  TicTacToe
//
//  Created by Apurva Patel on 3/2/19.
//  Copyright © 2019 Apurva Patel. All rights reserved.
//

import UIKit

class GameZoneViewController: UIViewController {
    
    var gridSize : Int = 0      //Later in initialize function value becomes 3, 4, or 5
    
    @IBOutlet var player1Label: UILabel!
    @IBOutlet var player2Label: UILabel!
    @IBOutlet var player1ObjectImage: UIImageView!
    @IBOutlet var player2ObjectImage: UIImageView!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var player1ScoreLabel: UILabel!
    @IBOutlet var player2ScoreLabel: UILabel!
    
    var playerInfo = PlayerInfo() //contains Players Info + Current Turn
    
    var board: [[State]] = []   //Game Board
    var unMarkedBoxes: Int = 0 //To keep track how many places are left
    
    var player1Score: Int = 0
    var player2Score: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        initializeBoard()
        setPlayersNameLabelAndImage()
        setPlayersScoreLabels(label: player1ScoreLabel, score: player1Score)
        setPlayersScoreLabels(label: player2ScoreLabel, score: player2Score)
        indicateWhosTurnIsNow(current: playerInfo.turnIndicator.rawValue)
    }
    
    @IBAction func newButtonTapped(_ sender: Any) {
        restartWholeGame()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//Handle Initialization, loading and Restart
extension GameZoneViewController {

    func setPlayersNameLabelAndImage () {
        player1Label.text = playerInfo.player1name
        player2Label.text = playerInfo.player2name
        if (playerInfo.player1Object == "Cross") {
            player1ObjectImage.image = UIImage(named: "Cross.png")
            player2ObjectImage.image = UIImage(named: "Round.png")
        } else {
            player1ObjectImage.image = UIImage(named: "Round.png")
            player2ObjectImage.image = UIImage(named: "Cross.png")
        }
    }
    
    func setPlayersScoreLabels(label: UILabel, score: Int){
        player1ScoreLabel.text = "\(player1Score)"
        player2ScoreLabel.text = "\(player2Score)"
    }
   
    //Initialization
    func initializeBoard() {
        gridSize = playerInfo.gridSize
        unMarkedBoxes = gridSize * gridSize
        for _ in 0..<gridSize {
            var subMatrix = [State]()
            for _ in 0..<gridSize {
                subMatrix.append(State.EMPTY)
            }
            board.append(subMatrix)
        }
    }

    //Play again keep the scores but reload everything else
    func playAgainGame(){
        board.removeAll()
        initializeBoard()
        setPlayersScoreLabels(label: player1ScoreLabel, score: player1Score)
        setPlayersScoreLabels(label: player2ScoreLabel, score: player2Score)
        collectionView.reloadData()
    }
    
    //restarts whole game | Sets score to 0
    func restartWholeGame() {
        player1Score = 0
        player2Score = 0
        playAgainGame()
    }
    
}

extension GameZoneViewController {
   
    //Once user tap on cell it mark the tapped cell and associate players mark with that.
   private func markOnTheBoard(at index: Int, with mark: State){
        //Converting to two diamensional array indexes
        let x = getX(of: index)
        let y = getY(of: index)
        board[x][y] = mark
        unMarkedBoxes = unMarkedBoxes - 1 //Because we marked box with X or O we must decrement
    }
    
    //Changes background color to identify whose turn is it.
   private func indicateWhosTurnIsNow(current turn: String){
        if turn == playerInfo.player1Object {
            
            player1Label.layer.backgroundColor = UIColor(red: 3/255, green: 98/255, blue: 204/255, alpha: 1.0).cgColor
            player2Label.layer.backgroundColor = UIColor.white.cgColor
        } else {
            player1Label.layer.backgroundColor = UIColor.white.cgColor
            player2Label.layer.backgroundColor = UIColor(red: 3/255, green: 98/255, blue: 204/255, alpha: 1.0).cgColor
        }
    }
    
    //Toggle between players turn
  private  func changeTurn(from turn: String) {
        if (turn == "Cross"){
            playerInfo.turnIndicator = State.ROUND
        } else {
            playerInfo.turnIndicator = State.CROSS
        }
        indicateWhosTurnIsNow(current: playerInfo.turnIndicator.rawValue)
    }
    
    //Get current turn player's name
  private  func getCurrentTurnPlayerName () -> String{
        if (playerInfo.turnIndicator.rawValue == playerInfo.player1Object) { return playerInfo.player1name }
        else {return playerInfo.player2name}
    }
    
    //Get current turn player value. Player1 -> 1 & Player2 -> 2
  private  func getCurrentTurnPlayer_num() -> Int {
        if (playerInfo.turnIndicator.rawValue == playerInfo.player1Object) { return 1 }
        else {return 2}
    }
    
    //Updates game score labels.
   private func inGamescoreHandler(player : Int){
        if (player == 1){
            player1Score = player1Score + 1;
            setPlayersScoreLabels(label: player1ScoreLabel, score: player1Score)
        } else {
            player2Score = player2Score + 1;
            setPlayersScoreLabels(label: player2ScoreLabel, score: player2Score)
        }
    }
    
}

//CollectionView functions
extension GameZoneViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (gridSize * gridSize)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else {fatalError("Could not dequeue cell(cellForRow).")}
        cell.imageView.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {fatalError("Could'nt get the cell(didSelectItemAt).")}
        if (cell.imageView.image == nil){
            let imageName = playerInfo.turnIndicator.rawValue + ".png"
            cell.imageView.image = UIImage(named: imageName)
            markOnTheBoard(at: indexPath.row, with: playerInfo.turnIndicator)
            checkForGameComplete(at: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGFloat(gridSize)
        return CGSize(width: (self.collectionView.frame.width/size) - 2 , height: (self.collectionView.frame.height/size))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  2
    }
}

//Check for Win and Show Alert
extension GameZoneViewController {
    
    func checkForGameComplete (at index:Int) {
        let winner = checkForWin(state: playerInfo.turnIndicator, index: index)
        if (winner){
            inGamescoreHandler(player: getCurrentTurnPlayer_num())
            showAlert(title: "\(getCurrentTurnPlayerName()) Won!", message: "Click cancel to go back to main screen or Play Again to start new game.")
        }
        if (!checkForDraw()){
            changeTurn(from: playerInfo.turnIndicator.rawValue)
        }
    }
   
//Linear run time to identify who won.
   private func checkForWin(state: State, index: Int) -> Bool {
        let x = getX(of: index)
        let y = getY(of: index)
        var col = 0, row = 0, diag = 0, rdiag = 0
        var rd = gridSize - 1;
        var hasWon = false
        for i in 0..<gridSize {         //gridSize Value can be 3, 4, 5
            if (board[x][i] == state) { col = col + 1 }
            if (board[i][y] == state) { row = row + 1 }
            if (board[i][i] == state) { diag = diag + 1}
            if (board[i][rd] == state) { rdiag = rdiag + 1 }
            rd = rd - 1
        }
        if (col == gridSize || row == gridSize || diag == gridSize || rdiag == gridSize) {
            hasWon = true
        }
        return hasWon
    }
    
//Constant time checking if game is Draw
   private func checkForDraw () -> Bool {
        if (unMarkedBoxes > 0) {return false}
        showAlert(title: "Match Draw", message: "Click cancel to go back to main screen or Play Again to start new game.")
        return true
    }
    
    private func getX (of index: Int) -> Int {
       return  index / gridSize
    }
    
    private func getY (of index: Int) -> Int {
        return index % gridSize
    }
    
    private func showAlert(title: String, message: String){
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        let startNew = UIAlertAction(title: "Play Again!", style: .default) { (_) in
            self.playAgainGame()
        }
        Alert.addAction(cancel)
        Alert.addAction(startNew)
        present(Alert, animated: true, completion: nil)
    }
}
