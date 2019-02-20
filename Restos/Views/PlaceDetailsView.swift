//
//  PlaceDetailsView.swift
//  Restos
//
//  Created by Alejandro on 19/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit

class PlaceDetailsView : UIView {
    
    let place: Place
    
    let placeImageView = UIImageView(image: UIImage(named: "restaurant-placeholder")).withoutAutoConstraints()
    
    let titleLabel = UILabel().withoutAutoConstraints().with {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textAlignment = .center
    }
    
    let checkinsLabel = UILabel().withoutAutoConstraints().with {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 23)
        $0.textAlignment = .center
    }
    
    let addressLabel = UILabel().withoutAutoConstraints().with {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textAlignment = .center
    }
    
    init(place: Place) {
        self.place = place
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        [titleLabel, addressLabel, checkinsLabel, placeImageView].forEach { addSubview($0) }
        backgroundColor = .white

        titleLabel.text = place.label
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        let attrString = NSMutableAttributedString(string: place.formattedAddress)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        addressLabel.attributedText = attrString
        
        checkinsLabel.text = "\(place.numberOfCheckins) Check-ins"
        
        // Activate place image view constraints
        NSLayoutConstraint.activate([
            placeImageView.heightAnchor.constraint(equalTo: placeImageView.widthAnchor, multiplier: 2/3),
            placeImageView.topAnchor.constraint(equalTo: topAnchor),
            leadingAnchor.constraint(equalTo: placeImageView.leadingAnchor),
            placeImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Activate labels constraints
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
            titleLabel.topAnchor.constraint(equalTo: placeImageView.bottomAnchor, constant: 30),
            checkinsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            addressLabel.topAnchor.constraint(equalTo: checkinsLabel.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkinsLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            addressLabel.centerXAnchor.constraint(equalTo: checkinsLabel.centerXAnchor),
            addressLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.7)
        ])
    }
}
