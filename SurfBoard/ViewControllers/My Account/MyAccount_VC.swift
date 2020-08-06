//
//  MyAccount_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/23/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import Stripe
import FirebaseCrashlytics
import Crashlytics
//import CropViewController

class MyAccount_VC: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,STPPaymentCardTextFieldDelegate {
    
    var isFromMenu:Bool = false
    var imagePicker = UIImagePickerController()
    var picker:UIPickerView!
    var pickerCountry:UIPickerView!
    var arrState:NSMutableArray = []
    var arrCountry:NSMutableArray = []
    var dictUserData:NSMutableDictionary = [:]
    var StateCode:String!
    var Flag:String = "Edit"
    var cards = [AnyObject]()
    
    //var paymentTextField:STPPaymentCardTextField!
    //let cardField = STPPaymentCardTextField()
    //CropViewController
    //    var croppingStyle = CropViewCroppingStyle.default
    //    var croppedRect = CGRect.zero
    //    var croppedAngle = 0
    //CropViewController
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtZip: UITextField!
    @IBOutlet var txtAddress: UITextView!
    @IBOutlet var btnResetPassword: UIButton!
    
    @IBOutlet var viewMyPayment: UIView!
    @IBOutlet var viewMyPaymentHeight: NSLayoutConstraint!
    
    @IBOutlet var btnEditPic: UIButton!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var btnSaveEdit: UIButton!
    
    @IBOutlet var lblNameTitle: UILabel!
    @IBOutlet var lblEmailTitle: UILabel!
    @IBOutlet var lblAddressTitle: UILabel!
    @IBOutlet var lblCityTitle: UILabel!
    @IBOutlet var lblStateTitle: UILabel!
    @IBOutlet var lblCountryTitle: UILabel!
    @IBOutlet var lblZipTitle: UILabel!
    
//    @IBOutlet var btnTermsConditions: UIButton!
//    @IBOutlet var btnPrivacyPolicy: UIButton!
    
    
    //@IBOutlet var cardView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.cardView.addSubview(cardField)
        //self.cardView.backgroundColor = UIColor.clear
        
        self.imagePicker.delegate = self
        //self.imgUser.addCornerRadius(imgUser.frame.size.width/2.0)
        
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2
        self.imgUser.clipsToBounds = true
        self.imgUser.contentMode = .scaleAspectFill
        
//        self.btnTermsConditions.addCornerRadius(5)
//        self.btnTermsConditions.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
//        self.btnTermsConditions.layer.borderWidth = 1
//
//        self.btnPrivacyPolicy.addCornerRadius(5)
//        self.btnPrivacyPolicy.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
//        self.btnPrivacyPolicy.layer.borderWidth = 1
        
        if(isFromMenu == true)
        {
            self.navigationController?.isNavigationBarHidden = false
            AppDelegate.shared().setupNavigationBar()
            setLeftBarBackItem()
            self.title = "My Account"
            setTranspertNavigation()
        }
        else
        {
            self.navigationController?.isNavigationBarHidden = false
            AppDelegate.shared().setupNavigationBar()
            self.title = "My Account"
            setTranspertNavigation()
        }
        
        self.tableView.separatorStyle = .none
        
        //self.arrState = AppDelegate.shared().arrAllState
        self.arrCountry = AppDelegate.shared().arrAllCountry
        
