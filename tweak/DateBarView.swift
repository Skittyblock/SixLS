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
    var timeLabel: UILabel
    var dateLabel: UILabel

    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()

    override init(frame: CGRect) {
        backgroundView = UIImageView(image: UIImage.forSix(named: "lock"))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        timeLabel = UILabel()
        timeLabel.font = UIFont(name: "LockClock-Light", size: 65)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.layer.shadowOffset = CGSize(width: 0, height: -1)
        timeLabel.layer.shadowRadius = 0
        timeLabel.layer.shadowOpacity = 0.6
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel = UILabel()
        dateLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.layer.shadowOffset = CGSize(width: 0, height: -1)
        dateLabel.layer.shadowRadius = 0
        dateLabel.layer.shadowOpacity = 0.4
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        if UIDevice.current.model.hasPrefix("iPad") {
            timeLabel.font = UIFont(name: "LockClock-Light", size: 58)
        }

        super.init(frame: frame)

        addSubview(backgroundView)
        addSubview(timeLabel)
        addSubview(dateLabel)

        activateConstraints()

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
    }

    @objc func updateTime() {
        let date = Date()
        timeLabel.text = timeFormatter.string(from: date)
        dateLabel.text = dateFormatter.string(from: date)
    }
}
