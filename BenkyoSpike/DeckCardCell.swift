//
//  DeckCell.swift
//  BenkyoSpike
//
//  Created by Jason Cheladyn on 11/21/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

import AVFoundation



class DeckCardCell: UICollectionViewCell, AVAudioRecorderDelegate {
    
    //#MARK: Statics
    static let identifier = "DeckCardCell"
    
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    //#MARK: Properties
  
    
    var cardFront = DeckCardFrontView.Card()
    var cardBack  = DeckCardBackView.Card()
    var flipped   = false
    
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let cardrect = CGRect(x: 0, y: 0, width: DeckCollectionViewLayout.cardSize.width, height: DeckCollectionViewLayout.cardSize.height)
        
                
        cardBack.frame  = cardrect
        cardFront.frame = cardrect
        addSubview(cardFront)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DeckCardCell.tapped))
        tap.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(tap)
        contentView.isUserInteractionEnabled = true
        
        
        //DatabaseThing().setupDB()
        //DatabaseThing().addTestData()
        let db = DatabaseThing().theDB()
        
        
        for card in try! db.prepare(DatabaseThing().cards) {
            print("id: \(card[DatabaseThing().id]), email: \(card[DatabaseThing().frontText])")
        }
        
        if let card = try! db.pluck(DatabaseThing().cards) {
            let fText = card[DatabaseThing().frontText]
            let bText = card[DatabaseThing().backText]
            cardFront.frontText.text = fText
            cardBack.backText.text = bText
        }
        

        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.cardBack.recordButton.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
     
    }
    
    
    func tapped() {
        NSLog("\(DeckCardCell.identifier) :Tapped!")
        flipCard(animated: true)
    }
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func flipCard(animated:Bool=false) {
        let dur:TimeInterval = animated ? 0.5 : 0
        if flipped {
            UIView.transition(from: cardBack, to: cardFront, duration: dur, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
        }else{
            UIView.transition(from: cardFront, to:cardBack , duration: dur, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        }
        flipped = !flipped
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
}

class CardView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Cell Corner and Shadows
        layer.cornerRadius = 10
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        layer.borderWidth = 1
        // Emphasize the shadow on the bottom and right sides of the cell
        layer.shadowOffset = CGSize(width: 4, height: 4)
        
        
    }
}


