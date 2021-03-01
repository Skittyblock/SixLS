//
//  LockBarViewDelegate.swift
//  SixLS
//
//  Created by Skitty on 11/27/20.
//  Copyright © 2020 Skitty. All rights reserved.
//

import UIKit

@objc protocol LockBarViewDelegate {
    func sliderStopped(_ slider: UISlider)
    func sliderMoved(_ slider: UISlider)
    func cameraTapped(_ gesture: UITapGestureRecognizer)
    func cameraDragged(_ gesture: UIPanGestureRecognizer)
}
