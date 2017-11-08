//
//  MovieInfo.swift
//  MovieSearch
//
//  Created by Ruxin Zhang on 7/26/17.
//  Copyright © 2017 Ruxin Zhang. All rights reserved.
//
import UIKit
import Foundation

struct MovieCache{
    var ids = [Int]()
    var imageURLs = [String]()
    var voteAvgs = [Double]()
    var titles =  [String]()
    var images = [UIImage]()
    var scores = [Double]()
	var dates = [String]()
	var overviews = [String]()
	var count = 0
	mutating func addMovie(_ id:Int?,_ imageURL: String?, _ voteAverage: Double?, _ title: String?, _ score: Double?, _ date:String?,_ overview:String?) {
        if id != nil {
            self.ids.append(id!)
			count += 1
        } else {
            self.ids.append(-1)
        }
        if imageURL != nil {
            self.imageURLs.append(imageURL!)
        } else {
            self.imageURLs.append("")
        }
        if voteAverage != nil {
            self.voteAvgs.append(voteAverage!)
        } else {
            self.voteAvgs.append(-1)
        }
        if title != nil {
            self.titles.append(title!)

        } else {
            self.titles.append("")

        }
        if score != nil {
            self.scores.append(score!)
        } else {
            self.scores.append(-1)
        }
		if date != nil {
			self.dates.append(date!)
		} else {
			self.dates.append("")
		}
		if overview != nil {
			self.overviews.append(overview!)
		} else {
			self.overviews.append("")
		}

		
    }
	
	mutating func cleanAll() {
		ids = []
		imageURLs = []
		voteAvgs = []
		titles =  []
		images = []
		scores = []
		dates = []
		overviews = []
		count = 0
	}
}

struct  Movie {
    var id = String()
    var imageURL = String()
    var voteAvg = String()
    var title = Double()
    
}
class  MovieBrief {
    var ids = Int()
    var titles =  String()
}
