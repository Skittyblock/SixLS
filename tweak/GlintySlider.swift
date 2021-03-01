//
//  GlintySlider.swift
//  SixLS
//
//  Created by Skitty on 11/26/20.
//  Copyright © 2020 Skitty. All rights reserved.
//

import UIKit

class GlintySlider: UIView {
    var track: UIImageView
    var uiSlider: UISlider
    var glintyTextView: _UIGlintyStringView

    private var knobYConstraint: NSLayoutConstraint?
    private var textXConstraint: NSLayoutConstraint?

    var delegate: LockBarViewDelegate? {
        didSet {
            uiSlider.addTarget(delegate, action: #selector(delegate?.sliderStopped(_:)), for: .touchUpInside)
            uiSlider.addTarget(delegate, action: #selector(delegate?.sliderStopped(_:)), for: .touchUpOutside)
            uiSlider.addTarget(delegate, action: #selector(delegate?.sliderStopped(_:)), for: .touchCancel)
            uiSlider.addTarget(delegate, action: #selector(delegate?.sliderMoved(_:)), for: .valueChanged)
        }
    }

    var text: String? {
        didSet {
            glintyTextView.text = text
        }
    }
    var font: UIFont? {
        didSet {
            glintyTextView.font = font
        }
    }
    var knob: UIImage? {
        didSet {
            uiSlider.setThumbImage(knob, for: .normal)
        }
    }
    var centerWithIcon = false {
        didSet {
            if centerWithIcon {
                knobYConstraint?.constant = 2
                textXConstraint?.constant = (uiSlider.thumbImage(for: .normal)?.size.width ?? 0) / 2
            } else {
                knobYConstraint?.constant = 0
                textXConstraint?.constant = 0
            }
        }
    }

    override init(frame: CGRect) {
        track = UIImageView()
        track.image = UIImage.forSix(named: "track")?
                        .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13),
                                        resizingMode: .stretch)
        track.translatesAutoresizingMaskIntoConstraints = false

        uiSlider = UISlider()
        uiSlider.setThumbImage(UIImage.forSix(named: "thumb"), for: .normal)
        uiSlider.setMinimumTrackImage(UIImage.init(), for: .normal)
        uiSlider.setMaximumTrackImage(UIImage.init(), for: .normal)
        uiSlider.translatesAutoresizingMaskIntoConstraints = false

        glintyTextView = _UIGlintyStringView(text: nil, andFont: nil)
        glintyTextView.setChevronStyle(0)
        glintyTextView.alpha = 1
        glintyTextView.show()
        glintyTextView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)

        addSubview(track)
        addSubview(glintyTextView)
        addSubview(uiSlider)

        activateConstraints()

        // Fix glinty text color
        // todo: find a better way to do this
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let sublayers = self.glintyTextView.layer.sublayers?.first?.sublayers
            let index = sublayers?.index(sublayers!.startIndex, offsetBy: 2) ?? 0
            self.glintyTextView.layer.sublayers?.first?.sublayers?[index].backgroundColor = UIColor(white: 1,
                                                                                                    alpha: 0.65).cgColor
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func activateConstraints() {
        track.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        track.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        uiSlider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        uiSlider.widthAnchor.constraint(equalTo: widthAnchor, constant: -10).isActive = true
        uiSlider.heightAnchor.constraint(equalToConstant: 47).isActive = true

        glintyTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        glintyTextView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        glintyTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        knobYConstraint = uiSlider.centerYAnchor.constraint(equalTo: centerYAnchor)
        textXConstraint = glintyTextView.centerXAnchor.constraint(equalTo: centerXAnchor)
        knobYConstraint?.isActive = true
        textXConstraint?.isActive = true
    }
}
