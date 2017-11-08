//
//  MovieDetailController.swift
//  MovieSearch
//
//  Created by Ruxin Zhang on 7/21/17.
//  Copyright © 2017 Ruxin Zhang. All rights reserved.
//

import UIKit
import Social
class MovieDetailController: UIViewController {
    //var stringPassed = ""
    var getRate = Double()
    var getScore = Double()
    var getDate = String()
    var getId = Int()
    var getTitle = String()
    var getImage = UIImage()
    let defaults = UserDefaults.standard
    var array = [Int:String]()
	var getOverview = String()
	var movie:JSON! = []
   // static var array = [""]
    
    @IBOutlet weak var button: UIButton!
    
    
    @IBOutlet weak var rate: UILabel!

    
	@IBOutlet weak var overview: UITextView!
	
    
    @IBOutlet weak var releasedDate: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()
                // Do any additional setup after loading the view.
        
        //self.navigationController?.isNavigationBarHidden = false
		//https://api.themoviedb.org/3/movie/194083?api_key=28584b707018e6f0a4ead98eaa49b54f

		searchMovie(getId);
		//print (movie)
		
		
		
		//print(getRate)
        rate.text! = "Rate \(getRate)"
        releasedDate.text = "Released Year \(getDate)"
       
        if getOverview != "" {
            overview.text.append(getOverview)
        }  else {
            overview.text.append("NULL")
        }
        image.image = getImage
    }
	
	
	func  searchMovie(_ getId: Int ) {
		let urlPath = "https://api.themoviedb.org/3/movie/\(getId)?api_key=28584b707018e6f0a4ead98eaa49b54f"
		
		movie = getJSON(path: urlPath)
		if let rate = movie["vote_average"].double {
			getRate = rate
		}
		
		
		if let date = movie["release_date"].string {
			getDate = date
		}
		
	
		getTitle = movie["title"].string!
		
		
		let prefix = "http://image.tmdb.org/t/p/w185"
		if movie["poster_path"] != JSON.null {
			let url = NSURL(string: prefix + movie["poster_path"].string!)
			let image = NSData(contentsOf:(url as URL?)!)
			getImage = UIImage(data: image! as Data)!
		} else {
			getImage = UIImage(named: "Noimage.jpg")!
		}

		if let overview = movie["overview"].string {
			getOverview = overview
		} else {
			getOverview = "null"
		}
	}
	
	private func getJSON(path: String) -> JSON {
		guard let url = URL(string: path) else { return JSON.null }
		do {
			let data = try Data(contentsOf: url)
			return JSON(data: data)
		} catch {
			return JSON.null
		}
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //defaults.removeObject(forKey: "favorite")
        let decoded = self.defaults.value(forKey: "favorite")
        //self.array = self.defaults.value(forKey: "favorite") as? [Int:String] ?? [Int:String]()
        if decoded != nil {
            self.array = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! [Int:String]
        }
        
        button.setTitle("add",for: .normal)
        if (array.count>0 && array[getId] != nil){
            button.setTitle("remove",for: .normal)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func click(_ sender: Any) {
        //var array = defaults.object(forKey: "favorite") as? [Int:String] ?? [Int:String]()
        
        if button.titleLabel?.text == "remove" {
            array.removeValue(forKey: getId)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: array)
            defaults.set(encodedData, forKey: "favorite")
            button.setTitle("add", for: .normal)
        }
        
        if button.titleLabel?.text == "add" {
            array.updateValue(getTitle, forKey: getId)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: array)
            defaults.set(encodedData, forKey: "favorite")
            button.setTitle("remove", for: .normal)

        }

        
    }


//refer to https://www.youtube.com/watch?v=ueMvU17bd8w
	
	@IBAction func share2Facebook(_ sender: AnyObject) {
		//alert
		let alert = UIAlertController(title: "share", message: "share the movie", preferredStyle: .actionSheet)
		//first action
		let actionOne = UIAlertAction(title: "share on facebook", style: .default) {
			(action) in self.post(toService: SLServiceTypeFacebook)
		}
		
		alert.addAction(actionOne)
		self.present(alert,animated: true,completion: nil)
		
	}
	
	func post(toService service: String) {
			let socialController = SLComposeViewController(forServiceType: service)
			socialController?.setInitialText("#\(getTitle)(from Ruxin's movie app)")
			socialController?.add(self.getImage)
			self.present(socialController!, animated: true, completion: nil)
	}
	
	func showAlert(service:String) {
		let alert = UIAlertController(title: "error", message: "you are not connected to \(service)", preferredStyle: .alert)
		let action = UIAlertAction(title: "Dismiss", style: .cancel, handler:nil)
		
		alert.addAction(action)
		self.present(alert,animated: true,completion: nil)
	}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
