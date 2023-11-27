//
//  DraggableView.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 25/11/23.
//

import UIKit

protocol DraggableViewDelegate: AnyObject {
    func dismissDraggableView()
}

class DraggableView: UIView {

    weak var delegate: DraggableViewDelegate?
    
    override func awakeFromNib() {
        backgroundColor = .red
    }

    // Implement your player UI elements and controls here within this view

    // Add necessary UI elements, setup constraints, and design your player UI
}
