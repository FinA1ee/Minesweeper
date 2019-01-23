//
//  gameBoard.swift
//  MineSweeper 2.0
//
//  Created by Yuchen Zhu on 2018-06-06.
//  Copyright © 2018 Momendie. All rights reserved.
//

import Foundation



class GameBoard {
    
    var board = [[Cell]]()
    
    var mineCell = [Cell]()
    
    var mineTotal : Int = 0
    
    init() {
        for i in 0...8 {
            var cellRow = [Cell]()
            for j in 0...8 {
                let newCell = Cell(inputRow: i, inputCol: j)
                cellRow.append(newCell)
            }
            board.append(cellRow)
        }
        updateCellAround()
    }
    
    
    func initBoard(level: Int){
        mineTotal = level
        generateMine(mineNum: mineTotal)
        countAllCellMine()
    }
    
    
    
    func revealCell(linearIndex: Int)->Bool{
        let row, col : Int
        row = linearIndex / 9
        col = linearIndex % 9
        return board[row][col].revealCell()
    }
    
    
    func flagCell(linearIndex: Int)->String{
        let row, col : Int
        row = linearIndex / 9
        col = linearIndex % 9
        return board[row][col].flagCell()
    }
    
    
    
    func checkLose()->Bool{
        for i in 0...mineCell.count-1 {
            if mineCell[i].isReveal == true{
                return true
            }
        }
        return false
    }

    
    func checkWin()->Bool{
        for i in 0...8{
            for j in 0...8{
                if board[i][j].winCondition() == false{
                    return false
                }
            }
        }
        return true
    }
    
    
    
    func updateCellAround(){
        for i in 0...8{
            for j in 0...8{
                updateCell(centerCell: board[i][j])
            }
        }
    }
    
    func updateCell(centerCell: Cell){
        let row = centerCell.row
        let col = centerCell.col
        for i in -1...1{
            for j in -1...1{
                if (row+i <= 8 && row+i >= 0) && (col+j <= 8 && col+j >= 0) && (i != 0 || j != 0){
                    centerCell.addCellAround(newCell: board[row+i][col+j])
                }
            }
        }
    }
    
    func countAllCellMine(){
        for i in 0...8{
            for j in 0...8{
                board[i][j].updateMineAround()
            }
        }
    }
    
    func displayCell(linearIndex: Int)->String{
        let row, col : Int
        row = linearIndex / 9
        col = linearIndex % 9
        return board[row][col].showCell()
    }
    
    func resetBoard(){
        mineCell = [Cell]()
        for i in 0...8{
            for j in 0...8{
                board[i][j].resetCell()
            }
        }
        generateMine(mineNum: mineTotal)
        countAllCellMine()
    }
    
    func generateMine(mineNum: Int){
        print(mineNum)
        var z : Int = 1
        while(z <= mineNum) {
            let randCol = Int(arc4random_uniform(UInt32(9)))
            let randRow = Int(arc4random_uniform(UInt32(9)))
            if(board[randRow][randCol].isMine()){
                continue
            }
            print("Random Index " + String(randRow) + " " + String(randCol))
            board[randRow][randCol].turnMine()
            mineCell.append(board[randRow][randCol])
            z += 1
        }
    }
    
    func showAllMine(){
        for i in 0...mineCell.count - 1{
            mineCell[i].revealCell()
        }
    }
    
    func clearBoard(){
        mineCell.removeAll()
        for i in 0...8{
            for j in 0...8{
                board[i][j].clearCell()
            }
        }
    }
    
}
















