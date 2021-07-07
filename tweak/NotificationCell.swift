//
//  NotificationCell.swift
//  SixLS
//
//  Created by Skitty on 11/27/20.
//  Copyright © 2020 Skitty. All rights reserved.
//

import UIKit

final class NotificationCell: UITableViewCell {
	var request: NCNotificationRequest

	var titleLabel: UILabel
	var messageLabel: UILabel
	var dateLabel: UILabel
	var iconSlider: GlintySlider

	private var topSeparator: UIView
	private var bottomSeparator: UIView

	let timeFormatter = DateFormatter()

	init(request: NCNotificationRequest) {
		self.request = request

		titleLabel = UILabel()
		messageLabel = UILabel()
		dateLabel = UILabel()
		iconSlider = GlintySlider(frame: .zero)
		topSeparator = UIView()
		bottomSeparator = UIView()

		super.init(style: .default, reuseIdentifier: "notificationCell")

		backgroundColor = UIColor(white: 0, alpha: 0.6)
		contentView.isUserInteractionEnabled = false

		configureViews()

		iconSlider.uiSlider.addTarget(self, action: #selector(showSlider), for: .touchDown)
		iconSlider.uiSlider.addTarget(self, action: #selector(sliderStopped(_:)), for: .touchUpInside)
		iconSlider.uiSlider.addTarget(self, action: #selector(sliderStopped(_:)), for: .touchUpOutside)
		iconSlider.uiSlider.addTarget(self, action: #selector(sliderStopped(_:)), for: .touchCancel)
		iconSlider.uiSlider.addTarget(self, action: #selector(sliderMoved(_:)), for: .valueChanged)

		addSubview(titleLabel)
		addSubview(messageLabel)
		addSubview(dateLabel)
		addSubview(iconSlider)
		addSubview(topSeparator)
		addSubview(bottomSeparator)

		activateConstraints()
		updateTimeFormat()

		NotificationCenter.default.addObserver(self,
											   selector: #selector(updateTimeFormat),
											   name: Notification.Name("observePreferences"),
											   object: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc func updateTimeFormat() {
		timeFormatter.dateFormat = SixLSManager.sharedInstance()?.militaryTime ?? false ? "HH:mm" : "h:mm a"
		if let date = request.content.date {
			dateLabel.text = timeFormatter.string(from: date)
		}
	}

	func configureViews() {
		titleLabel.text = request.content.header ?? request.content.title
		titleLabel.textColor = .white
		titleLabel.textAlignment = .left
		titleLabel.font = UIFont(name: "Helvetica-Bold", size: 15)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		applyShadow(label: &titleLabel)

		messageLabel.text = request.content.message ?? request.content.subtitle
		messageLabel.numberOfLines = 4
		messageLabel.textColor = .white
		messageLabel.textAlignment = .left
		messageLabel.font = UIFont(name: "Helvetica", size: 13)
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		applyShadow(label: &messageLabel)

		var notificationDate = ""
		if let date = request.content.date {
			notificationDate = timeFormatter.string(from: date)
		}

		dateLabel.text = notificationDate
		dateLabel.textColor = .white
		dateLabel.textAlignment = .right
		dateLabel.font = UIFont(name: "Helvetica-Bold", size: 12)
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		applyShadow(label: &dateLabel)

		iconSlider.knob = request.content.icon?.imageResized(to: CGSize(width: 29, height: 29))
		iconSlider.text = "slide to view"
		iconSlider.font = UIFont(name: "Helvetica", size: 19)
		iconSlider.track.image = UIImage.forSix(named: "track")?
									.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9),
													resizingMode: .stretch)
		iconSlider.track.isHidden = true
		iconSlider.glintyTextView.isHidden = true
		iconSlider.track.alpha = 0
		iconSlider.glintyTextView.alpha = 0
		iconSlider.translatesAutoresizingMaskIntoConstraints = false

		topSeparator.backgroundColor = UIColor(white: 1, alpha: 0.15)
		topSeparator.translatesAutoresizingMaskIntoConstraints = false

		bottomSeparator.backgroundColor = UIColor(white: 0, alpha: 0.35)
		bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
	}

	func activateConstraints() {
		titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 47).isActive = true
		titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6.5).isActive = true
		titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -111).isActive = true

		messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 47).isActive = true
		messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24.5).isActive = true
		messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6.5).isActive = true
		messageLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -56).isActive = true

		dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9).isActive = true
		dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
		dateLabel.widthAnchor.constraint(equalToConstant: 64).isActive = true

		iconSlider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		iconSlider.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		iconSlider.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
		iconSlider.heightAnchor.constraint(equalToConstant: 35).isActive = true

		topSeparator.topAnchor.constraint(equalTo: topAnchor).isActive = true
		topSeparator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		topSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true

		bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		bottomSeparator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		bottomSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
	}

	func applyShadow(label: inout UILabel) {
		label.layer.masksToBounds = false
		label.layer.shadowOffset = CGSize(width: 0, height: 1)
		label.layer.shadowRadius = 0
		label.layer.shadowOpacity = 0.4
	}

	@objc func showSlider() {
		iconSlider.track.isHidden = false
		iconSlider.glintyTextView.isHidden = false
		UIView.animate(withDuration: 0.2) {
			self.iconSlider.track.alpha = 0.8
			self.iconSlider.glintyTextView.alpha = 1
			self.titleLabel.alpha = 0
			self.messageLabel.alpha = 0
			self.dateLabel.alpha = 0
		}
	}

	@objc func hideSlider() {
		UIView.animate(withDuration: 0.2, animations: {
			self.iconSlider.track.alpha = 0
			self.iconSlider.glintyTextView.alpha = 0
			self.titleLabel.alpha = 1
			self.messageLabel.alpha = 1
			self.dateLabel.alpha = 1
		}, completion: { _ in
			self.iconSlider.uiSlider.setValue(0, animated: false)
		})
	}

	@objc func sliderStopped(_ slider: UISlider) {
		if slider.value == 1 {
			SixLSManager.sharedInstance().openNotification(request)
		}
		UIView.animate(withDuration: 0.2, animations: {
			slider.setValue(0, animated: true)
			self.iconSlider.glintyTextView.alpha = 1
		}, completion: { _ in
			self.hideSlider()
		})
	}

	@objc func sliderMoved(_ slider: UISlider) {
		iconSlider.glintyTextView.alpha = CGFloat(1 - slider.value * 3)
	}
}
