//
//  TwitterClient.swift
//  Twitter
//
//  Created by Scott Woody on 9/27/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit


let twitterConsumerKey = "0jxBPb7rJkpIgiVvbyQWBqNND"
let twitterConsumerSecret = "q96WME6vTZoFFpb7DAzBP9Msh6ZRacG4HtTzEnc8aFEAp1of6f"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        // Logs in to twitter and then calls completion block on user/error
        loginCompletion = completion
        
        // Fetch my request token and redirect to the authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
        }) { (error: NSError!) -> Void in
            println("got an error")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func loadUserTimeline(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        // Temporary hack to get around rate limiting, cache the response
        var tweetData = NSUserDefaults.standardUserDefaults().objectForKey("tweetData") as? NSData
        // Remove hack
        tweetData = nil
        if tweetData != nil{
            let tweetArray = NSJSONSerialization.JSONObjectWithData(tweetData!, options: nil, error: nil) as [NSDictionary]
            var tweets = Tweet.tweetsWithArray(tweetArray)
            completion(tweets: tweets, error: nil)
        } else {
            GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                NSUserDefaults.standardUserDefaults().objectForKey("tweetData") as? NSData
                var tweetData = NSJSONSerialization.dataWithJSONObject(response as [NSDictionary], options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(tweetData, forKey: "tweetData")
                
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
                return
            })
        }
    }
    
    func retweet(tweetId: Int, completion: (error: NSError?) -> ()){
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
            return
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(error: error)
            return
        }
    }
    
    func fave(tweetId: Int, completion: (error: NSError?) -> ()){
        var params = ["id": tweetId]
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
            return
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(error: error)
            return
        }
    }
    
    func postTweet(tweetText: String, completion: (error: NSError?) -> ()){
        var params = ["status": tweetText]
        POST("1.1/statuses/update.json", parameters: params, success: { (operations: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("we succeeded in updating")
            completion(error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("we failed in updating")
            completion(error: error)
        }
    }
    
    func openURL(url: NSURL){
        // Fetch the access tokens from the twitter url
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
                return
            })
            
        }) { (error: NSError!) -> Void in
            println("didn't get an auth token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
}
