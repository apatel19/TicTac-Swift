//
//  PlayerInfo.swift
//  TicTacToe
//
//  Created by Apurva Patel on 3/2/19.
//  Copyright © 2019 Apurva Patel. All rights reserved.
//

import Foundation

//Stores useful information
class PlayerInfo {
    var player1name : String = ""
    var player2name : String = ""
    var player1Object : String = ""
    var player2Object : String = ""
    var gridSize : Int = 0;
    var turnIndicator : State = State.EMPTY
}

enum State : String {
    case EMPTY = "Empty"
    case CROSS = "Cross"
    case ROUND = "Round"
}

