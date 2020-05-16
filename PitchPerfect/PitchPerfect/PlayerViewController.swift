//
//  PlayerViewController.swift
//  PitchPerfect
//
//  Created by Tianna Henry-Lewis on 2020-04-22.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    //MARK: - Variables
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, highPitch, lowPitch, echo, reverb
    }
    
    //MARK: - Storyboard Connections
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    //MARK: - IB Actions
    //Function handles the playback of audio, the effect played is determined by the button pressed which is registered through it's tag
    @IBAction func playSoundForButton(buttonPressed: UIButton) {
        switch(ButtonType(rawValue: buttonPressed.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitch:
            playSound(pitch: 1000)
        case .lowPitch:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }

        configureUI(.playing)
    }
    
    @IBAction func stopButtonTapped() {
        stopAudio()
    }

}
