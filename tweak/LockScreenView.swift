//
//  LockScreenView.swift
//  SixLS
//
//  Created by Skitty on 11/26/20.
//  Copyright © 2020 Skitty. All rights reserved.
//

import UIKit

@objc public class LockScreenView: UIView {
	var statusBarBackground: UIView
	var dateView: DateBarView
	var lockView: LockBarView
	var chargingView: ChargingView
	var wallpaperGradient: UIImageView
	var fakeCameraBackground: UIView

	var notificationAlertView: NotificationAlertView
	var notificationTableView: UITableView

	@objc var notificationList: NCNotificationStructuredSectionList? {
		didSet {
			if let requests = notificationList?.allNotificationRequests {
				notifications = requests.sorted {
					$0.timestamp.compare($1.timestamp) == .orderedDescending
				}
			}
		}
	}

	@objc var notifications = [NCNotificationRequest]() {
		didSet {
			reloadNotifications()
		}
	}

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

	var hideTopBar: Bool? {
		didSet {
			dateView.isHidden = hideTopBar ?? false
		}
	}
	var hideBottomBar: Bool? {
		didSet {
			lockView.isHidden = hideTopBar ?? false
		}
	}
	var unlockText: String? {
		didSet {
			lockView.unlockSlider.glintyTextView.text = unlockText ?? "Slide to Unlock"
		}
	}
	var useNotifications = true
	var useChargingView = true

