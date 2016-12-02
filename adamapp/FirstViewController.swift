//
//  FirstViewController.swift
//  adamapp
//
//  Created by Max Kerscher-Santelli on 7/7/16.
//  Copyright © 2016 Max Kerscher-Santelli. All rights reserved.
//

import UIKit
import MapKit

var jsonObject: Any? = nil
var first = true

class FirstViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var imagePicker: AKPickerView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    let initialLocation = CLLocationCoordinate2D(latitude: 34.084845, longitude: -118.338375)
    let regionRadius: CLLocationDistance = 10000
    var year: Int = 0//row of currently selected year
    var savedYear: Int = 0
    var selectedArtwork: Int = 0//index of currently selected annotation artwork
    
    var segueFromInfo = false
    var reload = false
    var loaded = false
    var years = [String]()//options for year picker
    var artworks = [Artwork]()//data from JSON Object
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    
    //Image Picker Code
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return self.artworks.count
    }
    
    //adds images to image picker
    func pickerView(_ pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        let image = UIImage(data: self.artworks[item].thumbNailData as Data)!
        /*if(image.size.width < image.size.height){
            let scale = 100 / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSizeMake(100, newHeight))
            image.drawInRect(CGRectMake(0, 0, 100, newHeight))
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }else{
            let scale = 100 / image.size.height
            let newWidth = image.size.width * scale
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, 100))
            image.drawInRect(CGRectMake(0, 0, newWidth, 100))
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }*/
        
        return image
    }
    
    //called when image selected in picker, zooms on seleced images pin
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        let region = MKCoordinateRegionMakeWithDistance(self.artworks[item].coordinate, 2000 * 2.0, 2000 * 2.0)
        mapView.selectAnnotation(self.artworks[item], animated: true)
        mapView.setRegion(region, animated: true)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // println("\(scrollView.contentOffset.x)")
    }
    
    
    //YEAR PICKER CODE
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    //populates year picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return years[row]
    }
    
    //called when new year is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print("year picker")
        year = row
        let region = MKCoordinateRegionMakeWithDistance(initialLocation, regionRadius * 2.0, regionRadius * 2.0)
        mapView.removeAnnotations(artworks)//remove pins
        loadMapData(years[row])//load new artworks
        mapView.addAnnotations(artworks)//add new pins
        //repopulate picker and return to initial state
        imagePicker.selectItem(0)
        imagePicker.reloadData()
        mapView.deselectAnnotation(self.artworks[0], animated: false)
        mapView.setRegion(region, animated: true)//zoom map back to inital location
    }
    
    //fills years array for date selection picker
    func loadPickerList() {
        print("loadPickerList()")
        
        if let jsonObject = jsonObject as? [String: AnyObject],
            //let jsonData = JSONValue.fromObject(jsonObject)?["labels"]?.array {
            let jsonData = JSONValue.fromObject(jsonObject as AnyObject)?["labels"]?.array {
            for year in jsonData {
                years.append(year.string!)
                print("years + 1")
            }
        }
        myPicker.reloadAllComponents()
    }
    //END YEAR PICKER CODE
    
    //returns map to initial location
    func centerMapOnLocation() {
        print("centerOnLocation")
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //populates artworks array with new artworks
    func loadMapData(_ input: String) {
        print("loadmapdata()")
        artworks = [Artwork]()
        
        if let jsonObject = jsonObject as? [String: AnyObject],
            
            //let jsonData = JSONValue.fromObject(jsonObject)?[input]?.array {
            let jsonData = JSONValue.fromObject(jsonObject as AnyObject)?[input]?.array {
            for artworkJSON in jsonData {
                if let artworkJSON = artworkJSON.array,
                    
                    let artwork = Artwork.fromJSON(artworkJSON) {
                    artworks.append(artwork)
                }
            }
            loaded = true
        }
        
        mapView.addAnnotations(artworks)
        
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        if(jsonObject != nil){//if relaoding page
            self.loadingView.isHidden = true
            self.loadingAnimation.isHidden = true
        }else{//if first time loading page
            //display loading animation
            loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            loadingView.layer.cornerRadius = 3.0
            
            loadingAnimation.alpha = 1
            loadingAnimation.color = UIColor(white: 1, alpha: 1)
            loadingAnimation.startAnimating()
            
            loadJson({ (success) -> Void in
                
                // When download completes,control flow goes here.
                if success {
                    print("finished loading json")
                    self.loadPickerList()
                    self.loadMapData(self.years.first!)
                    self.imagePicker.reloadData()
                    self.mapView.addAnnotations(self.artworks)
                    self.loadingView.isHidden = true
                    self.loadingAnimation.isHidden = true
                }else{
                    print("problem loading json")
                }
            })
        }
        
        mapView.delegate = self
        centerMapOnLocation()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        //display image picker
        self.imagePicker.delegate = self
        self.imagePicker.dataSource = self
        
        self.imagePicker.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.imagePicker.maskDisabled = false
        self.imagePicker.interitemSpacing = 5.0
        
        //if coming from more info page return to original state
        if(reload){
            print("Page Reloaded")
            if(segueFromInfo){
                loadPickerList()
                segueFromInfo = false
            }
            loadMapData(years[savedYear])
            
            myPicker.selectRow(savedYear, inComponent: 0, animated: false)
            
            imagePicker.selectItem(selectedArtwork)
            imagePicker.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        while(self.loaded != true){
            //print("yea")
        }
        if(!reload){
            imagePicker.reloadData()
            mapView.addAnnotations(artworks)
            reload = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //downloads json file
    func loadJson(_ completionHandler: @escaping CompletionHandler){
        var flag = false
        //let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        //configuration.URLCache = nil
        let requestURL: URL = URL(string: "http://s3-us-west-2.amazonaws.com/bbc-files/bbc.json")!
        //let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
        let urlRequest: URLRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        session.configuration.urlCache = nil
        //let session = NSURLSession(configuration: configuration)
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                flag = true
                
                if let data = data {
                    do {
                        jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))// as AnyObject
                    } catch _ {
                        jsonObject = nil
                        print("FUCK")
                    }
                }
                completionHandler(flag)
            }
        }) 
        
        task.resume()
        
    }
    
    //when the user selects an annotation on the map selected annotation is set and imagepicker index is changed
    @objc(mapView:didSelectAnnotationView:) func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Artwork {
            selectedArtwork = (artworks as NSArray).index(of: annotation)
            imagePicker.selectItem(selectedArtwork)
        }
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool){
        print("map view fulling rendered")
        if(first){
            first = false;
            centerMapOnLocation()
        }
    }
}

