//
//  TabBarView.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 27/11/23.
//

import UIKit

protocol TabBarViewDelegate
{
    func tabSelectedAtIndex(index:Int)
}

class TabBarView: UIView {
    
    @IBOutlet weak var forYouLbl: UILabel!
    @IBOutlet weak var forYouSelectedView: UIView!
    @IBOutlet weak var topTracksSelectedView: UIView!
    
    @IBOutlet weak var topTracksLbl: UILabel!
    
    
    var delegate:TabBarViewDelegate?
    
    var lastIndex : NSInteger!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        forYouSelectedView.layer.cornerRadius = 5
        topTracksSelectedView.layer.cornerRadius = 5
        topTracksLbl.alpha = 0.6
        topTracksSelectedView.isHidden = true
        initialize()
    }
    
    func initialize()
    {
        lastIndex = 0
    }
    
    @IBAction func tabBtnClicked(_ sender: UIButton)
    {
        let tabBtn: UIButton = sender
        lastIndex = tabBtn.tag - 1
        
        resetAllButton()
        selectTabButton()
    }
    
    func resetAllButton()
    {
        forYouLbl.alpha = 0.6
        topTracksLbl.alpha = 0.6
        forYouSelectedView.isHidden = true
        topTracksSelectedView.isHidden = true
    }
    
    func selectTabButton()
    {
        switch lastIndex {
        case 0:
            forYouLbl.alpha = 1.0
            forYouSelectedView.isHidden = false
            break
        case 1:
            topTracksLbl.alpha = 1.0
            topTracksSelectedView.isHidden = false
            break
        default:
            break
        }
        hepticFeedBackGenerator()
        delegate?.tabSelectedAtIndex(index: lastIndex)
    }
    
    
}
