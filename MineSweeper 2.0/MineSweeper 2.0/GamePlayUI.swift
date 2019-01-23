//
//  GamePlayUI.swift
//  MineSweeper 2.0
//
//  Created by Yuchen Zhu on 2018-06-10.
//  Copyright © 2018 Momendie. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class GamePlayUI: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateBoard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chooseLevel()
    }
    

    
    @IBOutlet weak var faceLogoButton: UIButton!
    
    @IBOutlet var gameBoardButtonArray: [UIButton]!
    
    @IBOutlet weak var mineLeft: UILabel!

    var isGameOver : Bool = false
    
    var indexSelected : Int = -1
    
    var sweeperGameBoard = GameBoard()
    
    var mineLeftVar : Int = 0
    
    var mineNum : Int = 0 //Fixed for every board
    
    var player: AVAudioPlayer?
    
    var cuzLevel: String = ""
    
    func chooseLevel(){
        let alert = UIAlertController(title: "Welcome to MineSweeper!", message: "Choose a difficulty to start the game!", preferredStyle: .alert)
        let easyAction = UIAlertAction(title: "Easy", style: .default, handler:
        { (UIAlertAction) in self.initBoard(level: 5)})
        let mediumAction = UIAlertAction(title: "Medium", style: .default, handler:
        { (UIAlertAction) in self.initBoard(level: 10)})
        let hardAction = UIAlertAction(title: "Hard", style: .default, handler:
        { (UIAlertAction) in self.initBoard(level: 15)})
        let customizeAction = UIAlertAction(title: "Customize", style: .default, handler:
        { (UIAlertAction) in self.customizeBoard()})
    
        alert.addAction(easyAction)
        alert.addAction(mediumAction)
        alert.addAction(hardAction)
        alert.addAction(customizeAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func initBoard(level: Int){
        mineNum = level
        mineLeftVar = level
        mineLeft.text = "Mine: " + String(level)
        sweeperGameBoard.initBoard(level: level)
        startTimer()
    }
    
    func customizeBoard(){
        let alert = UIAlertController(title: "Customize the difficulty", message: "Enter number of mines, from 1 to 40", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in

            let level = alert.textFields?[0].text

            self.cuzLevel = level!
           
            if(Int(self.cuzLevel)! > 0 && Int(self.cuzLevel)! <= 40){
                self.cuzLevel = level!
                self.initBoard(level: Int(self.cuzLevel)!)
            } else{
                ProgressHUD.showError("Please give a valid number!")
                self.customizeBoard()
            }
        }
        alert.addTextField { (textField) in textField.placeholder = "Enter Mine"}
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func updateBoard(){
        for i in 0...80{
            let cellType : String
            cellType = sweeperGameBoard.displayCell(linearIndex: i)
            if(cellType == "") {
                gameBoardButtonArray[i].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
                gameBoardButtonArray[i].setImage(nil, for: .normal)
                gameBoardButtonArray[i].setTitle("", for: .normal)
                continue
            }
            if(cellType == "0") {gameBoardButtonArray[i].backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1); continue}
            if(cellType == "M"){
                gameBoardButtonArray[i].setImage(UIImage(named: "mine"), for: .normal)
            } else if(cellType == "F"){
                gameBoardButtonArray[i].setImage(UIImage(named: "flag"), for: .normal)
            } else {
                gameBoardButtonArray[i].backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
                gameBoardButtonArray[i].setTitle(cellType, for: .normal)
                gameBoardButtonArray[i].titleLabel?.font = UIFont(name: "futura", size: 20)
            }
            if(cellType == "1"){
                gameBoardButtonArray[i].setTitleColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), for: .normal)
            }
            if(cellType == "2"){
                gameBoardButtonArray[i].setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)
            }
            if(cellType == "3"){
                gameBoardButtonArray[i].setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
            }
            if(cellType == "4"){
                gameBoardButtonArray[i].setTitleColor(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), for: .normal)
            }
            if(cellType == "5"){
                gameBoardButtonArray[i].setTitleColor(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), for: .normal)
            }
            if(cellType == "6"){
                gameBoardButtonArray[i].setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .normal)
            }
            if(cellType == "7"){
                gameBoardButtonArray[i].setTitleColor(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), for: .normal)
            }
            if(cellType == "8"){
                gameBoardButtonArray[i].setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            }
            else {gameBoardButtonArray[i].setTitle(cellType, for: .normal)}
        }
    }
    
    
    
    func revealCellAt(linearIndex: Int){
        if(isGameOver){
            ProgressHUD.showError("Game is over!")
            return
        }
        if(indexSelected == -1){
            ProgressHUD.showError("Select a grid first!")
            return
        }
        
        if sweeperGameBoard.revealCell(linearIndex: indexSelected) == false{
            ProgressHUD.showError("The cell can't be revealed!")
            faceLogoButton.setImage(UIImage(named: "hmm_face"), for: .normal)
            return
        }
        
        if sweeperGameBoard.checkLose() == true{
            sweeperGameBoard.showAllMine()
            updateBoard()
            gameOver(didWin: false)
        } else {
            playSound(noteToPlay: "reveal")
            ProgressHUD.showSuccess("The cell is revealed!")
            faceLogoButton.setImage(UIImage(named: "smile_face"), for: .normal)
        }
        
        if(sweeperGameBoard.checkWin() == true){
            gameOver(didWin: true)
        }
    }
    
    
    func setFlagAt(linearIndex: Int){
        if(isGameOver){
            ProgressHUD.showError("Game is over!")
            return
        }
        if(linearIndex == -1){
            ProgressHUD.showError("Select a grid first!")
            return
        }
        
        let message : String = sweeperGameBoard.flagCell(linearIndex: indexSelected)
        
        if(message == "FAIL"){
            ProgressHUD.showError("Can't place flag here!")
        } else {
            ProgressHUD.showSuccess(message)
            if message == "A flag is removed!"{
                mineLeftVar += 1
                playSound(noteToPlay: "flagOff")
                faceLogoButton.setImage(UIImage(named: "hmm_face"), for: .normal)
            } else {
                mineLeftVar -= 1
                playSound(noteToPlay: "flagOn")
                faceLogoButton.setImage(UIImage(named: "smile_face"), for: .normal)
            }
        }
        
        if(sweeperGameBoard.checkWin() == true){
            gameOver(didWin: true)
        }
        if(mineLeftVar <= 0) {mineLeft.text = "Mine: " + "0"}
        else {mineLeft.text = "Mine: " + String(mineLeftVar)}
    }
    
    
    func gameOver(didWin: Bool){
        let title, mess : String
        isGameOver = true
        if didWin{
            playSound(noteToPlay: "win")
            title = "Congratulations You Win!"
            mess = "Want to play again? Click the face to restart!"
            faceLogoButton.setImage(UIImage(named: "cool_face"), for: .normal)
        } else {
            playSound(noteToPlay: "lose")
            title = "Sorry You Lose!"
            mess = "Want to play again? Click the face to restart!"
            faceLogoButton.setImage(UIImage(named: "dead_face"), for: .normal)
        }
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        let replayAction = UIAlertAction(title: "OK, I've Got It.", style: .default, handler: { (UIAlertAction) in self.doNothing()})
        alert.addAction(replayAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func resetGame(){
        sweeperGameBoard.resetBoard()
        updateBoard()
        resetUI()
        resetTimer()
    }
    
    
    func resetTimer(){
        label.text = "Time: " + "00" + "s"
        isPaused = false
        counter = 0
        startTimer()
    }
    
    
    func resetUI(){
        playSound(noteToPlay: "restart")
        isGameOver = false
        indexSelected = -1
        faceLogoButton.setImage(UIImage(named: "smile_face"), for: .normal)
        mineLeftVar = mineNum
        mineLeft.text = "Mine: " + String(mineLeftVar)
        for i in 0...gameBoardButtonArray.count-1{
            self.gameBoardButtonArray[i].backgroundColor = UIColor.white
            self.gameBoardButtonArray[i].setImage(nil, for: .normal)
            self.gameBoardButtonArray[i].setTitle(nil, for: .normal)
        }
        
        
    }
    
    func doNothing(){
        isPaused = true
        startTimer()
    }
  
    
    
    @IBAction func faceLogoButtonAction(_ sender: Any) {
        resetGame()
    }
    
    
    @IBAction func revealAction(_ sender: AnyObject) {
        indexSelected = sender.tag - 1
        self.gameBoardButtonArray[indexSelected].showsTouchWhenHighlighted = true
        playSound(noteToPlay: "cellClick")
    }
    
    
    @IBAction func setReveal(_ sender: Any) {
        revealCellAt(linearIndex: indexSelected)
        updateBoard()
    }
    
    
    @IBAction func setFlag(_ sender: Any) {
        setFlagAt(linearIndex: indexSelected)
        updateBoard()
    }
    
   
    @IBAction func reCustomize(_ sender: Any) {
        sweeperGameBoard.clearBoard()
        chooseLevel()
        resetUI()
        resetTimer()
    }
    
    
    
 
// Time Counter
    @IBOutlet weak var timeLabel: UILabel!
    
    var isPaused : Bool! = false
    var counter = 0
    var timer = Timer()
    
    @IBOutlet weak var label: UILabel!
    
   func cancelTimerButtonTapped() {
            timer.invalidate()
    }
    
    func startTimer(){
        if(!isPaused){
            timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        } else{
            timer.invalidate()
        }
    }
    
    @objc func timerAction() {
        counter += 1
        label.text = "Time: " + "\(counter)" + "s"
    }
    
  
    
    
// Sound player
    func playSound(noteToPlay : String) {
        guard let url = Bundle.main.url(forResource: noteToPlay, withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
