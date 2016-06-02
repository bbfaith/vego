//
//  recipeInfoViewController.swift
//  Vego
//
//  Created by Mu Lan on 29/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var recipeDefaultImage: UIImageView!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var name: UILabel!
    
    // API keys.
    // NOTE: Each key can only request 25 times a day!
    // NOTE: Load recipe list takes 1 request, load 1 recipe detail takes 2 requests
    
    let apiKey = "1JObxXXpNUmshOiPtCcYhfb6KccCp1nqQrOjsnagwQM0hBauQQ"
//    let apiKey = "QwPr6RIpx7mshbB4zoCIIjSNc9K4p1Ai09vjsncXNLqX7uvX3J"
    let apiBaseURL = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?"
    var id = 568604
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        recipeDefaultImage.image = image
        requestRecipe(id)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestRecipe(id: Int) {
        let url = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/" + String(id) + "/information"
        print(url)
        let urlComponents = NSURLComponents(string: url)!
        
        let request = NSMutableURLRequest(URL: urlComponents.URL!)
        request.timeoutInterval = 30
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        //        print(request)
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
                    // Fetch json data
                    if let data = data {
                        if let fetchedJson = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                            if let get = fetchedJson["sourceUrl"] as! String?{
                                print(get)
                                self.requestInstruction(get)
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
    
    func requestInstruction(url: String) {
        let baseurl = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/extract?"
        let urlComponents = NSURLComponents(string: baseurl)!
        let queryItems = [
            NSURLQueryItem(name: "forceExtraction", value: "false"),
            NSURLQueryItem(name: "url", value: url),
            ]
        urlComponents.queryItems = queryItems
        let request = NSMutableURLRequest(URL: urlComponents.URL!)
        urlComponents.queryItems = queryItems
        request.timeoutInterval = 30
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "X-Mashape-Key")
        //        print(request)
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
                    // Fetch json data
                    if let data = data {
                        if let fetchedJson = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                if let name = fetchedJson["title"] as? String {
                                    self.name.text = name
                                }
                                
                                if let ingredients = fetchedJson["extendedIngredients"] as! [NSDictionary]?
                                    {
                                        var str = ""
                                        for ingredient in ingredients{
                                            if let ingredientText = ingredient["originalString"] as? String {
                                                str += ingredientText + "\n"
                                            }
                                        }
                                        self.ingredients.text = str
                                    }

                                if let text = fetchedJson["text"] as? String?{
                                    self.instructions.text = text
                                }
                                self.tableView.reloadData()
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
        let url = NSURL(string: imgurl)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.timeoutInterval = 20
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            dispatch_async(dispatch_get_main_queue()) {
                if let data = data {
                    self.recipeDefaultImage.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
}
