//
//  SongPlayerVC.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 26/11/23.
//

import UIKit

class SongPlayerVC: UIViewController {
    
    lazy var containerView : UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topDraggerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 2.5
        view.clipsToBounds = true
        return view
    }()
    
    
    lazy var songsCoverCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(UINib(nibName: "SongsCoverImageCVC", bundle: nil), forCellWithReuseIdentifier: "SongsCoverImageCVC")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    
    lazy var songNameLbl : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lable.textColor = .label
        return lable
    }()
    
    lazy var artistNameLbl : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textColor = .label
        lable.alpha = 0.6
        return lable
    }()
    
    lazy var progressBar : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.tintColor = .white
        slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        slider.addTarget(self, action: #selector(updateTrackDurationData), for: .valueChanged)
        return slider
    }()
    
    lazy var currentSongDurationLbl : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        lable.textAlignment = .left
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.text = "0.0"
        lable.textColor = .label
        
        return lable
    }()
    
    lazy var totalSongDurationLbl : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textColor = .label
        lable.text = "0.0"
        return lable
    }()
    
    lazy var playPauseBtn : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(playPauseSong), for: .touchUpInside)
        return button
    }()
    
    lazy var nextBtn : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(changeSong), for: .touchUpInside)
        return button
    }()
    
    lazy var previousBtn : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(changeSong), for: .touchUpInside)
        return button
    }()
    
    var defaultHeight : CGFloat = UIScreen.main.bounds.height
    var dismissableHeight : CGFloat = UIScreen.main.bounds.height / 2
    var safeAreaHeight = 0.0
    
    var sharedPlayer : PlayerManager = PlayerManager()
    
    
    var musicList : [Musics] = []
    var selectedMusic : Musics = Musics()
    var position = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupPanGesture()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        AppDelegate().sharedDelegate().hideTabBar()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate().sharedDelegate().showTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.applyGradientColor(accentColor: selectedMusic.accent)

        // Create a top rounded corner as per screen corener radius
        let maskPath = UIBezierPath(roundedRect: containerView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 40.0, height: 40.0))

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        containerView.layer.mask = maskLayer

    }
    
    
    func setupConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(topDraggerView)
        containerView.addSubview(songsCoverCV)
        containerView.addSubview(songNameLbl)
        containerView.addSubview(artistNameLbl)
        containerView.addSubview(progressBar)
        containerView.addSubview(currentSongDurationLbl)
        containerView.addSubview(totalSongDurationLbl)
        containerView.addSubview(playPauseBtn)
        containerView.addSubview(nextBtn)
        containerView.addSubview(previousBtn)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        topDraggerView.translatesAutoresizingMaskIntoConstraints = false
        songsCoverCV.translatesAutoresizingMaskIntoConstraints = false
        songNameLbl.translatesAutoresizingMaskIntoConstraints = false
        artistNameLbl.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        currentSongDurationLbl.translatesAutoresizingMaskIntoConstraints = false
        totalSongDurationLbl.translatesAutoresizingMaskIntoConstraints = false
        playPauseBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        previousBtn.translatesAutoresizingMaskIntoConstraints = false

        
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // set container static constraint (trailing & leading)
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // set topDraggerView constraints
            // Set topDraggerView constraints
            topDraggerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            topDraggerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            topDraggerView.widthAnchor.constraint(equalToConstant: 40),
            topDraggerView.heightAnchor.constraint(equalToConstant: 5),
            
            // set tableView constraints
            songsCoverCV.topAnchor.constraint(equalTo: topDraggerView.bottomAnchor, constant: 30),
            songsCoverCV.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            songsCoverCV.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            songsCoverCV.bottomAnchor.constraint(equalTo: songNameLbl.topAnchor, constant: -50),
            
            songNameLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            songNameLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            songNameLbl.heightAnchor.constraint(equalToConstant: 30),
            songNameLbl.bottomAnchor.constraint(equalTo: artistNameLbl.topAnchor, constant: -5),
            
            artistNameLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            artistNameLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            artistNameLbl.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -50),
            artistNameLbl.heightAnchor.constraint(equalToConstant: 20),
            
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 5),
            progressBar.bottomAnchor.constraint(equalTo: playPauseBtn.topAnchor, constant: -70),
            
            currentSongDurationLbl.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: 0),
            currentSongDurationLbl.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
            
            totalSongDurationLbl.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor, constant: 0),
            totalSongDurationLbl.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
            
            playPauseBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playPauseBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -100),
            playPauseBtn.heightAnchor.constraint(equalToConstant: 65),
            playPauseBtn.widthAnchor.constraint(equalToConstant: 65),
            
            nextBtn.centerYAnchor.constraint(equalTo: playPauseBtn.centerYAnchor),
            nextBtn.leadingAnchor.constraint(equalTo: playPauseBtn.trailingAnchor, constant: 50),
            nextBtn.heightAnchor.constraint(equalToConstant: 25),
            nextBtn.widthAnchor.constraint(equalToConstant: 30),
            
            previousBtn.centerYAnchor.constraint(equalTo: playPauseBtn.centerYAnchor),
            previousBtn.trailingAnchor.constraint(equalTo: playPauseBtn.leadingAnchor, constant: -50),
            previousBtn.heightAnchor.constraint(equalToConstant: 25),
            previousBtn.widthAnchor.constraint(equalToConstant: 30)
            
        ])
        setupCurrentSongData()
        
        
    }
    
    
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        panGesture.cancelsTouchesInView = false
        containerView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let dragVelocity = gesture.velocity(in: view)
        switch gesture.state {
        case .changed:
            self.containerView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            if dragVelocity.y > 500 {
                dismiss(animated: true)
            } else if translation.y < dismissableHeight {
                UIView.animate(withDuration: 0.3){
                    self.containerView.transform = .identity
                }
            }
            else {
                dismiss(animated: true)
            }
        default:
            break
        }
        
    }
    
    func setupCurrentSongData() {
        songNameLbl.text = selectedMusic.name
        artistNameLbl.text = selectedMusic.artist
        if let currentTime = sharedPlayer.player?.currentTime.magnitude {
            progressBar.value = Float(currentTime)
        }
        let indexPath = IndexPath(item: position, section: 0)
        DispatchQueue.main.async {
            self.songsCoverCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    @objc func playPauseSong() {
        if let isPlaying = PlayerManager.shared.player?.isPlaying {
            if isPlaying {
                PlayerManager.shared.player?.stop()
                playPauseBtn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            } else {
                playPauseBtn.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            }
        } else {
            PlayerManager.shared.prepareToPlayTrack(selectedMusic.url)
            playPauseBtn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }
    
    @objc func changeSong(button : UIButton) {
        if button == nextBtn {
            PlayerManager.shared.playNextSong()
        } else {
            PlayerManager.shared.playPreviousSong()
        }
    }
    
    @objc func updateTrackDurationData() {
        PlayerManager.shared.player?.play(atTime: TimeInterval(progressBar.value))
        currentSongDurationLbl.text = String(progressBar.value)
    }
    
    
}

extension SongPlayerVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
//        songsCoverCV.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        self.selectedMusic = musicList[indexPath.row]
        self.position = indexPath.row
        self.progressBar.value = 0
        PlayerManager.shared.prepareToPlayTrack(selectedMusic.url)
        setupCurrentSongData()
    }
}
