//
//  RecipeListViewController.swift
//  Vego
//
//  Created by Mu Lan on 21/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController {

    struct ImgInfo {
        var image : UIImage!
        var id : Int
        var title : String
    }
    var imgInfo : [ImgInfo] = []
    //    let imageBaseURL = "https://spoonacular.com/recipeImages/"
    var current : UIImage?
    
    let group = dispatch_group_create()
    let cellSpacingHeight: CGFloat = 5
    @IBOutlet weak var errorImage: UIImageView!
    
    // API keys.
    // NOTE: Each key can only request 25 times a day!
    // NOTE: Load recipe list takes 1 request, load 1 recipe detail takes 2 requests
    
//    let apiKey = "1JObxXXpNUmshOiPtCcYhfb6KccCp1nqQrOjsnagwQM0hBauQQ"
    let apiKey = "QwPr6RIpx7mshbB4zoCIIjSNc9K4p1Ai09vjsncXNLqX7uvX3J"
    
    let apiBaseURL = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check internet connection first
        if Reachability.isConnectedToNetwork() == false {
            errorImage.hidden = false
        } else {
            dispatch_group_enter(self.group)
            dispatch_group_async(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                self.performRequest()
            })
            dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER)
            self.reloadInputViews()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Animate list
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .TransitionNone, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imgInfo.count
    }
//
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RecipeCell

        // Configure the cell...
        cell.recipeImage.image = imgInfo[indexPath.row].image
        cell.recipeName.text = imgInfo[indexPath.row].title
        
        return cell
    }
 
    func  performRequest() {
        let urlComponents = NSURLComponents(string: apiBaseURL)!
        let queryItems = [
            NSURLQueryItem(name: "number", value: "10"),
            NSURLQueryItem(name: "cuisines", value: "vegetarian"),
            NSURLQueryItem(name: "offset", value: "0"),
            NSURLQueryItem(name: "query", value: "salad"),
        ]
        
        urlComponents.queryItems = queryItems
        let request = NSMutableURLRequest(URL: urlComponents.URL!)
        request.timeoutInterval = 30
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            guard error == nil else {
                print(error!)
                return
            }
            // Get response from server
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            // If the connection works
            if statusCode == 200 {
                do{
                    if let data = data {
                        if let fetchedJson = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                            var count = 0
                            if let get = fetchedJson["results"] as! [NSDictionary]?{
                                for recipe in get {
    //                                print(recipe)
                                    let id = recipe["id"] as! Int
                                    let imageURL = "https://spoonacular.com/recipeImages/" + (recipe["imageUrls"]![0] as! String)
//                                    print(imageURL)
                                    let title = recipe["title"] as! String
                                    self.fetchImage(imageURL, index: count)
                                    let info = ImgInfo(image: nil, id: id, title: title)
//                                    print(id)
                                    count += 1
                                    self.imgInfo.append(info)
                                }
                            }
                        }
                    }
                    self.viewWillAppear(true)
                    dispatch_group_leave(self.group)
                } catch {
                    print("Cannot load json correctly. error: \(error)")
                    return
                }
            }
        }
        task.resume()
    }
    
    func getDataFromUrl(url:String, completion: ((data: NSData?) -> Void)) {
        dispatch_group_enter(self.group)
        dispatch_group_async(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
                completion(data: NSData(data: data!))
                }.resume()
        })
    }
    
    func fetchImage(imgurl: String, index: Int){
        getDataFromUrl(imgurl) { data in
            self.imgInfo[index].image = UIImage(data: data!)!
        }
        self.tableView.reloadData()
        dispatch_group_leave(self.group)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = segue.destinationViewController as! RecipeDetailTableViewController
        
        let imageInfo = self.imgInfo[tableView.indexPathForSelectedRow!.row]
        destination.id = imageInfo.id
        destination.image = imageInfo.image
    }
}
