//
//  Cell.swift
//  MineSweeper 2.0
//
//  Created by Yuchen Zhu on 2018-06-06.
//  Copyright © 2018 Momendie. All rights reserved.
//

import Foundation

class Cell {
    
    let row : Int
    let col : Int
    var mineAround: Int = 0
    
    var cellType : String = "E" // empty, flag, mine
    var isReveal : Bool = false
    var isFlaged : Bool = false
    
    var cellAround = [Cell]()
    
    init(inputRow: Int, inputCol: Int){  // 9*9 game board
        row = inputRow
        col = inputCol
        
    }
    
    func turnMine() {
        cellType = "M"
    }
    
    func flagCell()->String {
        if(isReveal){
            return ("FAIL")
        }
        if(isFlaged){
            isFlaged = false
            return ("A flag is removed!")
        } else {
            isFlaged = true
            return ("A flag is placed!")
        }
    }
    
    func isMine()->Bool {
        if cellType == "M" {
            return true
        }
        return false
    }
    

    func winCondition()->Bool{
        if(cellType == "M"){
            return isFlaged
        } else {
            return isReveal
        }
    }
    
    
    
    
    
    func revealCell()->Bool {
        if(isFlaged){return false}
        if(isReveal == false){
            isReveal = true
            if(!isMine() && mineAround == 0){
                revealAround()
            }
            return true
        }
        return false
    }
    
    func resetCell() {
        cellType = "E"
        isReveal = false
        isFlaged = false
    }

    
    func showCell()->String{
        if(isFlaged){
            return "F"
        }
        if(!isReveal){
            return ""
        } else if (cellType == "E"){
            return String(mineAround)
        }
        return cellType
    }
    
    
    func addCellAround(newCell: Cell){
        cellAround.append(newCell)
    }
    

    func updateMineAround(){
        var result : Int = 0
        for i in 0...cellAround.count-1{
            if cellAround[i].isMine(){
                result += 1
            }
        }
        mineAround = result
    }
    
    
    func revealAround(){
        for i in 0...cellAround.count-1{
            cellAround[i].revealCell()
        }
    }
    
    func clearCell(){
        cellType = "E"
        isReveal = false
        isFlaged = false
        mineAround = 0
    }
    
}

