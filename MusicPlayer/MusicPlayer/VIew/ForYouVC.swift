//
//  ForYouVC.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 25/11/23.
//

import UIKit
import AVFoundation

class ForYouVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tblView: UITableView!
    
    private var musicList : [Musics] = []
    let activityIndicatoryView  = UIActivityIndicatorView()
    var player : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupIndicatorView()
        configUI()
    }
    
    func setupIndicatorView() {
        view.addSubview(activityIndicatoryView)
        activityIndicatoryView.startAnimating()
        
        activityIndicatoryView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatoryView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicatoryView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func configUI() {
        tblView.register(UINib(nibName: "MusicTVC", bundle: nil), forCellReuseIdentifier: "MusicTVC")
        APIManager.shared.fetchMusics { data in
            if !data.data.isEmpty {
                self.musicList = data.data
                DispatchQueue.main.async {
                    self.activityIndicatoryView.stopAnimating()
                    self.activityIndicatoryView.removeFromSuperview()
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "MusicTVC", for: indexPath) as! MusicTVC
        let listInfo = musicList[indexPath.row]
        let imageUrl = URL(string: "\(APIManager.shared.IMAGE_URL)\(listInfo.cover)")!
        cell.musicCoverImage.getImage(imageURL: imageUrl)
        cell.musicNameLbl.text = listInfo.name
        cell.artistNameLbl.text = listInfo.artist
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        PlayerManager.shared.currentTrackIndex = indexPath.row
//        PlayerManager.shared.currentTrack = musicList[indexPath.row]
//        GlobalPlayBar.shared.isHidden = false
////        GlobalPlayBar.shared.setupCurrentTrackData()
//        PlayerManager.shared.prepareToPlayTrack(musicList[indexPath.row].url)
        
        let vc = SongPlayerVC()
        vc.selectedMusic = musicList[indexPath.row]
        vc.musicList = musicList
        vc.position = indexPath.row
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationCapturesStatusBarAppearance = true
        AppDelegate().sharedDelegate().tabBarController.present(vc, animated: true)
//        self.navigationController?.present(vc, animated: true)
    }
}