        self.txtCountry.isUserInteractionEnabled = false
        self.txtCountry.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9490196078, blue: 0.937254902, alpha: 1)
        self.txtEmail.isUserInteractionEnabled = false
        self.txtEmail.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9490196078, blue: 0.937254902, alpha: 1)
        
        self.btnSaveEdit.addCornerRadius(5.0)
        self.btnEditPic.addCornerRadius(5.0)
        self.btnResetPassword.addCornerRadius(5.0)
        
        self.txtAddress.addCornerRadius(10.0)
        self.txtAddress.layer.borderWidth = 1
        self.txtAddress.layer.borderColor = UIColor.lightGray.cgColor
        
        self.picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
        self.txtState.inputView = self.picker
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClicked))]
        numberToolbar.sizeToFit()
        self.txtState.inputAccessoryView = numberToolbar
        
        self.pickerCountry = UIPickerView()
        self.pickerCountry.delegate = self
        self.pickerCountry.dataSource = self
        self.txtCountry.inputView = self.pickerCountry
        
        let numberToolbar1 = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar1.barStyle = .default
        numberToolbar1.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClickedCountry))]
        numberToolbar1.sizeToFit()
        self.txtCountry.inputAccessoryView = numberToolbar1
        
        let arrTextFields = [self.txtName,self.txtZip,self.txtAddress,self.txtCity,self.txtState,self.txtCountry]
        for txt in arrTextFields
        {
            txt?.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9490196078, blue: 0.937254902, alpha: 1)
            txt?.isUserInteractionEnabled = false
        }
        
        GetUserDetails_API()
        
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 80, width: 100, height: 30)
//        button.setTitle("Crash", for: [])
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//        self.view.addSubview(button)
    }
   
