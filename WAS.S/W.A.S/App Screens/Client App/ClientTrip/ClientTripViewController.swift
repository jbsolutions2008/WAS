//
//  StartTripViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 27/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit
import Starscream
import Cosmos

struct TipAmount {
    let TipAmount1 = "2"
    let TipAmount2 = "5"
    let TipAmount3 = "10"
}

class ClientTripViewController: UIViewController {

    @IBOutlet weak var lblHours : UILabel!
    @IBOutlet weak var lblMinute : UILabel!
    @IBOutlet weak var lblSeconds : UILabel!
    
    @IBOutlet weak var btnSubmitRating : UIButton!
    @IBOutlet weak var btnPayTip : UIButton!
    @IBOutlet weak var vwTripCharge : UIView!
    @IBOutlet weak var vwRatings : UIView!
    @IBOutlet weak var vwCharges : UIView!
    @IBOutlet weak var lblCharges : UILabel!
    
    
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var scrlView : UIScrollView!
    
    @IBOutlet weak var vwPayTip : UIView!
    @IBOutlet weak var vwTipButtonContainer : UIView!
    
    @IBOutlet weak var btnTip1 : UIButton!
    @IBOutlet weak var btnTip2 : UIButton!
    @IBOutlet weak var btnTip3 : UIButton!
    
    @IBOutlet weak var txtAddTip : UITextField!
    @IBOutlet weak var txtReview : UITextField!
    
    @IBOutlet weak var bottomToRatings : NSLayoutConstraint!
    @IBOutlet weak var bottomToTimer : NSLayoutConstraint!
    @IBOutlet weak var starRating : CosmosView!
    
    var currentRequest : [String : Any]!
    
