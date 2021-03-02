//
//  DateBarView.swift
//  SixLS
//
//  Created by Skitty on 9/20/20.
//  Copyright © 2020 Skitty. All rights reserved.
//

import UIKit

class DateBarView: UIView {
	var backgroundView: UIImageView
	var timeLabel = UILabel()
	var dateLabel = UILabel()

	let nowPlayingView = UIView()

	var artistLabel = UILabel()
	var songLabel = UILabel()
	var albumLabel = UILabel()

	let timeFormatter = DateFormatter()
	let dateFormatter = DateFormatter()

	var isPlaying = false {
		didSet {
			updatePlayingState()
		}
	}
	var nowPlayingInfo = [String: String]()

	override init(frame: CGRect) {
		backgroundView = UIImageView(image: UIImage.forSix(named: "lock")?
												   .resizableImage(withCapInsets: UIEdgeInsets(top: 70,
												   											   left: 0,
																							   bottom: 10,
																							   right: 0),
																   resizingMode: .stretch))
		backgroundView.translatesAutoresizingMaskIntoConstraints = false

		super.init(frame: frame)

		format(label: &timeLabel)
		timeLabel.font = UIFont(name: "LockClock-Light", size: 65)
		timeLabel.layer.shadowOpacity = 0.6

		format(label: &dateLabel, size: 17)
		format(label: &artistLabel, size: 12, bold: true)
		format(label: &songLabel, size: 12, bold: true)
		format(label: &albumLabel, size: 12, bold: true)

		nowPlayingView.isHidden = true
		nowPlayingView.translatesAutoresizingMaskIntoConstraints = false

		if UIDevice.current.model.hasPrefix("iPad") {
			timeLabel.font = UIFont(name: "LockClock-Light", size: 58)
		}

		addSubview(backgroundView)
		addSubview(timeLabel)
		addSubview(dateLabel)
		addSubview(nowPlayingView)

		nowPlayingView.addSubview(artistLabel)
		nowPlayingView.addSubview(songLabel)
		nowPlayingView.addSubview(albumLabel)

		activateConstraints()
		updatePlayingState()

		timeFormatter.dateFormat = "h:mm"
		dateFormatter.dateFormat = "EEEE, MMMM d"

		Timer.scheduledTimer(timeInterval: 1,
							 target: self,
							 selector: #selector(updateTime),
							 userInfo: nil,
							 repeats: true)
		updateTime()
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

		timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: -4).isActive = true
		timeLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		timeLabel.heightAnchor.constraint(equalToConstant: 81).isActive = true

		dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 65).isActive = true
		dateLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		dateLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true

		nowPlayingView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		nowPlayingView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		artistLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		artistLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true

		songLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		songLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17).isActive = true

		albumLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		albumLabel.topAnchor.constraint(equalTo: topAnchor, constant: 29).isActive = true
	}

	func format(label: inout UILabel, size: CGFloat? = nil, bold: Bool = false) {
		if let size = size {
			var name = "HelveticaNeue"
			if bold {
				name = "HelveticaNeue-Bold"
			}
			label.font = UIFont(name: name, size: size)
		}
		label.textColor = .white
		label.textAlignment = .center
		label.layer.shadowOffset = CGSize(width: 0, height: -1)
		label.layer.shadowRadius = 0
		label.layer.shadowOpacity = 0.4
		label.translatesAutoresizingMaskIntoConstraints = false
	}

	@objc func updateTime() {
		let date = Date()
		timeLabel.text = timeFormatter.string(from: date)
		dateLabel.text = dateFormatter.string(from: date)
	}

	func updatePlayingState() {
		if isPlaying {
			artistLabel.text = nowPlayingInfo["artist"]
			songLabel.text = nowPlayingInfo["song"]
			albumLabel.text = nowPlayingInfo["album"]
		}
		timeLabel.isHidden = isPlaying
		dateLabel.isHidden = isPlaying
		nowPlayingView.isHidden = !isPlaying
	}
}
