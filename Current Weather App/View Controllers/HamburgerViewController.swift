//
//  HamburgerViewController.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 2/26/22.
//

import UIKit

class HamburgerViewController: UIViewController {
//    Outlets
    @IBOutlet var mainBackgroundView: UIView!
    @IBOutlet weak var logoPicImage: UIImageView!
    
//    Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        hamburgerUI()
    }
    
    func hamburgerUI(){
        mainBackgroundView.layer.cornerRadius = 30
        mainBackgroundView.clipsToBounds = true
       
    }
    
}
