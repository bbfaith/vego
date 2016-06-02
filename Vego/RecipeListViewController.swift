//
//  RecipeListViewController.swift
//  Vego
//
//  Created by Mu Lan on 21/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit

class RecipeListViewController: UITableViewController {

    struct ImgInfo {
        var image : UIImage
        var id : Int
        var title : String
    }
    let group = dispatch_group_create()
    let cellSpacingHeight: CGFloat = 5
    let apiKey = "1JObxXXpNUmshOiPtCcYhfb6KccCp1nqQrOjsnagwQM0hBauQQ"
    let apiBaseURL = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?"
    var imgInfo : [ImgInfo] = []
//    let imageBaseURL = "https://spoonacular.com/recipeImages/"

    var current : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_group_enter(self.group)
        dispatch_group_async(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {                                    dispatch_group_leave(self.group)
        })
        performRequest()
        dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER)
        self.reloadInputViews()
        print(imgInfo.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            NSURLQueryItem(name: "number", value: "1"),
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
//                            var count = 0
                            if let get = fetchedJson["results"] as! [NSDictionary]?{
                                let recipe = get[0]
//                                print(recipe)
                                let id = recipe["id"] as! Int
                                let imageURL = "https://spoonacular.com/recipeImages/" + (recipe["imageUrls"]![0] as! String)
                                print(imageURL)
                                let title = recipe["title"] as! String
                                let info = ImgInfo(image : UIImage(named: "recipe0.jpg")!,id: id, title: title)
                                print(id)

                                    self.imgInfo.append(info)

                            }
                        }
                    }
                } catch {
                    print("Cannot load json correctly. error: \(error)")
                    return
                }
            }
        }
        task.resume()
    }
    
    func fetchImage(imgurl: String){
        getDataFromUrl(imgurl) { data in
            self.current = UIImage(data: data!)!
            print(imgurl)
        }
//        return current!
    }
    
    func getDataFromUrl(url:String, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            completion(data: NSData(data: data!))
            }.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let desViewController = segue.destinationViewController as! RecipeInfoViewController
    
        desViewController.id = imgInfo[tableView.indexPathForSelectedRow!.row].id
    }
}
