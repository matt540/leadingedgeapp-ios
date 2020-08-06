//
//  Register_VC.swift
//  Surf Board
//
//  Created by HariKrishna Kundariya on 04/12/19.
//  Copyright © 2019 eSparkBiz. All rights reserved.
//

import UIKit
import Alamofire

class Register_VC: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnTakePicture: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet var btnAlreadyAccount: UIButton!
    
    @IBOutlet weak var ViewName: UIView!
    @IBOutlet weak var ViewEmail: UIView!
    @IBOutlet weak var ViewPassword: UIView!
    @IBOutlet weak var ViewZip: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        AppDelegate.shared().setupNavigationBar()
        //        setLeftBarBackItem()
        //        setTranspertNavigation()
        //        self.title = "Register"
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupUI() {
        
        imgUser.addCornerRadius(imgUser.frame.size.height/2.0)
        imgUser.contentMode = .scaleAspectFill
        ViewName.addCornerRadius(10.0)
        ViewEmail.addCornerRadius(10.0)
        ViewPassword.addCornerRadius(10.0)
        ViewZip.addCornerRadius(10.0)
        btnTakePicture.addCornerRadius(10.0)
        btnRegister.addCornerRadius(10.0)
        btnTakePicture.addShadow(color: UIColor.lightGray, opacity: 2, offset: CGSize.zero, radius: 10.0)
        btnRegister.addShadow(color: UIColor.lightGray, opacity: 2, offset: CGSize.zero, radius: 10.0)
        
    }
    
    //MARK: - Button Actions
    @IBAction func btnAlreadyAccountAction(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Login_VC")  as! Login_VC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @IBAction func btnTakePictureAction(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "From Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "From Gallary", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        
        if(self.txtName.text == "")
        {
            displayAlert(APPNAME, andMessage: "Please Enter Name.")
        }
        else if(self.txtEmail.text == "" || self.txtEmail.text?.isValidEmail == false)
        {
            displayAlert(APPNAME, andMessage: "Please Enter Valid Email.")
        }
        else if(self.txtPassword.text == "")
        {
            displayAlert(APPNAME, andMessage: "Please Enter Password.")
        }
//        else if(self.txtZipcode.text == "")
//        {
//            displayAlert(APPNAME, andMessage: "Please Enter Zipcode.")
//        }
        else
        {
            RegisterUser_API()
        }
        
    }
    
    
    //MARK: - Open the camera
    func openCamera(){
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //MARK: - Choose image from Gallary
    func openGallary(){
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    //MARK: - ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        self.imgUser.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Register Api Call
    func RegisterUser_API() {
        
        let url = API.BASE_URL + API.REGISTER
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            let params: Parameters = ["name": self.txtName.text!, "email": self.txtEmail.text!,"password": self.txtPassword.text!,"zipcode": self.txtZipcode.text!]
            AppDelegate.shared().ShowSpinnerView()
            
            Alamofire.upload(multipartFormData:
                {
                    (multipartFormData) in
                    
                    DispatchQueue.main.sync {
                        multipartFormData.append(self.imgUser.image!.jpegData(compressionQuality: 0.75)!, withName: "image", fileName: "Image.jpeg", mimeType: "image/jpg")
                        for (key, value) in params
                        {
                            multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                    }
            }, to:url,headers:nil)
            { (result) in
                switch result {
                case .success(let upload,_,_):
                    upload.uploadProgress(closure: {(progress) in
                        //Print progress
                    })
                    upload.responseJSON
                        { response in
                            if response.result.value != nil
                            {
                                AppDelegate.shared().HideSpinnerView()
                                
                                let dict :NSDictionary = response.result.value! as! NSDictionary
                                print(dict)
                                let status = dict.value(forKeyPath: "status") as? String ?? ""
                                if(status == "success")
                                {
                                    self.txtName.text = ""
                                    self.txtZipcode.text = ""
                                    self.txtEmail.text = ""
                                    self.txtPassword.text = ""
                                    self.imgUser.image = UIImage(named: "Register_Icon.png")
                                    
//                                    self.navigationController?.isNavigationBarHidden = true
//                                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Login_VC")  as! Login_VC
//                                    self.navigationController?.pushViewController(nextVC, animated: true)
                                    
                                    var dictUser:NSMutableDictionary = [:]
                                    let dictMain = dict.value(forKeyPath: "data.user") as? NSDictionary
                                    dictUser = (dictMain)!.mutableCopy() as! NSMutableDictionary
                                    UserDefaults.standard.set(dictUser, forKey: "UserAllData")
                                    UserDefaults.standard.synchronize()
                                    
                                    let userToken = dict.value(forKeyPath: "data.token") as! String
                                    AppPrefs.shared.saveUserId(userId: userToken)
                                    AppPrefs.shared.setIsUserLogin(isUserLogin: true)
                                    AppPrefs.shared.setIsUserRememberLogin(isUserLogin: true)
                                    
                                    let strUserName:String = (dictUser.value(forKeyPath: "name") as? String)!
                                    AppPrefs.shared.saveUserName(name: strUserName)
                                    
                                    let strProfile:String = (dictUser.value(forKeyPath: "image") as? String)!
                                    AppPrefs.shared.saveUserProfile(url: strProfile)
                                    
                                    self.navigationController?.isNavigationBarHidden = true
                                    self.goToHome(animated: true)

                                }
                                else
                                {
                                    displayAlert(APPNAME, andMessage: dict.value(forKeyPath: "message") as! String)
                                }
                            }
                    }
                case .failure(let encodingError):
                    AppDelegate.shared().HideSpinnerView()
                    print("Error : \(encodingError)")
                    break
                }
            }
        }
        else
        {
            displayAlert(APPNAME, andMessage: MSG.NO_NETWORK)
        }
    }
}
