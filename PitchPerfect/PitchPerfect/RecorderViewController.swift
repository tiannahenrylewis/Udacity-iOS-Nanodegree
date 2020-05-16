//
//  RecorderViewController.swift
//  PitchPerfect
//
//  Created by Tianna Henry-Lewis on 2020-04-20.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK:- Variables
    var audioRecorder: AVAudioRecorder!
    var currentlyRecording = false

    //MARK:- Storyboard Connections
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    //MARK:- Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(recording: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSegue" {
            let playerVC = segue.destination as! PlayerViewController
            let recordedAudioURL = sender as! URL
            playerVC.recordedAudioURL = recordedAudioURL
        }
    }

    //MARK:- IBActions
    @IBAction func tappedRecordButton(_ sender: Any) {
        //Call function that handles recording audio
        startRecording()
        
        //Call function that handles updated the record and stop Button states
        configureUI(recording: currentlyRecording)
    }
    
    @IBAction func tappedStopButton(_ sender: Any) {
        //Call function that handles stopping the recording ofaudio
        stopRecording()
        
        //Call function that handles updated the record and stop Button states
        configureUI(recording: currentlyRecording)
    }
    
     //MARK:- Functions
    func configureUI(recording: Bool) {
        if recording == false {
            recordLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            stopButton.isEnabled = false
        } else {
            recordLabel.text = "Recording in Progress"
            recordButton.isEnabled = false
            stopButton.isEnabled = true
        }
    }
    
    func startRecording() {
        currentlyRecording = true
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let filename = "pitchperfect_recording.wav"
        let pathArray = [directoryPath, filename]
        let filepath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filepath!, settings: [:])
        //Conform to AVAudioRecorderDelegate
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording() {
        currentlyRecording = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //Action that will commence once the audio recorder has completed saving the recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true {
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        } else {
            showSaveErrorAlert()
        }
    }
    
    //Shows an alert popup notifying the user is there was error saving their recording to memory
    func showSaveErrorAlert() {
        let saveAlertController = UIAlertController(title: "Audio Save Error", message: "There was an error saving your recording, please try again.", preferredStyle: .alert)
        saveAlertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
        self.present(saveAlertController, animated: true)
    }
    
    
}

