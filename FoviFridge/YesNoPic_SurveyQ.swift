//
//  YesNoPic_SurveyQ.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/15/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift
import Alamofire

class YesNoPic_SurveyQ: UIView {

    var view: UIView!
    
    @IBOutlet var yesButton: UIButton!
    
    @IBOutlet var noButton: UIButton!
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var surveyPic: UIImageView!
    
    var image_url : NSURL?
    
    var question = SurveyQuestion() // Set in Survey VC
    
    var cUser = UserDetails() // Set here
    
    var today = NSDate()
    
    
    
    
    func getImage(){
        KingfisherManager.sharedManager.retrieveImageWithURL(image_url!, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
            self.surveyPic.image = image
        })
    }
    
    
    func queryUserInfo(){
        let realm = try! Realm()
        let userDetails = realm.objects(UserDetails).first
        print("UserDetails")
        print(userDetails!.paid_for_removeSurvey)
        print(userDetails!.the_last_answered)
        print("...")
        if userDetails != nil{
            self.cUser = userDetails!
        }else{
            // Create UserDetail, segue to walkthrough/onboard
        }
    }
    
    
    
    
    func sendYesAnswer(){
        print("Yes")
        sendYes(self.question)
    }
    
    func sendNoAnswer(){
        print("No")
        sendNo(self.question)
    }
    
    // YesNo + YesNoPic
    
    func sendYes(q : SurveyQuestion){
        send_YesNo_Answer("Yes", question: q.question!, question_id: q.question_id!)
    }
    
    func sendNo(q : SurveyQuestion){
        send_YesNo_Answer("No", question: q.question!, question_id: q.question_id!)
    }
    
    
    // Send Answer to Survey Question
    func send_YesNo_Answer(answer : String, question : String, question_id : Int){
        print("Posting...")
        let parameters = [
            "answer": "\(answer)",
            "question": "\(question)",
            "question_id": question_id
        ]
        
        
        Alamofire.request(.POST, "https://rocky-fjord-88249.herokuapp.com/api/v1/answers", parameters: parameters as? [String : AnyObject], encoding: .JSON)
        //        debugPrint(teth)
        print("Posted Answer to Survey...")
        
        
        print("\(cUser.name) is adding Question Id to the list")
        
        let realm = try! Realm()
        var q_id = SurveyQuestions()
        q_id.id = "\(question_id)"
        
        try! realm.write {
            cUser.the_last_answered = today
            cUser.survey_questions_answered.append(q_id)
            print("Added Question Id and Updated Last Answered date")
        }
        
    }

    
    
    
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        yesButton.addTarget(self, action: "sendYesAnswer", forControlEvents: .TouchUpInside)
        noButton.addTarget(self, action: "sendNoAnswer", forControlEvents: .TouchUpInside)
        
        queryUserInfo()

    
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        surveyPic.layer.cornerRadius = 5
        //        alerter.helloLabel.text = "Bye"
        //        yesButton.layer.cornerRadius = 5
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "YesNoPic_SurveyQ", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    


}
