//
//  NowPlayingArtView.swift
//  SixLS
//
//  Created by Skitty on 3/2/21.
//  Copyright © 2020 Skitty. All rights reserved.
//

import UIKit

final class NowPlayingArtView: UIView {
	let backgroundView = UIView()
	let artworkContainer = UIView()
	let artworkImageView = UIImageView()

	private var statusBarHeight: CGFloat {
		var height: CGFloat = 0
		if #available(iOS 14.0, *) {
			height = CGFloat(UIStatusBar._height(forStyle: 306,
												 orientation: 1,
												 forStatusBarFrame: false,
												 inWindow: nil))
			if height <= 0 {
				height = CGFloat(UIStatusBar_Modern._height(forStyle: 1,
															orientation: 1,
															forStatusBarFrame: false,
															inWindow: nil))
			}
		} else {
			height = CGFloat(UIStatusBar._height(forStyle: 306,
												 orientation: 1,
												 forStatusBarFrame: false))
			if height <= 0 {
				height = CGFloat(UIStatusBar_Modern._height(forStyle: 1,
															orientation: 1,
															forStatusBarFrame: false))
			}
		}
		return height
	}

	override init(frame: CGRect) {
		backgroundView.backgroundColor = .black
		backgroundView.translatesAutoresizingMaskIntoConstraints = false

		artworkContainer.translatesAutoresizingMaskIntoConstraints = false
		artworkImageView.translatesAutoresizingMaskIntoConstraints = false

		super.init(frame: frame)

		addSubview(backgroundView)
		addSubview(artworkContainer)
		artworkContainer.addSubview(artworkImageView)

		updateImage()
		activateConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) not implemented")
	}

	convenience init() {
		self.init(frame: .zero)
	}

	func activateConstraints() {
		backgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		backgroundView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		artworkContainer.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		artworkContainer.heightAnchor.constraint(equalTo: heightAnchor, constant: -(statusBarHeight + 228)).isActive = true
		artworkContainer.topAnchor.constraint(equalTo: topAnchor, constant: statusBarHeight + 133).isActive = true

		artworkImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		artworkImageView.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
		artworkImageView.centerYAnchor.constraint(equalTo: artworkContainer.centerYAnchor).isActive = true
	}

	func updateImage() {
		artworkImageView.backgroundColor = .red
	}
}
