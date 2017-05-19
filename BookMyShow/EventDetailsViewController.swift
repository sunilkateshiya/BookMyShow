//
//  EventDetailsViewController.swift
//  BookMyShow
//
//  Created by iFlame on 5/16/17.
//  Copyright © 2017 iFlame. All rights reserved.
//
import Foundation
import UIKit
import youtube_ios_player_helper


class EventDetailsViewController: UIViewController {
    
    var eventDetails = Events.init();
    
    @IBOutlet weak var youtubePlayer: YTPlayerView!

    @IBOutlet weak var generTextView: UITextView!
    @IBOutlet weak var releaseData: UILabel!
    
    @IBOutlet weak var runTime: UILabel!
     @IBOutlet weak var Director: UILabel!
    
    @IBOutlet weak var languageTextView: UITextView!
    
    @IBOutlet weak var castTextView: UITextView!
    
    @IBOutlet weak var synopsysTextView: UITextView!
    
    override func viewDidLoad() {
        self.title = self.eventDetails.eventName;
        let playbackURL = self.eventDetails.playbackUri;
        let regexString = self.extraYoutubeIdFromLink(link : playbackURL)
        self.youtubePlayer.load(withVideoId: regexString!)
        self.releaseData.text = self.eventDetails.releaseDate;
        self.runTime.text = self.eventDetails.length
        self.Director.text = self.eventDetails.directore
        let actors = self.eventDetails.actors
        let actorList = actors.replacingOccurrences(of: " , ", with: "\n")
        self.castTextView.text = actorList
        
        let genres = self.eventDetails.genres
        let genresList = genres.replacingOccurrences(of: " , ", with: "\n")
        self.generTextView.text = genresList
        self.languageTextView.text = self.eventDetails.language
        self.synopsysTextView.text = self.eventDetails.synopsys
       

        // Do any additional setup after loading the view.
    }
    func extraYoutubeIdFromLink(link: String) -> String? {
        
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
        else
        {
           return nil
        }
        let nslink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let ramge = NSRange(location: 0, length: nslink.length)
        let matches = regExp.matches(in: link as String, options: options, range: ramge)
        if let fristmatch = matches.first{
            print(fristmatch)
            return nslink.substring(with: fristmatch.range)
        }
        
        return nil
      
        
    }

}