//    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//        fatalError()
//        Crashlytics.sharedInstance().crash()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupData()
        self.setupLang()
        
        //cardField.becomeFirstResponder()
    }
    
    //    override func viewDidLayoutSubviews() {
    //
    //        let padding: CGFloat = 0
    //        cardField.frame = CGRect(x: padding,
    //                                 y: padding,
    //                                 width: self.cardView.frame.size.width,//view.bounds.width - (padding * 2),
    //                                 height: self.cardView.frame.size.height)
    //
    //    }
    
    //MARK: - doneClickedCountry Method
    @objc func doneClickedCountry() -> Void
    {
        self.view.endEditing(true)
        
        if(self.txtCountry.text! == "")
        {
            let dictdata = self.arrCountry[0] as? NSDictionary
            let country = dictdata?.value(forKey: "name") as? String
            self.txtCountry.text = country
            
            self.arrState = []
            let arr = dictdata?.value(forKey: "states") as? NSArray
            for dict in arr!
            {
                self.arrState.add(dict)
            }
            
            AppDelegate.shared().arrAllState = []
            AppDelegate.shared().arrAllState =  self.arrState
            
        }
    }
    
    @objc func doneClicked() -> Void
    {
        self.view.endEditing(true)
        
        if(self.txtState.text! == "")
        {
            let dictdata = self.arrState[0] as? NSDictionary
            let code = dictdata?.value(forKey: "code") as? String
            let state = dictdata?.value(forKey: "name") as? String
            self.txtState.text = state
            StateCode = code
        }
        
    }
    
    func setupLang(){
        
        let lang = DGLocalization.sharedInstance.getCurrentLanguage()
        
        if (lang.languageCode == "en"){
            print("Selected Lang english")
            self.SetupLangData()
        }
        else if (lang.languageCode == "es"){
            print("Selected Lang Spanish")
            self.SetupLangData()
        }
        else if (lang.languageCode == "de"){
            print("Selected Lang German")
            self.SetupLangData()
        }
        else if (lang.languageCode == "fr"){
            print("Selected Lang French")
            self.SetupLangData()
        }
        else if (lang.languageCode == "it"){
            print("Selected Lang Italian")
            self.SetupLangData()
        }
        else{
            
        }
    }
    
    func SetupLangData(){
        
        self.title = "MY_ACCOUNT_TITLE".localize
        
        self.tabBarController?.tabBar.items![0].title = "TABBAR_ITEM_TITLE_0".localize
        self.tabBarController?.tabBar.items![1].title = "TABBAR_ITEM_TITLE_1".localize
        self.tabBarController?.tabBar.items![2].title = "TABBAR_ITEM_TITLE_2".localize
        self.tabBarController?.tabBar.items![3].title = "TABBAR_ITEM_TITLE_3".localize
        self.tabBarController?.tabBar.items![4].title = "TABBAR_ITEM_TITLE_4".localize
        
        self.lblNameTitle.text = "USER_NAME".localize
        self.lblEmailTitle.text = "USER_EMAIL".localize
        self.lblAddressTitle.text = "USER_ADDRESS".localize
        self.lblCityTitle.text = "USER_CITY".localize
        self.lblStateTitle.text = "USER_STATE".localize
        self.lblCountryTitle.text = "USER_COUNTRY".localize
        self.lblZipTitle.text = "USER_ZIP".localize
        
        self.btnEditPic.setTitle("BTN_EDIT_PIC".localize, for: .normal)
        self.btnResetPassword.setTitle("BTN_RESET_PASSWORD".localize, for: .normal)
        self.btnSaveEdit.setTitle("BTN_EDIT_DETAILS".localize, for: .normal)
        
        self.tableView.reloadData()
    }
    
    //MARK: - UIPickerviewDelegate and Datasource methods -
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView == self.pickerCountry)
        {
            return self.arrCountry.count
        }
        else
        {
            return self.arrState.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView == self.pickerCountry)
        {
            let dictdata = self.arrCountry[row] as? NSDictionary
            let country = dictdata?.value(forKey: "name") as? String
            return country
        }
        else
        {
            let dictdata = self.arrState[row] as? NSDictionary
            let state = dictdata?.value(forKey: "name") as? String
            return state
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView == self.pickerCountry)
        {
            let dictdata = self.arrCountry[row] as? NSDictionary
            let country = dictdata?.value(forKey: "name") as? String
            self.txtCountry.text = country
            
            self.arrState = []
            let arr = dictdata?.value(forKey: "states") as? NSArray
            for dict in arr!
            {
                self.arrState.add(dict)
            }
            
            AppDelegate.shared().arrAllState = []
            AppDelegate.shared().arrAllState =  self.arrState
        }
        else
        {
            let dictdata = self.arrState[row] as? NSDictionary
            let code = dictdata?.value(forKey: "code") as? String
            let state = dictdata?.value(forKey: "name") as? String
            self.txtState.text = state
            StateCode = code
        }
        
    }
    
    //MARK:- TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell") as! CardListCell
        
        let cardString:String!
        
        let Brand = self.cards[indexPath.row]["brand"] as? String
        if Brand == "Visa"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "visa@2x.png")
            cardString = "VISA_CARD_WITH".localize
        }
        else if Brand == "MasterCard"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "mastercard@2x.png")
            cardString = "MASTER_CARD_WITH".localize
        }
        else if Brand == "American Express"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "amex@2x.png")
            cardString = "AMERICAN_CARD_WITH".localize
        }
        else if Brand == "Discover"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "discover@2x.png")
            cardString = "DISCOVER_CARD_WITH".localize
        }
        else if Brand == "JCB"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "jcb@2x.png")
            cardString = "JCB_CARD_WITH".localize
        }
        else if Brand == "Laser"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "laser@2x.png")
            cardString = "LASER_CARD_WITH".localize
        }
        else if Brand == "Diners Club"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "dinersclubintl@2x.png")
            cardString = "DINERS_CARD_WITH".localize
        }
        else{
            cell.imageView?.image = UIImage(named: "default@2x.png")
            cardString = "CARD_WITH".localize
        }
        
        let last4 = self.cards[indexPath.row]["last4"] as! String
        cell.lblCardNumber.text = cardString
        cell.lblLast4.text = last4
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.cards.count == 0
        {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 25))
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 25))
        headerView.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        headerView.addCornerRadius(5)
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "MY_PAYMENT_METHOD".localize
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        headerView.addSubview(label)
        return headerView
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
        imagePicker.navigationBar.tintColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    //MARK: - ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        self.imgUser.image = selectedImage
        dismiss(animated: true, completion: nil)
        self.Upload_Image_API()
        
        //CropViewController
        //        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        //
        //        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        //        //cropController.modalPresentationStyle = .fullScreen
        //        cropController.delegate = self
        //
        //        // Uncomment this if you wish to provide extra instructions via a title label
        //        //cropController.title = "Crop Image"
        //
        //        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        //
        //        // -- Uncomment the following lines of code to test out the aspect ratio features --
        //        //cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        //        //cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        //        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        //        //cropController.aspectRatioPickerButtonHidden = true
        //
        //        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //        //cropController.toolbarPosition = .top
        //
        //        //cropController.rotateButtonsHidden = true
        //        //cropController.rotateClockwiseButtonHidden = true
        //
        //        //cropController.doneButtonTitle = "Title"
        //        //cropController.cancelButtonTitle = "Title"
        //
        //        //cropController.toolbar.doneButtonHidden = true
        //        //cropController.toolbar.cancelButtonHidden = true
        //        //cropController.toolbar.clampButtonHidden = true
        //
        //        self.imgUser.image = image
        //
        //        if croppingStyle == .circular {
        //            if picker.sourceType == .camera {
        //                picker.dismiss(animated: true, completion: {
        //                    self.present(cropController, animated: true, completion: nil)
        //                })
        //            } else {
        //                picker.pushViewController(cropController, animated: true)
        //            }
        //        }
        //        else {
        //            picker.dismiss(animated: true, completion: {
        //                self.present(cropController, animated: true, completion: nil)
        //                //self.navigationController!.pushViewController(cropController, animated: true)
        //            })
        //        }
        //CropViewController
    }
    
    //MARK: - cropController delegate
    //    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    //        self.croppedRect = cropRect
    //        self.croppedAngle = angle
    //        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    //    }
    //
    //    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
    //        self.imgUser.image = image
    //        //layoutImageView()
    //
    //        self.navigationItem.leftBarButtonItem?.isEnabled = true
    //
    //        if cropViewController.croppingStyle != .circular {
    //            self.imgUser.isHidden = true
    //
    //            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
    //                                                   toView: self.imgUser,
    //                                                   toFrame: CGRect.zero,
    //                                                   setup: { self.layoutImageView() },
    //                                                   completion: {
    //                                                    self.imgUser.isHidden = false })
    //        }
    //        else {
    //            self.imgUser.isHidden = false
    //            cropViewController.dismiss(animated: true, completion: nil)
    //        }
    //    }
    //
    //    public func layoutImageView() {
    //        guard self.imgUser.image != nil else { return }
    //        self.imgUser.frame = self.imgUser.frame
    //        self.Upload_Image_API()
    //    }
    
    
    //MARK: - setupData Metod
    func setupData(){
        
        self.txtName.text = self.dictUserData["name"] as? String ?? ""
        self.txtEmail.text = self.dictUserData["email"] as? String ?? ""
        self.txtZip.text = self.dictUserData["zipcode"] as? String ?? ""
        self.txtAddress.text = self.dictUserData["address"] as? String ?? ""
        self.txtCity.text = self.dictUserData["city"] as? String ?? ""
        self.txtCountry.text = self.dictUserData["country"] as? String ?? ""
        
        let st = self.dictUserData["state"] as? String ?? ""
        if(st == "")
        {
            self.txtState.text = ""
        }
        else
        {
            self.arrState = AppDelegate.shared().arrAllState
            self.arrCountry = AppDelegate.shared().arrAllCountry
            
            for country in self.arrCountry
            {
                let dictdata = country as? NSDictionary
                let Name = dictdata?.value(forKey: "name") as? String
                
                if(self.txtCountry.text! == Name){
                    
                    let arr = dictdata?.value(forKey: "states") as? NSArray
                    for dict in arr!
                    {
                        self.arrState.add(dict)
                    }
                }
            }
            
            
            for state in self.arrState
            {
                let dictdata = state as? NSDictionary
                let code = dictdata?.value(forKey: "code") as? String
                if(code == st)
                {
                    StateCode = code
                    self.txtState.text = dictdata?.value(forKey: "name") as? String
                }
                else
                {
                    
                }
            }
        }
        
        let arrTextFields = [self.txtName,self.txtEmail,self.txtZip,self.txtAddress,self.txtCity,self.txtState,self.txtCountry]
        
        for txt in arrTextFields
        {
            txt?.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9490196078, blue: 0.937254902, alpha: 1)
            txt?.isUserInteractionEnabled = false
        }
        
        self.imgUser.downloaded(from: AppPrefs.shared.getUserProfile())
        self.view.updateConstraintsIfNeeded()
        
    }
    
    //MARK: - btnEditPicAction methods
    @IBAction func btnEditPicAction(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "FROM_CAMERA".localize, style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "FROM_GALLARY".localize, style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "CANCEL".localize, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - btnResetPassAction methods -
    @IBAction func btnResetPassAction(_ sender: Any) {
        
        let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "ResetPassword_VC") as! ResetPassword_VC
        navigationController?.pushViewController(nextNavVc, animated: true)
        
    }
    
    //MARK: - loadCards methods -
    func loadCards(){
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let custID = result?.value(forKeyPath: "customer_id") as? String
        
        if (custID != "" || custID != nil)
        {
            StripeUtil.shared.getCardsList(completion: { (result) in
                if let result = result {
                    
                    var ArrCards = [AnyObject]()
                    var ArrDoubleCards = [AnyObject]()
                    
                    if(result.count != 0)
                    {
                        for cards in result
                        {
                            var count = 0
                            let FingerPrint = cards["fingerprint"] as? String
                            for AllCard in result
                            {
                                let AllFingerPrint = AllCard["fingerprint"] as? String
                                if(FingerPrint == AllFingerPrint)
                                {
                                    count += 1
                                }
                                else
                                {
                                    
                                }
                            }
                            if(count > 1)
                            {
                                ArrDoubleCards.append(cards)
                            }
                            else
                            {
                                ArrCards.append(cards)
                            }
                        }
                        
                        print(result.count)
                        print(ArrCards.count)
                        print(ArrDoubleCards.count)
                        
                        if(ArrDoubleCards.count != 0)
                        {
                            ArrCards.append(ArrDoubleCards[0])
                        }
                        self.cards = ArrCards
                        print(self.cards.count)
                        print(self.cards)
                        
                    }
                    else
                    {
                        self.cards = []
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableViewHeight.constant = CGFloat(self.cards.count * 70 + 25)
                    self.tableView.reloadData()
                    self.view.updateConstraintsIfNeeded()
                }
            })
        }
        else{
            
        }
    }
    
    
    //MARK: - btnSaveEditAction methods -
    @IBAction func btnSaveEditAction(_ sender: Any) {
        
        let arrTextFields = [self.txtName,self.txtZip,self.txtAddress,self.txtCity,self.txtState,self.txtCountry]
        
        if(self.Flag == "Edit")
        {
            print(self.Flag)
            self.Flag = "Save"
            self.btnSaveEdit.setTitle("BTN_SAVE_DETAILS".localize, for: .normal)
            
            for txt in arrTextFields
            {
                txt?.backgroundColor = UIColor.white
                txt?.isUserInteractionEnabled = true
            }
        }
        else
        {
            print(self.Flag)
            self.Flag = "Edit"
            self.btnSaveEdit.setTitle("BTN_EDIT_DETAILS".localize, for: .normal)
            
            if(self.txtName.text == "")
            {
                displayAlert(APPNAME, andMessage: "ERROR_ENTER_NAME".localize)
            }
            else if(self.txtEmail.text == "")
            {
                displayAlert(APPNAME, andMessage: "ERROR_ENTER_EMAIL".localize)
            }
//            else if(self.txtZip.text == "")
//            {
//                displayAlert(APPNAME, andMessage: "ERROR_ENTER_ZIP".localize)
//            }
            else if(self.txtAddress.text == "")
            {
                displayAlert(APPNAME, andMessage: "ERROR_ENTER_ADDRESS".localize)
            }
            else if(self.txtCity.text == "")
            {
                displayAlert(APPNAME, andMessage: "ERROR_ENTER_CITY".localize)
            }
            else if(self.txtState.text == "")
            {
                displayAlert(APPNAME, andMessage: "ERROR_ENTER_STATE".localize)
            }
            else if(self.txtCountry.text == "")
            {
                displayAlert(APPNAME, andMessage: "ERROR_ENTER_COUNTRY".localize)
            }
            else
            {
                for txt in arrTextFields
                {
                    txt?.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9490196078, blue: 0.937254902, alpha: 1)
                    txt?.isUserInteractionEnabled = false
                }
                Update_User_API()
            }
        }
    }
    
    //MARK: - API Calls
    func GetUserDetails_API() {
        
        let url = API.BASE_URL + API.CURRENT_USER_PROFIE
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: "ERROR_RESPONSE".localize)
                    }
                    else
                    {
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
                        }
                        else
                        {
                            print(dict!)
                            let dict1 = (dict?.value(forKey: "data") as? NSMutableDictionary)!
                            self.dictUserData = (dict1.value(forKey: "user") as? NSMutableDictionary)!
                            
                            let strProfile:String = (self.dictUserData.value(forKeyPath: "image") as? String)!
                            AppPrefs.shared.saveUserProfile(url: strProfile)
                            
                            UserDefaults.standard.removeObject(forKey: "UserAllData")
                            UserDefaults.standard.synchronize()
                            
                            var dictUser:NSMutableDictionary = [:]
                            dictUser = dict1.value(forKeyPath: "user") as! NSMutableDictionary
                            UserDefaults.standard.set(dictUser, forKey: "UserAllData")
                            UserDefaults.standard.synchronize()
                            print(dictUser)
                            
                            self.setupData()
                            self.loadCards()
                        }
                    }
                }
            }
        }
        else
        {
            displayAlert(APPNAME, andMessage: "ERROR_NETWORK".localize)
        }
    }
    
    
    func Update_User_API() {
        
        let url = API.BASE_URL + API.UPDATE_USER_PROFIE
        let param : [String:String] = ["name" : self.txtName.text!,
                                       "email" : self.txtEmail.text!,
                                       "zipcode" : self.txtZip.text!,
                                       "address" : self.txtAddress.text!,
                                       "city" : self.txtCity.text!,
                                       "state" : StateCode,
                                       "country" : self.txtCountry.text!]
        
        let header = ["Authorization": "Bearer \(AppPrefs.shared.getUserId())"]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: "ERROR_RESPONSE".localize)
                    }
                    else
                    {
                        print(dict!)
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
                        }
                        else
                        {
                            print(dict!)
                            displayAlert(APPNAME, andMessage: MSG.SUCCESSFULLY_UPDATE)
                            self.GetUserDetails_API()
                            
                        }
                    }
                }
            }
        }
        else
        {
            displayAlert(APPNAME, andMessage: "ERROR_NETWORK".localize)
        }
    }
    
    
    func Upload_Image_API() {
        
        let url = API.BASE_URL + API.UPDATE_USER_IMAGE
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            let header = ["Content-Type":"application/x-www-form-urlencoded",
                          "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
            ]
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.upload(multipartFormData:
                {
                    (multipartFormData) in
                    
                    DispatchQueue.main.sync {
                        multipartFormData.append(self.imgUser.image!.jpegData(compressionQuality: 0.75)!, withName: "image", fileName: "Image.jpeg", mimeType: "image/jpg")
                    }
            }, to:url,headers:header)
            { (result) in
                switch result {
                case .success(let upload,_,_):
                    upload.uploadProgress(closure: {(progress) in
                        //Print progress
                        print(progress)
                    })
                    upload.responseJSON
                        { response in
                            if response.result.value != nil
                            {
                                displayAlert(APPNAME, andMessage: "Image Uploaded Successfully.")
                                self.GetUserDetails_API()
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
            displayAlert(APPNAME, andMessage: "ERROR_NETWORK".localize)
        }
    }
}
