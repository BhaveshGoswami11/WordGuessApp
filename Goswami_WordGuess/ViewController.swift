//
//  ViewController.swift
//  Goswami_WordGuess
//
//  Created by Bhavesh on 10/10/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var totalWordsLabel: UILabel!
    @IBOutlet weak var userGuessLabel: UILabel!
    @IBOutlet weak var guessLetterField: UITextField!
    @IBOutlet weak var guessALetterBtn: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var guessCountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var displayImage: UIImageView!
    
    var words = [["JAVA", "Programming Language"],["DOG", "Animal"],["COLD", "Weather Condition"],["APPLE", "Fruit"],["HP","Laptop Brand"]]
        
        var currentWordIndex = 0
        var word = ""
        var lettersGuessed = ""
        var wordsGuessed = 0
        var maxNumOfWrongGuesses = 10
        var totalGuesses = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            playAgainButton.isHidden = true
            updateStatistics()
            resetGame()
        }
        
        func updateStatistics() {
            wordsGuessedLabel.text = "Total number of words guessed successfully: \(wordsGuessed)"
            wordsRemainingLabel.text = "Total number of words remaining in game: \(words.count - wordsGuessed)"
            totalWordsLabel.text = "Total number of words in game: \(words.count)"
        }
        
        func resetGame() {
            // Check if all words are guessed
            if currentWordIndex >= words.count {
                statusLabel.text = "Congratulations, You are done, Please start over again"
                wordsRemainingLabel.text = "Total number of words remaining in game: 0"
                playAgainButton.isHidden = false
                guessLetterField.isEnabled = false
                return
            }
            
            word = words[currentWordIndex][0]
            lettersGuessed = ""
            totalGuesses = 0
            guessCountLabel.text = "You have made Zero guesses"
            statusLabel.text = ""
            guessLetterField.text = ""
            guessLetterField.isEnabled = true
            guessALetterBtn.isEnabled = false
            playAgainButton.isHidden = true
            displayImage.image = nil
            hintLabel.text = "Hint: \(words[currentWordIndex][1])"
            
            updateWordDisplay()
        }
        
        func updateWordDisplay() {
            userGuessLabel.text = ""
            
            for letter in word {
                if lettersGuessed.contains(letter) {
                    userGuessLabel.text! += "\(letter) "
                } else {
                    userGuessLabel.text! += "_ "
                }
            }
            userGuessLabel.text = userGuessLabel.text?.trimmingCharacters(in: .whitespaces)
        }
    
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        guessALetterBtn.isEnabled = false
                
                guard let letter = guessLetterField.text?.uppercased(), !letter.isEmpty else {
                    return
                }
                
                // Add letter to guessed letters if not already guessed
                if !lettersGuessed.contains(letter) {
                    lettersGuessed += letter
                }
                
                totalGuesses += 1
                updateWordDisplay()
                
                // Check if letter is in the word
                if word.contains(letter) {
                    // Correct guess
                    if !userGuessLabel.text!.contains("_") {
                        // Word is completely guessed
                        wordsGuessed += 1
                        updateStatistics()
                        
                        displayImage.image = UIImage(named: word)
                        playAgainButton.isHidden = false
                        guessLetterField.isEnabled = false
                        
                        // Check if all words are done
                        if wordsGuessed == words.count {
                            statusLabel.text = "Congratulations, You are done, Please start over again"
                            wordsRemainingLabel.text = "Total number of words remaining in game: 0"
                        } else {
                            statusLabel.text = "You've guessed it correctly! '\(word)'"
                        }
                        
                        // Check if used all 10 guesses
                        if totalGuesses == maxNumOfWrongGuesses {
                            guessCountLabel.text = "Wow!, You have made 10 guesses to guess the word"
                        } else {
                            guessCountLabel.text = "You have made \(totalGuesses) \(totalGuesses == 1 ? "guess" : "guesses")"
                        }
                    } else {
                        // Correct letter but word not complete
                        statusLabel.text = "Good guess! Keep going."
                        guessCountLabel.text = "You have made \(totalGuesses) \(totalGuesses == 1 ? "guess" : "guesses")"
                    }
                } else {
                    // Wrong guess
                    statusLabel.text = "Wrong guess. Try again."
                    guessCountLabel.text = "You have made \(totalGuesses) \(totalGuesses == 1 ? "guess" : "guesses")"
                    
                    // Check if all 10 guesses are used
                    if totalGuesses >= maxNumOfWrongGuesses {
                        statusLabel.text = "You have used all the available guesses, Please play again"
                        guessCountLabel.text = "You have made 10 guesses"
                        playAgainButton.isHidden = false
                        guessLetterField.isEnabled = false
                    }
                }
                
                guessLetterField.text = ""
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        // If all words are done, reset to beginning
                if wordsGuessed == words.count {
                    currentWordIndex = 0
                    wordsGuessed = 0
                    updateStatistics()
                    resetGame()
                    return
                }
                
                // If current word was guessed correctly (no underscore), move to next word
                if !userGuessLabel.text!.contains("_") {
                    currentWordIndex += 1
                }
                // If word was not guessed (has underscore), stay on same word (give another chance)
                
                resetGame()
    }
    
    
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, text.count > 1 {
                    textField.text = String(text.last!)
                }
                
                guessALetterBtn.isEnabled = textField.text?.isEmpty == false
            }
        }