	override init(frame: CGRect) {
		statusBarBackground = UIView()
		dateView = DateBarView()
		lockView = LockBarView()
		chargingView = ChargingView()
		wallpaperGradient = UIImageView()
		fakeCameraBackground = UIView()
		notificationAlertView = NotificationAlertView(request: nil)
		notificationTableView = UITableView(frame: .zero, style: .plain)

		super.init(frame: frame)

		configureViews()

		lockView.delegate = self
		notificationTableView.delegate = self
		notificationTableView.dataSource = self

		notificationTableView.estimatedRowHeight = 47
		notificationTableView.rowHeight = UITableView.automaticDimension

		addSubview(chargingView)
		addSubview(wallpaperGradient)
		addSubview(dateView)
		addSubview(lockView)
		addSubview(fakeCameraBackground)
		addSubview(notificationTableView)
		addSubview(notificationAlertView)
		addSubview(statusBarBackground)

		activateConstraints()
		observePreferences()

		NotificationCenter.default.addObserver(self,
											   selector: #selector(observePreferences),
											   name: Notification.Name("observePreferences"),
											   object: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configureViews() {
		statusBarBackground.backgroundColor = UIColor(white: 0, alpha: 0.55)
		statusBarBackground.translatesAutoresizingMaskIntoConstraints = false

		dateView.translatesAutoresizingMaskIntoConstraints = false
		lockView.translatesAutoresizingMaskIntoConstraints = false

		chargingView.isHidden = true
		chargingView.translatesAutoresizingMaskIntoConstraints = false

		wallpaperGradient.image = UIImage.forSix(named: "sb")
		wallpaperGradient.contentMode = .scaleToFill
		wallpaperGradient.translatesAutoresizingMaskIntoConstraints = false

		fakeCameraBackground.backgroundColor = .black
		fakeCameraBackground.translatesAutoresizingMaskIntoConstraints = false

		notificationAlertView.isHidden = true
		notificationAlertView.translatesAutoresizingMaskIntoConstraints = false

		notificationTableView.backgroundColor = .clear
		notificationTableView.separatorColor = .clear
		notificationTableView.allowsSelection = false
		notificationTableView.isHidden = true
		notificationTableView.translatesAutoresizingMaskIntoConstraints = false
	}

	func activateConstraints() {
		statusBarBackground.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		statusBarBackground.heightAnchor.constraint(equalToConstant: statusBarHeight).isActive = true

		dateView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		dateView.topAnchor.constraint(equalTo: topAnchor, constant: statusBarHeight).isActive = true
		dateView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		dateView.heightAnchor.constraint(equalToConstant: 95).isActive = true

		lockView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		lockView.topAnchor.constraint(equalTo: bottomAnchor, constant: -95).isActive = true
		lockView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		lockView.heightAnchor.constraint(equalToConstant: 95).isActive = true

		chargingView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		chargingView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		wallpaperGradient.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		wallpaperGradient.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		fakeCameraBackground.topAnchor.constraint(equalTo: lockView.bottomAnchor).isActive = true
		fakeCameraBackground.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		fakeCameraBackground.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		notificationAlertView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		notificationAlertView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		notificationAlertView.heightAnchor.constraint(equalToConstant: 79.5).isActive = true

		if UIDevice.current.model.hasPrefix("iPad") {
			notificationAlertView.widthAnchor.constraint(equalToConstant: 357).isActive = true
		} else {
			notificationAlertView.widthAnchor.constraint(equalTo: widthAnchor, constant: -18).isActive = true
		}

		notificationTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		notificationTableView.topAnchor.constraint(equalTo: dateView.bottomAnchor).isActive = true
		notificationTableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		notificationTableView.bottomAnchor.constraint(equalTo: lockView.topAnchor).isActive = true
	}

	@objc func observePreferences() {
		let manager = SixLSManager.sharedInstance()
		statusBarBackground.isHidden = manager?.disableDateBar ?? false
		dateView.isHidden = manager?.disableDateBar ?? false
		lockView.isHidden = manager?.disableLockBar ?? false
		wallpaperGradient.isHidden = manager?.disableWallpaperShadow ?? false
		lockView.unlockSlider.text = manager?.unlockText ?? "slide to unlock"
		dateView.timeFormatter.dateFormat = manager?.militaryTime ?? false ? "HH:mm" : "h:mm"
		useChargingView = !(manager?.disableChargingView ?? false)
		useNotifications = !(manager?.disableClassicNotifications ?? false)
		updateChargingState()
	}

	@objc func updateChargingState() {
		if useChargingView {
			chargingView.isHidden = UIDevice.current.batteryState != .charging
			chargingView.updateImage()
		} else {
			chargingView.isHidden = true
		}
	}

	func reloadNotifications() {
		guard useNotifications else {
			notificationTableView.isHidden = true
			notificationAlertView.isHidden = true
			return
		}

		let count = notifications.count // notificationList?.allNotificationRequests.count ?? 0

		if count > 1 {
			notificationTableView.isHidden = false
			notificationAlertView.isHidden = true
			notificationTableView.reloadData()
		} else if count == 1 {
			notificationAlertView.request = notifications[0]
			notificationTableView.isHidden = true
			notificationAlertView.isHidden = false
			notificationTableView.reloadData()
		} else {
			notificationTableView.isHidden = true
			notificationAlertView.isHidden = true
		}
	}

	@objc func addNotification(_ request: NCNotificationRequest) {
		notifications.append(request)
		reloadNotifications()
	}

	@objc func removeNotification(_ request: NCNotificationRequest) {
		if let index = notifications.firstIndex(of: request) {
			notifications.remove(at: index)
			reloadNotifications()
		}
	}

	@objc func dismiss() {
		UIView.animate(withDuration: 0.3, animations: {
			// self.alpha = 0
			var dateFrame = self.dateView.frame
			var lockFrame = self.lockView.frame
			dateFrame.origin.y -= 100 + self.statusBarHeight
			lockFrame.origin.y += 100
			self.dateView.frame = dateFrame
			self.lockView.frame = lockFrame
		}, completion: { _ in
			self.lockView.unlockSlider.uiSlider.value = 0
			self.lockView.unlockSlider.glintyTextView.alpha = 1
		})
	}

	@objc func presentAnimated() {
		UIView.animate(withDuration: 0.3) {
			self.present()
		}
	}

	@objc func present() {
		self.alpha = 1
		var dateFrame = self.dateView.frame
		var lockFrame = self.lockView.frame
		dateFrame.origin.y = self.statusBarHeight
		lockFrame.origin.y = self.bounds.height - lockFrame.height
		self.dateView.frame = dateFrame
		self.lockView.frame = lockFrame
	}

	@objc func unlock() {
		SixLSManager.sharedInstance().unlock()
	}
}

extension LockScreenView: LockBarViewDelegate {
	func sliderStopped(_ slider: UISlider) {
		if slider.value < 1 {
			UIView.animate(withDuration: 0.1) {
				slider.setValue(0, animated: true)
				self.lockView.unlockSlider.glintyTextView.alpha = 1
			}
		} else {
			dismiss()
			unlock()
		}
	}

	func sliderMoved(_ slider: UISlider) {
		lockView.unlockSlider.glintyTextView.alpha = CGFloat(1 - slider.value * 3)
	}

	func cameraTapped(_ gesture: UITapGestureRecognizer) {
		if gesture.state == .ended {
			UIView.animate(withDuration: 0.2, animations: {
				self.center = CGPoint(x: self.center.x, y: self.center.y - self.statusBarHeight)
			}, completion: { _ in
				UIView.animate(withDuration: 0.2) {
					self.center = CGPoint(x: self.center.x, y: self.center.y + self.statusBarHeight)
				}
			})
		}
	}

	func cameraDragged(_ gesture: UIPanGestureRecognizer) {
		var translatedPoint = gesture.translation(in: self)
		translatedPoint = CGPoint(x: self.center.x, y: self.center.y + translatedPoint.y)

		if !(translatedPoint.y > self.bounds.height / 2) {
			self.center = translatedPoint
		}

		gesture.setTranslation(.zero, in: self)

		if gesture.state == .ended || gesture.state == .cancelled { // todo: momentum
			let openCamera = !(self.center.y + self.bounds.height / 2 > self.bounds.height / 2 + 95)
			UIView.animate(withDuration: 0.4, animations: {
				if openCamera {
					self.center = CGPoint(x: self.center.x, y: -self.bounds.height / 2)
				} else {
					self.center = CGPoint(x: self.center.x, y: self.bounds.height / 2)
				}
			}, completion: { _ in
				if openCamera {
					SixLSManager.sharedInstance().openCamera()
					self.center = CGPoint(x: self.center.x, y: self.bounds.height / 2)
				}
			})
		}
	}
}

extension LockScreenView: UITableViewDelegate, UITableViewDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int {
		1
	}

	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		UITableView.automaticDimension
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		notifications.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard notifications.count > indexPath.row else { return UITableViewCell() }

		let cell = NotificationCell(request: notifications[indexPath.row])
		return cell
	}
}
