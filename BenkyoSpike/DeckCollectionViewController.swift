//
//  DeckCollectionViewController.swift
//  BenkyoSpike
//
//  Created by Jason Cheladyn on 9/23/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit
import AVFoundation

let cards = ["あ", "い", "う", "え", "お", "か", "き", "く", "け", "こ"]


class DeckCollectionViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    //#MARK: IB Outlets
    @IBOutlet var cardsCV:UICollectionView?
    @IBOutlet weak var recordButton: UIButton!
    
    //#MARK: Properties
    
    var layout = DeckCollectionViewLayout()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!

    
    //#MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsCV!.register(DeckCardCell.nib, forCellWithReuseIdentifier: DeckCardCell.identifier)
        cardsCV!.delegate = self
        cardsCV!.dataSource = self
        cardsCV!.collectionViewLayout = layout
        
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordButton.isUserInteractionEnabled = true
                        self.recordButton.isEnabled = true
                        self.recordButton.addTarget(self, action: #selector(self.recordTapped), for: .touchUpInside)
                    } else {
                        // failed to record!
                        NSLog("Failed to Record!")
                    }
                }
            }
        } catch {
            NSLog("Failed to Record!")
        }
    }
    
    func recordTapped() {
        NSLog("Record Tapped")
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

extension DeckCollectionViewController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog(String(indexPath.item))
    }
}

extension DeckCollectionViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeckCardCell.identifier, for: indexPath as IndexPath) as! DeckCardCell
        if cell.flipped { cell.flipCard() }
        return cell
    }
}
