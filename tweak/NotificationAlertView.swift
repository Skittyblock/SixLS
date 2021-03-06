//
//  NotificationAlertView.swift
//  SixLS
//
//  Created by Skitty on 11/27/20.
//  Copyright © 2020 Skitty. All rights reserved.
//

import UIKit

final class NotificationAlertView: UIView {
	var request: NCNotificationRequest? {
		didSet {
			titleLabel.text = request?.content.title ?? request?.content.header
			messageLabel.text = request?.content.message ?? request?.content.subtitle
			iconSlider.knob = request?.content.icon?.imageResized(to: CGSize(width: 29, height: 29))
		}
	}

	var backgroundView: UIImageView

	var titleLabel: UILabel
	var messageLabel: UILabel

	var iconSlider: GlintySlider

	init(request: NCNotificationRequest?) {
		self.request = request

		backgroundView = UIImageView(image: UIImage.forSix(named: "notification")?
							.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30),
											resizingMode: .stretch))
		titleLabel = UILabel()
		messageLabel = UILabel()
		iconSlider = GlintySlider(frame: .zero)

		super.init(frame: .zero)

		configureViews()

		addSubview(backgroundView)
		addSubview(titleLabel)
		addSubview(messageLabel)
		addSubview(iconSlider)

		activateConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configureViews() {
		backgroundView.translatesAutoresizingMaskIntoConstraints = false

		titleLabel.text = request?.content.title ?? request?.content.header
		titleLabel.numberOfLines = 1
		titleLabel.textColor = .white
		titleLabel.textAlignment = .left
		titleLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
		titleLabel.layer.masksToBounds = false
		titleLabel.layer.shadowOffset = CGSize(width: 0, height: -1)
		titleLabel.layer.shadowRadius = 0
		titleLabel.layer.shadowOpacity = 0.4
		titleLabel.translatesAutoresizingMaskIntoConstraints = false

		messageLabel.text = request?.content.message ?? request?.content.subtitle
		messageLabel.numberOfLines = 1
		messageLabel.textColor = .white
		messageLabel.textAlignment = .left
		messageLabel.font = UIFont(name: "Helvetica", size: 16)
		messageLabel.layer.masksToBounds = false
		messageLabel.layer.shadowOffset = CGSize(width: 0, height: -1)
		messageLabel.layer.shadowRadius = 0
		messageLabel.layer.shadowOpacity = 0.4
		messageLabel.sizeToFit()
		messageLabel.translatesAutoresizingMaskIntoConstraints = false

		iconSlider.track.image = UIImage.forSix(named: "track")?
										.resizableImage(withCapInsets: UIEdgeInsets(top: 0,
																					left: 9,
																					bottom: 0,
																					right: 9),
														resizingMode: .stretch)
		iconSlider.knob = request?.content.icon?.imageResized(to: CGSize(width: 29, height: 29)) ?? UIImage()
		iconSlider.text = "slide to view"
		iconSlider.font = UIFont(name: "Helvetica", size: 19)
		iconSlider.track.alpha = 0
		iconSlider.glintyTextView.alpha = 0
		iconSlider.translatesAutoresizingMaskIntoConstraints = false

		iconSlider.uiSlider.addTarget(self, action: #selector(showSlider), for: .touchDown)
		iconSlider.uiSlider.addTarget(self, action: #selector(sliderStopped(_:)), for: .touchUpInside)
		iconSlider.uiSlider.addTarget(self, action: #selector(sliderStopped(_:)), for: .touchUpOutside)
		iconSlider.uiSlider.addTarget(self, action: #selector(sliderStopped(_:)), for: .touchCancel)
		iconSlider.uiSlider.addTarget(self, action: #selector(sliderMoved(_:)), for: .valueChanged)
	}

	func activateConstraints() {
		backgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		backgroundView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
		titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
		titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -120).isActive = true

		messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
		messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 38).isActive = true
		// messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
		messageLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -64).isActive = true

		iconSlider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		iconSlider.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -3).isActive = true
		iconSlider.widthAnchor.constraint(equalTo: widthAnchor, constant: -22).isActive = true
		iconSlider.heightAnchor.constraint(equalToConstant: 35).isActive = true
	}

	@objc func showSlider() {
		UIView.animate(withDuration: 0.2) {
			self.iconSlider.track.alpha = 0.8
			self.iconSlider.glintyTextView.alpha = 1
			self.titleLabel.alpha = 0
			self.messageLabel.alpha = 0
		}
	}

	@objc func hideSlider() {
		UIView.animate(withDuration: 0.2, animations: {
			self.iconSlider.track.alpha = 0
			self.iconSlider.glintyTextView.alpha = 0
			self.titleLabel.alpha = 1
			self.messageLabel.alpha = 1
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
