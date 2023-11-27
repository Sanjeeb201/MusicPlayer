//
//  SongPlayerScreen.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 25/11/23.
//

import UIKit

class SongPlayerScreen: UIViewController {
    
    @IBOutlet weak var songsCoverCV: UICollectionView!
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var songArtistNameLbl: UILabel!
    @IBOutlet weak var playerProgressBar: UIProgressView!
    @IBOutlet weak var currentPlayerTImeLbl: UILabel!
    @IBOutlet weak var songMaxDurationLbl: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    var musicList : [Musics] = []
    var selectedMusic : Musics = Musics()
    var position = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .top
        
        applyGradientColor()
        setupInitialSongState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUI()
    }
    
    
    func applyGradientColor() {
        let topColor = colorFromHex(hex: selectedMusic.accent)
        let bottomColor = UIColor.black.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        view.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configUI() {
        songsCoverCV.register(UINib(nibName: "SongsCoverImageCVC", bundle: nil), forCellWithReuseIdentifier: "SongsCoverImageCVC")
        songsCoverCV.decelerationRate = .fast
//        songsCoverCV.isPagingEnabled = true
    }
    
    func setupInitialSongState() {
        // Set the selected song's name label
        songNameLbl.text = selectedMusic.name

        // Set the selected song's artist name label
        songArtistNameLbl.text = selectedMusic.artist

        // Set the initial progress bar value
        playerProgressBar.progress = 0
        let indexPath = IndexPath(item: position, section: 0)
        DispatchQueue.main.async {
            let offsetX = CGFloat(self.position) * self.songsCoverCV.frame.width - 65 - 30
            let visibleRect = CGRect(origin: CGPoint(x: offsetX, y: 0), size: self.songsCoverCV.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//            self.songsCoverCV.center = visiblePoint
//            self.songsCoverCV.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
//            self.songsCoverCV.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//            self.songsCoverCV.beginInteractiveMovementForItem(at: indexPath)
            self.songsCoverCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//            self.songsCoverCV.reloadData()
        }

    }

}

extension SongPlayerScreen : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 65, height: UIScreen.main.bounds.width - 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = songsCoverCV.dequeueReusableCell(withReuseIdentifier: "SongsCoverImageCVC", for: indexPath) as! SongsCoverImageCVC
        let listInfo = musicList[indexPath.row]
        let imageUrl = URL(string: "\(APIManager.shared.IMAGE_URL)\(listInfo.cover)")!
        cell.songsCoverImage.getImage(imageURL: imageUrl)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: songsCoverCV.contentOffset, size: songsCoverCV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = songsCoverCV.indexPathForItem(at: visiblePoint) else { return }
        
        let cellWidth = UIScreen.main.bounds.width - 60  // Adjust this based on your cell size
        let offsetX = CGFloat(indexPath.row) * cellWidth
        songsCoverCV.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        
        self.playerProgressBar.progress = 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = songsCoverCV.frame.width
        let targetXContentOffset = targetContentOffset.pointee.x
        let contentOffset = scrollView.contentOffset.x
        var newTargetXContentOffset = CGFloat(position) * pageWidth

        if targetXContentOffset > contentOffset {
            // Scrolling to the right
            newTargetXContentOffset += pageWidth
        } else if targetXContentOffset < contentOffset {
            // Scrolling to the left
            newTargetXContentOffset -= pageWidth
        }

        targetContentOffset.pointee.x = newTargetXContentOffset
    }

    
    
    
    
}
