//
//  PlaceDetailsViewController.swift
//  Restos
//
//  Created by Alejandro on 19/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    let place: Place
    var placeDetailsView: PlaceDetailsView?
    
    init(place: Place) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurant details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        placeDetailsView = PlaceDetailsView(place: place)
            .withoutAutoConstraints()
            .added(to: self)
            .with {
                self.leadingAnchor.constraint(equalTo: $0.leadingAnchor).isActive = true
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                self.topAnchor.constraint(equalTo: $0.topAnchor).isActive = true
                $0.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        placeDetailsView?.configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
