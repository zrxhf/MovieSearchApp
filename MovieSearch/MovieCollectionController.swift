//
//  MovieViewControllerCollectionViewController.swift
//  MovieSearch
//
//  Created by Ruxin Zhang on 7/18/17.
//  Copyright © 2017 Ruxin Zhang. All rights reserved.
//

import UIKit



class MovieCollectionController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    
    //MARK: - Property -
    private let reuseIdentifier = "moviecell"
    var movieCache = MovieCache()
    var movies: JSON = []
	var searchTitle:String = ""
	var curPage = 1
	var searchPage = 1
	var totalPage = 0
	var numOfResults = 20
	var genreid = -1
	var flag = 0
	let defaults = UserDefaults.standard
	
	
    //MARK: - IBOutlet -
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    @IBOutlet weak var theSearchBar: UISearchBar!
    
	@IBOutlet weak var spining: UIActivityIndicatorView!
	
	
	@IBOutlet weak var prevPage: UIButton!
	
	@IBOutlet weak var nextPage: UIButton!
	
	@IBOutlet weak var curpageLabel: UILabel!
	
	@IBOutlet weak var genre: UISegmentedControl!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
		curPage = 1
		searchPage = 1
		totalPage = 0
		genreid = -1
		flag = 0
		numOfResults = self.defaults.integer(forKey: "numOfResults")
		//print(numOfResults)
		spining.isHidden = true
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
        theSearchBar.delegate = self
		
		
        
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		numOfResults = self.defaults.integer(forKey: "numOfResults")
	}


    
    //MARK: - SearchBar -
	
	@IBAction func changeGenre(_ sender: Any) {
		switch genre.selectedSegmentIndex {
		case 0 :genreid = 28
		case 1 :genreid = 16
		case 2 :genreid = 35
		case 3 :genreid = 27
		default: genreid = -1
		}
		if (flag == 1) {
			if theSearchBar.text != nil {
				
				self.spining.isHidden = false
				
				//print(movieCache.dates)
				DispatchQueue.global(qos: .userInitiated).async {
					
					DispatchQueue.main.async { //Blank out the screen using the main UI thread
						self.movies = []
						self.movieCache.cleanAll()
						self.theCollectionView.reloadData()
						self.spining.startAnimating() //Show spinner so they know the app's thinking about their request
					}
					
					self.searchIMDb(self.searchTitle)
					
					DispatchQueue.main.async {
						self.spining.stopAnimating()
						self.spining.isHidden = true
						self.theCollectionView.reloadData()
					}
				}

			}
		}
		
	}
	
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		self.spining.isHidden = false
		flag = 1
		//curpageLabel.text = "\(curPage)"
		//print(movieCache.dates)
		DispatchQueue.global(qos: .userInitiated).async {
			
			DispatchQueue.main.async { //Blank out the screen using the main UI thread
				self.movies = []
				self.theCollectionView.reloadData()
				self.spining.startAnimating() //Show spinner so they know the app's thinking about their request
			}
			self.searchTitle = searchBar.text!
			self.searchIMDb(searchBar.text!)
			
			DispatchQueue.main.async {
				self.spining.stopAnimating()
				self.spining.isHidden = true
				self.theCollectionView.reloadData()
			}
		}
    }
	//MARK: - Fetch movie data to movie and cache -
	
	
	@IBAction func gotoPrev(_ sender: Any) {
		numOfResults = self.defaults.integer(forKey: "numOfResults")
		let step = numOfResults/20
		//print("gotoprevstep\(step)")
		//print(curPage)

		if (curPage > step) {
			
			curPage -= step
			
			//curpageLabel.text = "\(curPage/step+1)"
			searchPage = curPage
			//print(searchPage)
			self.spining.isHidden = false
			
			//print(movieCache.dates)
			DispatchQueue.global(qos: .userInitiated).async {
				
				DispatchQueue.main.async { //Blank out the screen using the main UI thread
					self.movies = []
					self.movieCache.cleanAll()
					self.theCollectionView.reloadData()
					self.spining.startAnimating() //Show spinner so they know the app's thinking about their request
				}
				
				self.searchIMDb(self.searchTitle)
				
				DispatchQueue.main.async {
					self.spining.stopAnimating()
					self.spining.isHidden = true
					self.theCollectionView.reloadData()
				}
			}
			
		}
		
	}
	
	
	@IBAction func gotoNext(_ sender: Any) {
		let numOfResults = defaults.integer(forKey: "numOfResults")
		let step = numOfResults/20
		//print(curPage)

		if (curPage < totalPage) {
			curPage += step
			curpageLabel.text = "\(curPage/step+1)"
			searchPage = curPage
			//print(searchPage)
			self.spining.isHidden = false
			
			//print(movieCache.dates)
			DispatchQueue.global(qos: .userInitiated).async {
				
				DispatchQueue.main.async { //Blank out the screen using the main UI thread
					self.movies = []
					self.movieCache.cleanAll()
					self.theCollectionView.reloadData()
					self.spining.startAnimating() //Show spinner so they know the app's thinking about their request
				}
				
				self.searchIMDb(self.searchTitle)
				
				DispatchQueue.main.async {
					self.spining.stopAnimating()
					self.spining.isHidden = true
					self.theCollectionView.reloadData()
				}
			}
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

	
	
	private func searchIMDb(_ forContent: String) {
		
		
		
		
		var content=forContent
		content = content.replacingOccurrences(of: " ", with: "%20")
		
		let numOfResults = defaults.integer(forKey: "numOfResults")
		//print("numofResult\(numOfResults)")
		
		let step = numOfResults/20
		//print("step\(step)")
		movieCache.cleanAll()
		
		for i in 0...step-1 {
			
		
			let urlpath = "https://api.themoviedb.org/3/search/movie?include_adult=false&query=\(content)&api_key=28584b707018e6f0a4ead98eaa49b54f&page=\(searchPage+i)"
			
			let jsonResult: JSON = self.getJSON(path: urlpath)
			//if jsonResult == JSON.null {
			//	return
			//}
			
			self.movies = jsonResult["results"]
			//print(movies)
			if let countpage = jsonResult["total_pages"].int {
				totalPage = countpage
			} else {
				totalPage = 0;
			}
		
			//print(totalPage)
			//print(movies)
			if let arr = movies.array {
				for movie in arr {
					let ids = movie["genre_ids"].array
					if (genreid == -1 || ids!.contains(JSON(genreid))) {
						movieCache.addMovie(movie["id"].int, movie["poster_path"].string, movie["vote_average"].double, movie["title"].string,movie["score"].double,movie["release_date"].string,movie["overview"].string)
						let prefix = "http://image.tmdb.org/t/p/w185"
						if movie["poster_path"] != JSON.null {
							let url = NSURL(string: prefix + movie["poster_path"].string!)
							let image = NSData(contentsOf:(url as URL?)!)
							movieCache.images.append (UIImage(data: image! as Data)!)
						} else {
							movieCache.images.append (UIImage(named: "Noimage.jpg")!)
						}
					}
				}
			}
		}
		//print(movieCache.ids)
		let favoriteVC = storyboard?.instantiateViewController(withIdentifier: "FavoriteController") as! FavoriteController
		favoriteVC.movieCache = movieCache
		
	}

    
		
    
    //MARK: - CollectionView -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieCache.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCell
		
		//print(movieCache.ids)
		cell.imageView.image = movieCache.images[indexPath.row]
        cell.movieTitle.text = movieCache.titles[indexPath.row]
		return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailController") as! MovieDetailController
		
		myVC.getId = movieCache.ids[indexPath.row]
        myVC.getTitle = movieCache.titles[indexPath.row]
        myVC.getRate = movieCache.voteAvgs[indexPath.row]
        myVC.getDate = movieCache.titles[indexPath.row]
        myVC.getImage = movieCache.images[indexPath.row]
        myVC.getScore  = movieCache.scores[indexPath.row]
		myVC.getDate = movieCache.dates[indexPath.row]
		myVC.getOverview = movieCache.overviews[indexPath.row]
        self.navigationController?.pushViewController(myVC, animated: true)
        
        
        
        
    }

	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
