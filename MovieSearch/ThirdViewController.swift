//
//  MovieDetailController.swift
//  MovieSearch
//
//  Created by Ruxin Zhang on 7/21/17.
//  Copyright © 2017 Ruxin Zhang. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    // Storage
    let defaults = UserDefaults.standard
    
        
	@IBOutlet weak var sortby: UILabel!
	@IBOutlet weak var sortbypicker: UIPickerView!
	
	
	var row_name = "20"
	var row_change = 0
	var num = 20
	let sortbychoice = ["20","40","60"]
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return sortbychoice[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return sortbychoice.count
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		sortby.text = sortbychoice[row]
		row_name = sortbychoice[row]
		row_change = row
		defaults.set(row_change, forKey:"sortBySet")
		let str = row_name
		let db = Int(str)
		num = db!
		defaults.set(num, forKey: "numOfResults")
		
	}
	
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
		if let sortdefault = defaults.value(forKey: "sortBySet"
			) {
			row_change = sortdefault as! Int
			sortbypicker.selectRow(sortdefault as! Int, inComponent: 0, animated: true)
			row_name = sortbychoice[row_change]
		} else {
			defaults.set(row_change, forKey:"sortBySet")
		}
		
		let str = row_name
		let db = Int(str)
		num = db!
		defaults.set(num, forKey: "numOfResults")

	}

	func getSortBy()->String {
		return row_name
	}
	
	
	
    
}
