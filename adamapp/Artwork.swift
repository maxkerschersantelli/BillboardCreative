//
//  Artwork.swift
//  adamapp
//
//  Created by Max Kerscher-Santelli on 7/14/16.
//  Copyright © 2016 Max Kerscher-Santelli. All rights reserved.
//

import Foundation

import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let artist: String
    let url: URL
    let imageData: String
    let thumbNailData: Data
    let coordinate: CLLocationCoordinate2D
    let descriptionText: String
    
    init(title: String, artist: String, url: URL, imageData: String, thumbNailData: Data, coordinate: CLLocationCoordinate2D, descriptionText: String) {
        //self.title = title
        self.title = artist
        self.artist = artist
        self.url = url
        self.imageData = imageData
        self.thumbNailData = thumbNailData
        self.coordinate = coordinate
        self.descriptionText = descriptionText
        
        super.init()
    }
    
    class func fromJSON(_ json: [JSONValue]) -> Artwork? {
        var title: String
        
        if let titleOrNil = json[0].string {
            title = titleOrNil
        } else {
            title = ""
        }
        
        //set fields for art object
        let artist = json[1].string
        print(artist)
        let url = URL(string: json[2].string!)
        let thumbUrl = URL(string: json[3].string!)
        print(json[3].string!)
        let thumbData = try? Data(contentsOf: thumbUrl!)
        let latitude = (json[4].string! as NSString).doubleValue
        let longitude = (json[5].string! as NSString).doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let descriptionText = json[6].string
        
        return Artwork(title: title, artist: artist!, url: url!, imageData: json[2].string!, thumbNailData: thumbData!, coordinate: coordinate, descriptionText: descriptionText!)
    }
    
    /*var subtitle: String? {
        return artist
    }*/
}
