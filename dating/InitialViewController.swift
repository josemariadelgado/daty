//
//  Created by José María Delgado  on 27/9/16.
//  Copyright © 2016 José María Delgado. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, CLLocationManagerDelegate, FBSDKLoginButtonDelegate {
    
    var loadingIndicator: NVActivityIndicatorView  = {
        var indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.ballClipRotate, color: UIColor(red: 10, green: 10, blue: 10))
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    var loadingLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "LOADING"
        label.textColor = UIColor(red: 10, green: 10, blue: 10)
        
        return label
    }()
    
    var logo: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
        label.textColor = UIColor(red: 10, green: 10, blue: 10)
        label.alpha = 0
        label.text = "daty"
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    var loginDescriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 10, green: 10, blue: 10)
        label.alpha = 0
        label.text = "Log in with Facebook to set up your profile, we will get your name, your gender and your profile image. Of course, we will not post nothing on your Facebook profile."
        label.numberOfLines = 5
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var facebookLoginButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In With Facebook", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 25, green: 130, blue: 240)
        button.layer.cornerRadius = 10
        button.alpha = 0
        
        button.addTarget(self, action: #selector(facebookLoginButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    var phoneNumberDescriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(red: 10, green: 10, blue: 10)
        label.alpha = 0
        label.numberOfLines = 5
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var phoneNumberTextField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.alpha = 0
        textField.backgroundColor = UIColor(red: 225, green: 225, blue: 225)
        textField.layer.cornerRadius = 5
        textField.keyboardType = UIKeyboardType.phonePad
        textField.placeholder = "Your phone number"
        
        textField.addTarget(self, action: #selector(phoneNunmberTextFieldDidChange), for: .editingChanged)
        
        return textField
    }()
    
    lazy var phoneNumberButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 25, green: 130, blue: 100)
        button.layer.cornerRadius = 5
        button.alpha = 0
        
        button.addTarget(self, action: #selector(phoneNumberButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    var birthdayDescriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(red: 10, green: 10, blue: 10)
        label.alpha = 0
        label.text = "Please, tell us your birthday to show your age to the rest of the users"
        label.numberOfLines = 5
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var birthdayDatePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.alpha = 0
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        let maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        let minimumDate = Calendar.current.date(byAdding: .year, value: -150, to: Date())
        datePicker.setDate(maximumDate!, animated: true)
        datePicker.maximumDate = maximumDate
        datePicker.minimumDate = minimumDate
        
        datePicker.addTarget(self, action: #selector(datePickerDidChange), for: .valueChanged)
        
        return datePicker
    }()
    
    var ageLimitLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 11)
        label.textColor = UIColor(red: 10, green: 10, blue: 10)
        label.alpha = 0
        label.text = "You must be 18 or older"
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var birthdayButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 25, green: 130, blue: 100)
        button.layer.cornerRadius = 5
        button.alpha = 0
        
        button.addTarget(self, action: #selector(birthdayButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    var userProfileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.clear
        imageView.alpha = 0
        
        return imageView
    }()
    
    var userNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightUltraLight)
        label.textColor = UIColor(red: 10, green: 10, blue: 10)
        label.alpha = 0
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    var userLocationLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 10, green: 10, blue: 10)
        label.alpha = 0
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    var userPhoneNumberLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 10, green: 10, blue: 10)
        label.alpha = 0
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var signupButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up Now!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 250, green: 130, blue: 80)
        button.layer.cornerRadius = 5
        button.alpha = 0
        
        button.addTarget(self, action: #selector(signupButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    let locationManager = CLLocationManager()
    private var _fbLoginManager: FBSDKLoginManager?
    let databaseRef = FIRDatabase.database().reference()
    let fbLoginReadPermissions = ["email"]
    var userLocality: String!
    var userAdministrativeArea: String!
    var userName: String!
    var userId: String!
    var userGender: String!
    var phoneNumberDescription: String!
    var userPhoneNumber: String!
    var userBirthday: String!
    var userProfileImageURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        view.backgroundColor = UIColor(red: 245, green: 245, blue: 245)
        self.hideKeyboardWhenTappedAround()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.phoneNumberTextField.frame.height))
        phoneNumberTextField.leftView = paddingView
        phoneNumberTextField.leftViewMode = UITextFieldViewMode.always
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus().hashValue != 0 {
            CLGeocoder().reverseGeocodeLocation(locationManager.location!, completionHandler: {(placemarks, error)->Void in
                if (error != nil) {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                if (placemarks?.count)! > 0 {
                    let pm = (placemarks?[0])! as CLPlacemark
                    self.saveUserLocation(placemark: pm)
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
            self.setupConstraints()
        }
    }
    
    func saveUserLocation(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            locationManager.stopUpdatingLocation()
            print(containsPlacemark.administrativeArea)
            print(containsPlacemark.subAdministrativeArea)
            
            
            if let locality : String = containsPlacemark.locality, let administrativeArea : String = containsPlacemark.administrativeArea  {
                self.userLocality = locality
                self.userAdministrativeArea = administrativeArea
            }
            self.destroyLoading()
            self.initLoginView()
        }
    }
    
    func facebookLoginButtonClicked() {
        var fbLoginManager: FBSDKLoginManager {
            get {
                if _fbLoginManager == nil {
                    _fbLoginManager = FBSDKLoginManager()
                }
                return _fbLoginManager!
            }
        }
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: self.fbLoginReadPermissions, from: self, handler: { (result, error) -> Void in
            if (error == nil && !(result?.isCancelled)!){
                self.destroyLoginView()
                self.initLoadingView()
                self.getUserFacebookData()
            } else if error != nil {
                print(error)
            } else if (result?.isCancelled)! {
                
            }
        })
    }
    
    func getUserFacebookData() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email, name, id, gender"]).start(completionHandler: { (connection, result, error) in
            guard let result = result as? NSDictionary, let name = result["name"] as? String, let gender = result["gender"] as? String, let id = result["id"]  as? String else { return }
            self.userName = name
            print(name)
            self.userId = id
            print(id)
            self.userGender = gender
            print(gender)
            self.phoneNumberDescription = "Hello \(name), would you like to add your phone number so people can contact you directly? You can leave it empty if you want ;)"
            self.userProfileImageURL = "https://graph.facebook.com/\(id)/picture?width=500&height=500"
            self.setUserProfileImageFromURL(url: self.userProfileImageURL, imageView: self.userProfileImageView)
            self.destroyLoading()
            self.initPhoneNumberView()
        })
    }
    
    func phoneNumberButtonClicked() {
        let phoneNumber = self.phoneNumberTextField.text
        self.userPhoneNumber = phoneNumber != "" ? phoneNumber : ""
        view.endEditing(true)
        self.destroyPhoneNumberView()
        self.initBirthdayView()
    }
    
    func phoneNunmberTextFieldDidChange() {
        if self.phoneNumberTextField.text == "" {
            self.phoneNumberButton.setTitle("Skip", for: .normal)
            self.phoneNumberButton.alpha = 1
            self.phoneNumberButton.isEnabled = true
        } else {
            let phoneStringCount = self.phoneNumberTextField.text?.characters.count
            self.phoneNumberButton.setTitle("Continue", for: .normal)
            self.phoneNumberButton.alpha = phoneStringCount! < 4 || phoneStringCount! > 13 ? 0.5 : 1
            self.phoneNumberButton.isEnabled = phoneStringCount! < 4 ? false : true
        }
    }
    
    func datePickerDidChange() {
        let date: String = String(describing: self.birthdayDatePicker.date)
        let age = self.birthdayDatePicker.date.age
        self.ageLimitLabel.textColor = age < 18 ? UIColor(red: 250, green: 80, blue: 80) : UIColor(red: 10, green: 10, blue: 10)
        self.birthdayButton.isEnabled = age < 18 ? false : true
        self.birthdayButton.alpha = age < 18 ? 0.3 : 1
        self.userBirthday = date
    }
    
    func birthdayButtonClicked() {
        self.destroytBirthdayView()
        self.initProfileView()
    }
    
    func setUserProfileImageFromURL(url: String, imageView: UIImageView) {
        if let url  = NSURL(string: url), let data = NSData(contentsOf: url as URL) {
            imageView.image = UIImage(data: data as Data)
        }
    }
    
    func signupButtonClicked() {
        let userName = self.userName as NSString
        let gender = self.userGender as NSString
        let location = "\(self.userLocality! as NSString), \(self.userAdministrativeArea!)" as NSString
        let phoneNumber = self.userPhoneNumber != "" ? self.userPhoneNumber as NSString : "undefined" as NSString
        
        self.databaseRef.child("users").child(self.userId!).setValue(["userName": userName , "gender": gender,"location": location, "phoneNumber": phoneNumber])
        self.databaseRef.child("locations").child(self.userAdministrativeArea).setValue([self.userId as NSString])
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func initLoadingView() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.loadingIndicator.startAnimating()
            self.loadingIndicator.alpha = 1
            self.loadingLabel.alpha = 1
        })
    }
    
    func destroyLoading() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.alpha = 0
            self.loadingLabel.alpha = 0
        })
    }
    
    func initLoginView() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.logo.alpha = 1
            self.loginDescriptionLabel.alpha = 1
            self.facebookLoginButton.alpha = 1
        })
    }
    
    func destroyLoginView() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.logo.alpha = 0
            self.loginDescriptionLabel.alpha = 0
            self.facebookLoginButton.alpha = 0
        })
    }
    
    func initPhoneNumberView() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.phoneNumberDescriptionLabel.text = self.phoneNumberDescription
            self.phoneNumberDescriptionLabel.alpha = 1
            self.phoneNumberTextField.alpha = 1
            self.phoneNumberButton.alpha = 1
        })
    }
    
    func destroyPhoneNumberView() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.phoneNumberDescriptionLabel.text = self.phoneNumberDescription
            self.phoneNumberDescriptionLabel.alpha = 0
            self.phoneNumberTextField.alpha = 0
            self.phoneNumberButton.alpha = 0
        })
    }
    
    func initBirthdayView() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.birthdayDescriptionLabel.alpha = 1
            self.birthdayDatePicker.alpha = 1
            self.ageLimitLabel.alpha = 1
            self.birthdayButton.alpha = 1
        })
    }
    
    func destroytBirthdayView() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.birthdayDescriptionLabel.alpha = 0
            self.birthdayDatePicker.alpha = 0
            self.ageLimitLabel.alpha = 0
            self.birthdayButton.alpha = 0
        })
    }
    
    func initProfileView() {
        let userAge = self.birthdayDatePicker.date.age
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.userNameLabel.alpha = 1
            self.userNameLabel.text = "\(self.userName!), \(userAge)"
            self.userProfileImageView.alpha = 1
            self.userLocationLabel.alpha = 1
            self.userLocationLabel.text = "\(self.userLocality!), \(self.userAdministrativeArea!)"
            self.userPhoneNumberLabel.alpha = 1
            self.userPhoneNumberLabel.text = self.userPhoneNumber!
            self.signupButton.alpha = 1
        })
    }
    
    func setupConstraints() {
        view.addSubview(loadingIndicator)
        view.addSubview(loadingLabel)
        view.addSubview(logo)
        view.addSubview(loginDescriptionLabel)
        view.addSubview(facebookLoginButton)
        view.addSubview(phoneNumberDescriptionLabel)
        view.addSubview(phoneNumberTextField)
        view.addSubview(phoneNumberButton)
        view.addSubview(birthdayDatePicker)
        view.addSubview(ageLimitLabel)
        view.addSubview(birthdayButton)
        view.addSubview(birthdayDescriptionLabel)
        view.addSubview(userNameLabel)
        view.addSubview(userProfileImageView)
        view.addSubview(userLocationLabel)
        view.addSubview(userPhoneNumberLabel)
        view.addSubview(signupButton)
        
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        loginDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginDescriptionLabel.bottomAnchor.constraint(equalTo: facebookLoginButton.topAnchor, constant: -50).isActive = true
        loginDescriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        facebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        phoneNumberDescriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        phoneNumberDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneNumberDescriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        
        phoneNumberTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberDescriptionLabel.bottomAnchor, constant: 30).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        phoneNumberTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        phoneNumberButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneNumberButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 10).isActive = true
        phoneNumberButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        phoneNumberButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        birthdayDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        birthdayDescriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        birthdayDescriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        
        birthdayDatePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        birthdayDatePicker.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        ageLimitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ageLimitLabel.bottomAnchor.constraint(equalTo: birthdayButton.topAnchor, constant: -5).isActive = true
        
        birthdayButton.bottomAnchor.constraint(equalTo: birthdayDatePicker.topAnchor, constant: -20).isActive = true
        birthdayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        birthdayButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        birthdayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        userProfileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        userProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        userNameLabel.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 20).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        userLocationLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10).isActive = true
        userLocationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userLocationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        userPhoneNumberLabel.topAnchor.constraint(equalTo: userLocationLabel.bottomAnchor, constant: 10).isActive = true
        userPhoneNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userPhoneNumberLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        signupButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////// Facebook login preferences
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil {
            print("Login complete.")
        } else {
            print(error.localizedDescription)
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out...")
    }
    //////////////////////////////
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

