//
//  infoPage.swift
//  adamapp
//
//  Created by Max Kerscher-Santelli on 8/16/16.
//  Copyright © 2016 Max Kerscher-Santelli. All rights reserved.
//

import Foundation
import UIKit

class infoPage: UIViewController{
    
    @IBOutlet weak var artImage: UIImageView!
    @IBOutlet weak var artDescription: UITextView!
    @IBOutlet var backView: UIView!
    
    @IBOutlet weak var realBackView: UIView!
    @IBOutlet weak var back: UIButton!

    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    var titleText: String = "title"
    var artistNameText: String = "name"
    var artDescriptionText: String = "description"
    var artData: String!
    
    var savedYear = 0
    var savedIndex = 0
    
    //called when back button pressed, displays loading animation and calls segue back to map
    func Tap() {
        print("back button pressed")
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.layer.cornerRadius = 3.0
        loadingAnimation.alpha = 1
        loadingAnimation.color = UIColor(white: 1, alpha: 1)
        loadingAnimation.startAnimating()
        performSegue(withIdentifier: "back", sender: self)
    }
    
    override func viewDidLoad() {
        print("infoDIDLOAD")
        //sets up back button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(infoPage.Tap))
        back.addGestureRecognizer(tapGesture)
        
        //fills description text box
        artDescriptionText = /*titleText + "\n" + */ "By: " + artistNameText + "\n" + artDescriptionText
        artDescription.text = artDescriptionText
        
        realBackView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        loadingAnimation.alpha = 0
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        //load image
        let url = URL(string: artData!)
        let data = try? Data(contentsOf: url!)
        var image = UIImage(data: data!)
        let scale = screenWidth / image!.size.width
        let newHeight = image!.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: screenWidth, height: newHeight))
        image!.draw(in: CGRect(x: 0, y: 0, width: screenWidth, height: newHeight))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        artImage.image = image
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        artDescription.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back" {
            print("prepareForSegue")
            let theDestination: UITabBarController = segue.destination as! UITabBarController
            let destinationMap: FirstViewController = theDestination.viewControllers![2] as! FirstViewController
            theDestination.selectedIndex = 2

            //set variable to reload state
            destinationMap.savedYear = (sender as! infoPage).savedYear
            destinationMap.selectedArtwork = (sender as! infoPage).savedIndex
            destinationMap.reload = true
            destinationMap.segueFromInfo = true

        }
    }
}
