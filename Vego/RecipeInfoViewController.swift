//
//  recipeInfoViewController.swift
//  Vego
//
//  Created by Mu Lan on 29/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import Foundation
import UIKit

class RecipeInfoViewController: UIViewController {
    
    @IBOutlet var instruction: UILabel!
    
    let apiKey = "1JObxXXpNUmshOiPtCcYhfb6KccCp1nqQrOjsnagwQM0hBauQQ"
    let apiBaseURL = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?"
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
        requestRecipe(id)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                            //                            print(fetchedJson)
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
//                            if let ingredients = fetchedJson["extendedIngredients"] as! [NSDictionary]?
//                                {
//                                    for ingredient in ingredients{
//                                        let name = ingredient["name"] as! String?
//                                        let amount = ingredient["amount"] as! String?
//                                        let unit = ingredient["unit"] as! String?
//                                        
//                                    }
//                                }

                            if let get = fetchedJson["instructions"] as! String?{
                                print(get)
                                print(fetchedJson)
                                self.instruction.text = get
                            }
                            print(fetchedJson)
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

}
