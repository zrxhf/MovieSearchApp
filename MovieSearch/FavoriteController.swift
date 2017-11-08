//
//  FavoriteControllerTableViewController.swift
//  MovieSearch
//
//  Created by Ruxin Zhang on 7/24/17.
//  Copyright © 2017 Ruxin Zhang. All rights reserved.
//

import UIKit

class FavoriteController:UIViewController,UITableViewDataSource, UITableViewDelegate {
	
	let defaults = UserDefaults.standard
	let reuseIdentifier = "favoritecell"
	var array = [Int:String]()
	var movieCache = MovieCache()
	
	@IBOutlet weak var theTableView: UITableView!
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		theTableView.dataSource = self
		theTableView.delegate = self
		//        theTableView.estimatedRowHeight = 100
		//        theTableView.rowHeight = UITableViewAutomaticDimension
		
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table view data source
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		refreshList()
	}
	
	private func refreshList() {
		//        self.theSpinner.startAnimating()
		//    DispatchQueue.global(qos: .userInitiated).async {
		//            self.getData()
		//            self.cacheImages()
		//
		DispatchQueue.global(qos: .userInitiated).async {
			let decoded = self.defaults.value(forKey: "favorite")
			//self.array = self.defaults.value(forKey: "favorite") as? [Int:String] ?? [Int:String]()
			if decoded != nil {
				self.array = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! [Int:String]
			}
			print(self.array)
			//print(decodedTeams.name)
			DispatchQueue.main.async {
				self.theTableView.reloadData()
			}
			
			
		}
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return array.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FavoriteCell
		
		//let prefix = "http://image.tmdb.org/t/p/w185"
		//let url = NSURL(string: prefix + arraytitle[indexPath.row])
		//        if let image = NSData(contentsOf:(url as?URL)!) {
		//            cell.imageView.image = UIImage(data: image as Data)
		//        } else {
		//            cell.imageView.image = UIImage(named: "a.png")
		//        }
		var dictKeys = Array(array.keys)
		let key  = dictKeys[indexPath.row]
		cell.title.text = array[key]
		
		
		// Configure the cell...
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCellEditingStyle.delete {
			//array.remove(at: indexPath.row)
			var dictKeys = Array(array.keys)
			let key  = dictKeys[indexPath.row]
			array.removeValue(forKey: key)
			dictKeys.remove(at: indexPath.row)
			
			tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
			let encodedData = NSKeyedArchiver.archivedData(withRootObject: array)
			defaults.set(encodedData, forKey: "favorite")
		}
	}
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let myVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailController") as! MovieDetailController
		var dictKeys = Array(array.keys)
		myVC.getId = dictKeys[indexPath.row]
		self.navigationController?.pushViewController(myVC, animated: true)
		
		
		
		
		
		
	}
	/*
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the specified item to be editable.
	return true
	}
	*/
	
	/*
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
	if editingStyle == .delete {
	// Delete the row from the data source
	tableView.deleteRows(at: [indexPath], with: .fade)
	} else if editingStyle == .insert {
	// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
	}
	*/
	
	/*
	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
	
	}
	*/
	
	/*
	// Override to support conditional rearranging of the table view.
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the item to be re-orderable.
	return true
	}
	*/
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
