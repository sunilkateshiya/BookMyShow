 //
//  ViewController.swift
//  BookMyShow
//
//  Created by iFlame on 5/16/17.
//  Copyright © 2017 iFlame. All rights reserved.
//

import UIKit
extension UIImageView{
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
 }
 
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorLable: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var eventList:NSArray = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        activityIndicator.startAnimating()
        BookMyShowManager.sharedInstance.getMovieList(completionHandler:  { (movies) in
            DispatchQueue.main.sync {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                self.tableView.isHidden = false
            }
            self.eventList = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        });
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("Memory Worning Reseved");
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MovieListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MoviePosterCell
        let eventDictionary:Events = self.eventList.object(at: indexPath.row) as! Events
        
        let movieNameAttribute = [NSFontAttributeName : UIFont.systemFont(ofSize : 18)]
        let languageAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)]
        let MovieHeaderName = NSMutableAttributedString()
        MovieHeaderName.append(NSMutableAttributedString(string: eventDictionary.eventName, attributes: movieNameAttribute))
        MovieHeaderName.append(NSMutableAttributedString(string: ", ", attributes: languageAttribute))
        MovieHeaderName.append(NSMutableAttributedString(string: eventDictionary.language, attributes: languageAttribute))
        
        cell.movieName.attributedText = MovieHeaderName
        cell.movieGenre.text = eventDictionary.genres
        cell.posterImage.downloadImageFrom(link: eventDictionary.bannerUrl, contentMode: UIViewContentMode.scaleAspectFill)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        
        vc.eventDetails = self.eventList.object(at: indexPath.row) as! Events
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


}

