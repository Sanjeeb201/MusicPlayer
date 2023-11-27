//
//  GlobalPlayBar.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 27/11/23.
//

import Foundation
import UIKit

class GlobalPlayBar : UIView {
    
    static let shared: GlobalPlayBar = {
        let instance = GlobalPlayBar()
        // Additional setup if needed
        return instance
    }()
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var songConverImage: ImageLoadView!
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        songConverImage.layer.cornerRadius = songConverImage.frame.height / 2
        playPauseBtn.addTarget(self, action: #selector(playPauseSong), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(changeSong), for: .touchUpInside)
        self.isHidden = true
        setupCurrentTrackData()
    }
    
    func setupCurrentTrackData() {
        DispatchQueue.main.async {
            self.songConverImage.getImage(imageURL: URL(string: "\(APIManager.shared.IMAGE_URL)\(PlayerManager.shared.currentTrack.cover)")!)
            self.songNameLbl.text = PlayerManager.shared.currentTrack.name
            
            if (PlayerManager.shared.player != nil && PlayerManager.shared.player!.isPlaying) {
                self.playPauseBtn.isSelected = true
            }else{
                self.playPauseBtn.isSelected = false
            }
        }

    }
    
    @objc func playPauseSong() {
        if let player = PlayerManager.shared.player {
            let isPlaying = player.isPlaying
            playPauseBtn.setBackgroundImage(UIImage(systemName: isPlaying ? "play.circle.fill" : "pause.circle.fill"), for: .normal)

            if isPlaying {
                player.pause()
            } else {
                player.play()
            }
        }
    }


    
    @objc func changeSong() {
        PlayerManager.shared.playNextSong()
    }
}
