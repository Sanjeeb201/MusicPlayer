//
//  PlayerManager.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 27/11/23.
//

import Foundation
import UIKit
import AVFoundation

final class PlayerManager : NSObject, AVAudioPlayerDelegate {
    static let shared = PlayerManager()
    
    
    var musicList : [Musics] = [Musics]()
    var currentTrack : Musics = Musics()
    var currentTrackIndex : Int = Int()
    
    var player : AVAudioPlayer?
    
    func prepareToPlayTrack(_ songUrl : String) {
        DispatchQueue.global().async {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                print("Playback OK")
                try AVAudioSession.sharedInstance().setActive(true)
                print("Session is Active")
                self.playSong(songUrl)
            } catch {
                let alert = UIAlertController(title: "Plaback Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                AppDelegate().sharedDelegate().window?.rootViewController?.present(alert, animated: true)
                print(error)
            }
        }

    }
    
    
    func playSong(_ songUrl : String) {
        DispatchQueue.global().async {
            do {
                if let url = URL(string: songUrl) {
                    let soundData = try Data(contentsOf: url)
                    self.player = try AVAudioPlayer(data: soundData)
                    self.player?.prepareToPlay()
                    self.player?.delegate = self
                    self.player?.play()
                }
            } catch {
                print(error)
            }
        }

    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
//        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_HOME), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_PLAY_PAUSE), object: nil)
        
        if let index = musicList.firstIndex(where: { $0.id == currentTrack.id }) {
            if index == musicList.count - 1 {
                currentTrackIndex = 0
            } else {
                currentTrackIndex = index + 1
            }
            setupCurrentSong()
        }
        
    }
    
    
    //No use of this methode
    func activateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    //No use of this methode
    func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    // for play next song
    func playNextSong() {
        if let index = musicList.firstIndex(where: { $0.id == currentTrack.id }) {
            if index == musicList.count - 1 {
                currentTrackIndex = 0
            } else {
                currentTrackIndex = index + 1
            }
            setupCurrentSong()
        }
    }
    
    // for previous song play
    func playPreviousSong() {
        
        if let index = musicList.firstIndex(where: { $0.id == currentTrack.id }) {
            if index == musicList.count - 1 {
                currentTrackIndex = index - 1
            } else {
                currentTrackIndex = 0
            }
            setupCurrentSong()
        }
    }
    
    // This function use for setup current song id and song detail
    // Ansd start playing
    func setupCurrentSong() {
        currentTrack = musicList[currentTrackIndex]

//       NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_MUSIC_SCREEN), object: nil)
        prepareToPlayTrack(currentTrack.url)
    }

    
}