   // var isTripStarted = false
    var timer = Timer()
    var tripStartDate : Date!
    var tripEndDate : Date!
    var startTimer = false
    var isTripEnded = false
    
    
    //MARK:View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        WebSocketManager.sharedInstance.delegate = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(startTimerAfterTransitionToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        designInterFace()
        txtAddTip.addTarget(self, action: #selector(testFieldEditingChanged(textField:)), for: .editingChanged)
        
        if RDGlobalFunction.appDelegate.doesRequestExist {
           // TripStartTime
            let tripStartTime = (currentRequest["TripStartTime"] as! Int)/1000
            self.tripStartDate = Date(timeIntervalSinceNow: TimeInterval(-tripStartTime))
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    func designInterFace() {
        
        self.btnSubmitRating.titleLabel?.font = UIFont(name: RDDataEngineClass.robotoFontBold, size: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4))
        RDGlobalFunction.setCornerRadius(any: self.btnSubmitRating, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        vwPayTip.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    override func viewDidLayoutSubviews() {
      
        self.vwPayTip.layoutSubviews()
        RDGlobalFunction.setCornerRadius(any: self.btnTip1, cornerRad: self.btnTip1.frame.height/2, borderWidth: 0.5, borderColor: RDDataEngineClass.accentShadeColor)
        RDGlobalFunction.setCornerRadius(any: self.btnTip2, cornerRad: self.btnTip1.frame.height/2, borderWidth: 0.5, borderColor: RDDataEngineClass.accentShadeColor)
        RDGlobalFunction.setCornerRadius(any: self.btnTip3, cornerRad: self.btnTip1.frame.height/2, borderWidth: 0.5, borderColor: RDDataEngineClass.accentShadeColor)
       
        RDGlobalFunction.setCornerRadius(any: self.vwTripCharge, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
        RDGlobalFunction.setCornerRadius(any: self.btnPayTip, cornerRad: 0, borderWidth: 1, borderColor: UIColor.black)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    //MARK: UIButton Actions
    @IBAction func btnPayTipPressed() {
        var amount = 0
        
        if !btnTip1.isSelected && !btnTip2.isSelected && !btnTip3.isSelected && txtAddTip.text == "" {
            UtilityClass.showAlertOnNavigationBarWith(message: "Please select or add amount", title: "Alert", alertType: .failure)
        } else {
            if btnTip1.isSelected {
                amount = 2
            } else if btnTip2.isSelected {
                amount = 5
            } else if btnTip3.isSelected {
                amount = 10
            } else if Int(txtAddTip.text!)! > 0 {
                amount = Int(txtAddTip.text!)!
            } else {
                UtilityClass.showAlertOnNavigationBarWith(message: "Please enter valid amount", title: "Alert", alertType: .failure)
            }
            
            UtilityClass.showActivityIndicator()
            
            let params = ["ClientId" : currentRequest["ClientId"]!,"ProviderId" : currentRequest["ProviderId"]!,"TripId": currentRequest["TripId"]!,"TipAmount":amount]
            
            
            ClientProviderAPIManager.sharedInstance.postTipAmountAPI(selectedVC: self, tipParameters: params, postTipAmount: TIPTRANSACTION) { (responseObject, success) in
              
                UtilityClass.removeActivityIndicator()
                if success {
                    UtilityClass.showAlertOnNavigationBarWith(message: responseObject["ErrorSuccessMsg"] as? String, title: "Success", alertType: .success)
                }
            }
        }
    }
    
    @IBAction func btnshowTipView() {
        vwPayTip.isHidden = false
    }
    
    
    @IBAction func btnTipAmountPressed(sender:UIButton) {
        if !sender.isSelected {
            let containerView = sender.superview
            
            for subView in containerView!.subviews {
                    if  subView.tag == sender.tag {
                        if subView is UIButton {
                            (subView as! UIButton).isSelected = true
                            subView.backgroundColor = RDDataEngineClass.primaryColor
                            RDGlobalFunction.setCornerRadius(any: subView, cornerRad: subView.frame.height/2, borderWidth: 0, borderColor: .clear)
                        }
                    } else if subView.tag != sender.tag {
                        if subView is UIButton {
                            (subView as! UIButton).isSelected = false
                            subView.backgroundColor = .white
                            RDGlobalFunction.setCornerRadius(any: subView, cornerRad: subView.frame.height/2, borderWidth: 0.5, borderColor: .gray)
                        }
                    }
                }
            txtAddTip.text = ""
        }
    }
    
   
    
    @IBAction func submitReviewPressed() {
//        if txtReview.text == "" {
//            UtilityClass.showAlertOnNavigationBarWith(message: "Please enter your review", title: "Error", alertType: .failure)
//        } else {
            self.submitReview()
       // }
    }
    
    //MARK:WebService
    func submitReview() {
        UtilityClass.showActivityIndicator()
        let param = ["ClientId" : currentRequest["ClientId"]!,"ProviderId" : currentRequest["ProviderId"]!,"TripId": currentRequest["TripId"]!,"ReviewComment":txtReview.text!,"Rattings":"\(starRating.rating)","UserTypeCode":Numeric_Usercode.client]
        
        ClientProviderAPIManager.sharedInstance.postTripReview(selectedVC: self, reviewParameters: param, postTripReview:SUBMITREVIEW ) { (responseObject, success) in
            
            UtilityClass.removeActivityIndicator()
            self.navigationController?.popViewController(animated: true)
            if success {
                UtilityClass.showAlertOnNavigationBarWith(message: responseObject["ErrorSuccessMsg"] as? String, title: "Success", alertType: .success)
            }
        }
    }
    
    
    
    //MARK: Other Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.vwPayTip.isHidden = true
    }
    
    @objc func timerAction() {
        let timeElapsed = Date().timeIntervalSince1970 - self.tripStartDate.timeIntervalSince1970
        
        lblMinute.text = timeElapsed.stringFromTimeInterval().1
        lblHours.text = timeElapsed.stringFromTimeInterval().0
        lblSeconds.text = timeElapsed.stringFromTimeInterval().2
    }
    
    @objc func startTimerAfterTransitionToForeground() {
        if startTimer {
            startTimer = false
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        } else if isTripEnded {
            isTripEnded = false
            
            let timeElapsed = tripEndDate.timeIntervalSince1970 - self.tripStartDate.timeIntervalSince1970
            
            lblMinute.text = timeElapsed.stringFromTimeInterval().1
            lblHours.text = timeElapsed.stringFromTimeInterval().0
            lblSeconds.text = timeElapsed.stringFromTimeInterval().2
        }
    }
}

extension ClientTripViewController : SocketConnectionDelegate {
    
    //"isClientRequest":true,"RequestStatus":"cancelled"
    
    func onConnect(socket: WebSocketClient) {
        
    }
    
    func onDisconnect(socket: WebSocketClient, error: Error?) {
        if (error as? WSError)?.code == 57 {
            //  requestSocketToChangeStatusOrLocation()
        }
    }
    
    func onMessage(socket: WebSocketClient, text: String) {
        
        if (socket as! WebSocket) == WebSocketManager.sharedInstance.clientproviderRequestSocket {
            
            if let data = text.data(using: .utf8) {
                do {
                    let dict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let user = dict!["RequestType"] {
                        if user as! String == Request_Status.Started {
                            self.tripStartDate = Date()
                            if UIApplication.shared.applicationState.rawValue == 2 {
                                startTimer = true
                            } else {
                                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                            }
                        } else if user as! String == Request_Status.Ended {
                            
                            startTimer = false
                            if UIApplication.shared.applicationState.rawValue == 2 {
                                isTripEnded = true
                                self.tripEndDate = Date()
                            }
                            if dict!["ChargeStatus"] as! String == "succeeded" {
                                UtilityClass.showAlertWithMessage(message: "Thank You for Trip!Your payment of $\(dict!["StripeChargeAmount"] ?? "0") has been Paid with us", title: "Success", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                                    if isConfirm {
                                        
                                    }
                                })
                            }
                            
                            self.lblCharges.text = "$ \(dict!["StripeChargeAmount"]!)"
                            self.vwCharges.isHidden = false
                            self.timer.invalidate()
                            self.bottomToRatings.priority = .defaultHigh
                            self.bottomToTimer.priority = .defaultLow
                            self.vwRatings.isHidden = false
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension ClientTripViewController : UITextFieldDelegate {
    @objc func testFieldEditingChanged(textField : UITextField) {
        btnTip1.isSelected = false
        btnTip2.isSelected = false
        btnTip3.isSelected = false
    }
}
