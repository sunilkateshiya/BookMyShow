//
//  BookMyShowManager.swift
//  BookMyShow
//
//  Created by iFlame on 5/16/17.
//  Copyright © 2017 iFlame. All rights reserved.
//

import Foundation
typealias ComplitionHandler = (NSArray) -> Void

protocol Singleton: class {
    static var sharedInstance: Self { get }
}

class BookMyShowManager: NSObject
{
    class var sharedInstance : BookMyShowManager {
        struct Singleton{
            static let instance = BookMyShowManager()
        }
        return Singleton.instance
    }
    func getMovieList(completionHandler: @escaping ComplitionHandler) {
        let task = URLSession.shared.dataTask(with: URL.init(string: "http://data.in.bookmyshow.com/getData.aspx?cc=&cmd=GETEVENTLIST&dt=&et=MT&f=json&lg=72.842588&lt=19.114186&rc=MUMBAI&sr=&t=a54a7b3aba576256614a")!)
        { (data,responce,error) in
                       
            if (data != nil)
            {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                
                    let bookMyShow = json.object(forKey: "BookMyShow") as! NSDictionary
                    
                    completionHandler(self.parseResponse(allEvents: bookMyShow))
                 
                    
                } catch {
                    print(error)
                }
            }
            
            
        };
        task.resume()
    }
    func parseResponse(allEvents: NSDictionary) -> NSArray {
        let parsedEventList: NSMutableArray = NSMutableArray.init(array:[]);
        var eventList: NSArray = NSArray.init(array:[]);
        eventList = allEvents.object(forKey: "arrEvent") as! NSArray
        
        for eventObjact in eventList {
            let event : NSDictionary = eventObjact as! NSDictionary
            let events : Events = Events.init();
            events.eventName = event.object(forKey: "EventTitle") as! String
            events.playbackUri = event.object(forKey: "TrailerURL")as! String
            events.releaseDate = event.object(forKey: "EventReleaseDate") as! String
            events.length = event.object(forKey: "Length") as! String
            events.directore = event.object(forKey: "Director") as! String
            events.actors = event.object(forKey: "Actors") as! String
            events.genres = event.object(forKey: "Genre") as! String
            events.language = event.object(forKey: "Language") as! String
            events.synopsys = event.object(forKey: "EventSynopsis") as! String
            events.bannerUrl = event.object(forKey: "BannerURL") as! String
            parsedEventList.add(events)
            
        }
        return parsedEventList as NSArray
    }
}
