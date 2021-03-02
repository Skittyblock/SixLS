//
//  LockBarView.swift
//  SixLS
//
//  Created by Skitty on 9/20/20.
//  Copyright © 2020 Skitty. All rights reserved.
//

import UIKit

class LockBarView: UIView {
	var backgroundView: UIImageView
	var unlockSlider: GlintySlider
	var cameraGrabber: UIImageView

	private var cameraTapGestureRecognizer: UITapGestureRecognizer?
	private var cameraPanGestureRecognizer: UIPanGestureRecognizer?

	var delegate: LockBarViewDelegate? {
		didSet {
			unlockSlider.delegate = delegate
			if let delegate = delegate {
				cameraTapGestureRecognizer = UITapGestureRecognizer(target: delegate,
																	action: #selector(delegate.cameraTapped(_:)))
				cameraPanGestureRecognizer = UIPanGestureRecognizer(target: delegate,
																	action: #selector(delegate.cameraDragged(_:)))
				cameraGrabber.addGestureRecognizer(cameraTapGestureRecognizer!)
				cameraGrabber.addGestureRecognizer(cameraPanGestureRecognizer!)
			}
		}
	}

	override init(frame: CGRect) {
		backgroundView = UIImageView(image: UIImage.forSix(named: "lock"))
		backgroundView.translatesAutoresizingMaskIntoConstraints = false

		unlockSlider = GlintySlider(frame: .zero) // CGRect(x: 20, y: 22, width: frame.size.width - 88, height: 52)
		unlockSlider.text = "slide to unlock"
		unlockSlider.font = UIFont(name: "Helvetica", size: 21)
		unlockSlider.centerWithIcon = true
		unlockSlider.translatesAutoresizingMaskIntoConstraints = false

		cameraGrabber = UIImageView()
		cameraGrabber.image = UIImage.forSix(named: "camera")
		cameraGrabber.isUserInteractionEnabled = true
		cameraGrabber.translatesAutoresizingMaskIntoConstraints = false

		super.init(frame: frame)

		addSubview(backgroundView)
		addSubview(unlockSlider)
		addSubview(cameraGrabber)

		backgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		backgroundView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		unlockSlider.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		unlockSlider.heightAnchor.constraint(equalToConstant: 52).isActive = true

		if UIDevice.current.model.hasPrefix("iPad") {
			unlockSlider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
			unlockSlider.widthAnchor.constraint(equalToConstant: 256).isActive = true

			cameraGrabber.isHidden = true
		} else {
			unlockSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
			unlockSlider.widthAnchor.constraint(equalTo: widthAnchor, constant: -88).isActive = true

			cameraGrabber.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19).isActive = true
			cameraGrabber.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
			cameraGrabber.widthAnchor.constraint(equalToConstant: 30).isActive = true
			cameraGrabber.heightAnchor.constraint(equalToConstant: 52).isActive = true
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) not implemented")
	}

	convenience init() {
		self.init(frame: .zero)
	}
}
