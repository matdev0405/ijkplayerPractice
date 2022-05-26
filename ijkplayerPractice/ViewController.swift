//
//  ViewController.swift
//  ijkplayerPractice
//
//  Created by User on 2021/7/27.
//

import UIKit
import IJKMediaFramework

class ViewController: UIViewController {
        
    var player: IJKFFMoviePlayerController!
    var rtmpPlayUrl = "rtmp://stream.asiamedia.xyz/usca7j900sfqtk9tf2u1cf/stca7jb38sfqtk9tf2u0b5?txSecret=a3afbc70f8b813d661aa329a7719f2df&txTime=6290870D"
    
    var previewView : UIView = {
        let slsv = UIView()
        slsv.translatesAutoresizingMaskIntoConstraints = false
        slsv.backgroundColor = .white
        return slsv
    }()
    
    var statusLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 80, height: 40))
        stateLabel.text = "未連接"
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        view.addSubview(previewView)
        previewView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        previewView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        previewView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        view.addSubview(statusLabel)
        
        let urlString = rtmpPlayUrl
        player = IJKFFMoviePlayerController(contentURLString: urlString, with: IJKFFOptions.byDefault())
        
        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player.view.frame = previewView.bounds
        previewView.addSubview(player.view)
        

        player.prepareToPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.play()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player, queue: OperationQueue.main, using: { [weak self] notification in
            
            guard let this = self else {
                return
            }
            let state = this.player.loadState
            switch state {
            case IJKMPMovieLoadState.playable:
                this.statusLabel.text = "Playable"
            case IJKMPMovieLoadState.playthroughOK:
                this.statusLabel.text = "Playing"
            case IJKMPMovieLoadState.stalled:
                this.statusLabel.text = "Buffering"
            default:
                this.statusLabel.text = "Playing"
            }
        })

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.shutdown()
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    

        
}

