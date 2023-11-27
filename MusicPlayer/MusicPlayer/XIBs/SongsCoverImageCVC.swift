//
//  SongsCoverImageCVC.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 25/11/23.
//

import UIKit

class SongsCoverImageCVC: UICollectionViewCell {
    
    @IBOutlet weak var songsCoverImage: ImageLoadView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.songsCoverImage.layer.cornerRadius = 5
        // Initialization code
    }

}
