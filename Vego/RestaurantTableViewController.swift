//
//  RestaurantTableViewController.swift
//  Vego
//
//  Created by Robin Lin on 21/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    struct restaurant {
        // Basic info
        let id: Int
        var name: String?
        var url: String?
        // Location
        var address: String?
        var locality: String?
        var city: String?
        var latitude: String?
        var longitude: String?
        // Detail info
        var cuisines: String?
        var price_range: Int?
        var average_cost_for_two: Int?
        var currency: String?
        // Image
        var thumbURL: String?
        var featuredImageURL: String?
        // User rating
        var rating: Double?
        var rating_color: String?
        
        // Initialiser
        init(id: Int) {
            self.id = id
        }
    }
    
    var testRes = restaurant(id: 1234)
    
    var restaurantData = [restaurant]()
    
    // The API key
    let apiKey = "b4060070f6f00977bea3bb8e8743cd61"
    
    // The Zomato API base URL
    let apiBaseURL = "https://developers.zomato.com/api/v2.1/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testRes.name = "A"
        testRes.url = "test"
        testRes.address = "test"
        testRes.locality = "test"
        testRes.city = "test"
        testRes.latitude = "test"
        testRes.longitude = "test"
        testRes.cuisines = "test"
        testRes.price_range = 5
        testRes.average_cost_for_two = 20
        testRes.currency = "test"
        testRes.thumbURL = "test"
        testRes.featuredImageURL = "test"
        testRes.rating = 4.5
        
        // Preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Json data retrive
//    func  performNASARequest(date: String, longitude: String, latitude: String, index: Int) {
//        // Create NASA api base URL using NSURLComponents
//        let urlComponents = NSURLComponents(string: apiBaseURL)!
//        
//        // Add params
//        let queryItems = [
//            NSURLQueryItem(name: "lon", value: longitude),
//            NSURLQueryItem(name: "lat", value: latitude),
//            NSURLQueryItem(name: "date", value: date),
//            NSURLQueryItem(name: "cloud_score", value: "true"),
//            NSURLQueryItem(name: "api_key", value: apiKey)]
//        urlComponents.queryItems = queryItems
//        
//        // Set request for task
//        let request = NSMutableURLRequest(URL: urlComponents.URL!)
//        request.timeoutInterval = 30
//        request.HTTPMethod = "GET"
//        
//        // Set task
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request) {
//            (data, response, error) -> Void in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//            // Get response from server
//            let httpResponse = response as! NSHTTPURLResponse
//            let statusCode = httpResponse.statusCode
//            
//            // If the connection works
//            if statusCode == 200 {
//                var json: [String: AnyObject]?
//                do{
//                    // Fetch json data
//                    if let data = data {
//                        json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
//                    }
//                } catch {
//                    print("Cannot load json correctly. error: \(error)")
//                    return
//                }
//                // Fetch images asyncronously
//                dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                    // Stop fetching if any historic image of the location cannot be found
//                    guard self.errorLabel.hidden == true else {
//                        return
//                    }
//                    
//                    if let imageURL = json?["url"] as? String, timeStamp = json?["date"] as? String {
//                        self.fetchImage(index, timeStampString: timeStamp, urlString: imageURL)
//                        // If all images are downloaded, repeatedly display each of them in order
//                        if self.count == self.numOfImages {
//                            self.loadingIcon.stopAnimating()
//                            self.loadingIcon.hidden = true
//                            self.count = 0
//                            self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("displayImage"), userInfo: nil, repeats: true)
//                        }
//                        
//                    } else {
//                        // Print error message on to screen
//                        if(self.loadingIcon.hidden == false) {
//                            self.loadingIcon.stopAnimating()
//                            self.loadingIcon.hidden = true
//                            self.dateLabel.hidden = true
//                            self.errorLabel.hidden = false
//                            self.errorLabel.text = "No satellite image found in the location."
//                        }
//                    }
//                }
//            }
//        }
//        task.resume()
//    }
//    
//    func fetchImage(index: Int, timeStampString: String, urlString: String) {
//        let imageURL = NSURL(string: urlString)
//        let imageData = NSData(contentsOfURL: imageURL!)
//        satelliteImages[index] = (timeStampString, UIImage(data: imageData!))
//        self.count++
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
