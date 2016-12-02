//
//  VCMapView.swift
//  adamapp
//
//  Created by Max Kerscher-Santelli on 7/14/16.
//  Copyright © 2016 Max Kerscher-Santelli. All rights reserved.
//

import Foundation

import MapKit

extension FirstViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        
        if (control == view.rightCalloutAccessoryView)
        {
            print("Button is now pressed!")
            performSegue(withIdentifier: "moreInfo", sender: self)
        }
    }
    
    //segue to moreinfor page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfo" {
            print("prepareForSegue moreinfo")
            
            let theDestination : infoPage = segue.destination as! infoPage
            let artworks = (sender as! FirstViewController).artworks
            let index = (sender as! FirstViewController).selectedArtwork
            let year = (sender as! FirstViewController).year
            print(year)
            print("SEGUE moreinfo")
            
            //set fields for moreinfo page
            theDestination.titleText = artworks[index].title!
            theDestination.artistNameText = artworks[index].artist
            theDestination.artDescriptionText = artworks[index].descriptionText
            theDestination.artData = artworks[index].imageData
            
            //set fields to save current state in map
            theDestination.savedYear = year
            theDestination.savedIndex = index
        }
    }
}
