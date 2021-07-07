//
//  ChargingView.swift
//  SixLS
//
//  Created by Skitty on 12/27/20.
//  Copyright © 2020 Skitty. All rights reserved.
//

final class ChargingView: UIView {
	let backgroundView: UIView
	let batteryImage: UIImageView

	override init(frame: CGRect) {
		backgroundView = UIView()
		backgroundView.backgroundColor = .black
		backgroundView.translatesAutoresizingMaskIntoConstraints = false

		batteryImage = UIImageView()
		batteryImage.image = UIImage.forSix(named: "BatteryBG_17.png")
		batteryImage.translatesAutoresizingMaskIntoConstraints = false

		super.init(frame: frame)

		addSubview(backgroundView)
		addSubview(batteryImage)

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

		batteryImage.widthAnchor.constraint(equalToConstant: 264).isActive = true
		batteryImage.heightAnchor.constraint(equalToConstant: 129).isActive = true
		batteryImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		batteryImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}

	func updateImage() {
		UIDevice.current.isBatteryMonitoringEnabled = true

		var num = (UIDevice.current.batteryLevel * 100.0) / (100.0 / 16.0)
		if num > 0 {
			num = floor(num) + 1.0
		}
		batteryImage.image = UIImage.forSix(named: "BatteryBG_\(Int(num))@2x.png")
	}
}
