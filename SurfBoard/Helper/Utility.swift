
import Foundation
import UIKit
import CoreLocation
import Toast
import SkyFloatingLabelTextField


let enableLog = true

func log(message: String, function: String = #function, file: String = #file, line: Int = #line)
{
    if(enableLog)
    {
        print("-----------START-------------")
        let url = NSURL(fileURLWithPath: file)
        print("Message = \"\(message)\" \n\n(File: \(url.lastPathComponent), Function: \(function), Line: \(line))")
        print("-----------END-------------\n")
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}


class Utility: NSObject
{
    class func isLocationServiceEnable() -> Bool
    {
        var locationOn:Bool = false
        
        if(CLLocationManager.locationServicesEnabled())
        {
            
            if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse)
            {
                locationOn = true
            }
            else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
            {
                locationOn = true
            }
        }
        else
        {
            locationOn = false
        }
        
        return locationOn
    }
    
//    class func askPermissionFormLocation()
//    {
//        let alertController = UIAlertController(title: "We Can't Get Your Location", message: "Turn on location services on your device.", preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Not Now", style: .cancel)
//        { (action) in
//            //AppDelegate.shared().logOut()
//        }
//        alertController.addAction(cancelAction)
//
//        let openAction = UIAlertAction(title: "Settings", style: .default)
//        { (action) in
//            if let url = NSURL(string: UIApplication.openSettingsURLString)
//            {
//                UIApplication.shared.openURL(url as URL)
//            }
//
//
//        }
//        alertController.addAction(openAction)
//        let rootWindow = AppDelegate.shared().window?.rootViewController
//        rootWindow?.present(alertController, animated: true, completion: nil)
//    }
    
}


func getMajorSystemVersion() -> Int
{
    let systemVersionStr = UIDevice.current.systemVersion   //Returns 7.1.1
    let mainSystemVersion = Int((systemVersionStr.split{$0 == "."}.map(String.init))[0])
    
    return mainSystemVersion!
}

struct IOS_VERSION
{
    static var IS_IOS7 = getMajorSystemVersion() >= 7 && getMajorSystemVersion() < 8
    static var IS_IOS8 = getMajorSystemVersion() >= 8 && getMajorSystemVersion() < 9
    static var IS_IOS9 = getMajorSystemVersion() >= 9
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    //static let IS_TV = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.TV
    
    static let IS_IPHONE_4_OR_LESS =  IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 812.0  //xs
    static let IS_IPHONE_XR = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 896.0  // xsMax
}

func getAppUniqueId() -> String
{
    let uniqueId: UUID = UIDevice.current.identifierForVendor! as UUID
    
    return uniqueId.uuidString
}

public func jsonStringFromDictionaryOrArrayObject(_ obj: AnyObject) -> String
{
    do
    {
        let jsonData = try JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        
        return jsonString as! String
    }
    catch let error as NSError
    {
        print("Error!! = \(error)")
    }
    
    return ""
}

public func jsonObjectFromJsonString(_ jsonString: String) -> AnyObject
{
    do
    {
        let jsonData = jsonString.data(using: String.Encoding.utf8)!
        let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return jsonObj as AnyObject
    }
    catch let error as NSError
    {
        print("Error!! = \(error)")
    }
    
    return "" as AnyObject
}

//http://stackoverflow.com/questions/27044095/swift-how-to-remove-a-null-value-from-dictionary
/*extension Dictionary where Key: String, Value: AnyObject
 {
 
 }*/

public func getCleanedObj(_ dataObj: [String: AnyObject]) -> [String: AnyObject]
{
    var jsonCleanDictionary = [String: AnyObject]()
    
    for (key, value) in dataObj
    {
        if !(value is NSNull)
        {
            if let valueNumber = value as? NSNumber
            {
                jsonCleanDictionary[key] = valueNumber.stringValue as AnyObject?
            }
            else
            {
                jsonCleanDictionary[key] = value
            }
        }
    }
    
    return jsonCleanDictionary
}

public func setDataToPreference(_ data: AnyObject, forKey key: String)
{
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
}

public func getDataToPreference(_ data: AnyObject, forKey key: String) -> AnyObject
{
    return UserDefaults.standard.object(forKey: key)! as AnyObject
}

public func isPreferenceWithKeyExist(_ key: String) -> Bool
{
    return UserDefaults.standard.object(forKey: key) != nil
}


var TimeStampInterval: TimeInterval {
    return Date().timeIntervalSince1970
}

var TimeStampString: String {
    return "\(Date().timeIntervalSince1970)"
}

func printFonts()
{
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames
    {
        print("------------------------------")
        print("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName)
        print("Font Names = [\(names)]")
    }
}


func setViewBorderBottom(_ view: UIView, withWidth width: CGFloat, atDistanceFromBottom bottonY: CGFloat, andColor color: UIColor, clipToBounds: Bool) {
    view.layoutIfNeeded()
    let bottomBorder: CALayer = CALayer.init()
    /*
     UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height-bottonY, view.frame.size.width, width)];
     bottomBorder.backgroundColor = color;
     [view addSubview:bottomBorder];
     */
    bottomBorder.frame = CGRect(x: 0.0, y: view.frame.size.height-bottonY, width: view.frame.size.width, height: width)
    bottomBorder.backgroundColor = color.cgColor
    view.layer.addSublayer(bottomBorder)
    view.clipsToBounds = clipToBounds
}

extension SkyFloatingLabelTextField {
    
    func addTextFieldFloatingProperty() {
        
        //self.disabledColor = .lightGray
        self.placeholderColor = .lightGray//Color.APP_THEME_COLOR_SPACE_GRAY
        self.textColor = .black
        self.lineColor = Color.APP_THEME_COLOR
        self.selectedLineColor = Color.APP_THEME_COLOR
        self.tintColor = .black
        self.titleColor = Color.APP_THEME_COLOR
        self.selectedTitleColor = Color.APP_THEME_COLOR
    }
}


extension CAShapeLayer {
    fileprivate func drawCircleAtLocation(_ location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0;

public enum QueueType {
    case Main
    case Background
    case LowPriority
    case HighPriority
    
    var queue: DispatchQueue {
        switch self {
        case .Main:
            return DispatchQueue.main
        case .Background:
            return DispatchQueue(label: "com.app.queue",
                                 qos: .background,
                                 target: nil)
        case .LowPriority:
            return DispatchQueue.global(qos: .userInitiated)
        case .HighPriority:
            return DispatchQueue.global(qos: .userInitiated)
        }
    }
}

func performOn(_ queueType: QueueType, closure: @escaping () -> Void) {
    queueType.queue.async(execute: closure)
}


//MARK: - Get AppStoryboard Extension
enum AppStoryboard : String {
    
    case Main
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}




//MARK: - All UIApplication extensions
extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
    
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    } 
}

//MARK: - All String extensions
extension String
{
    func insert(string:String,ind:Int) -> String
    {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
}

public extension String
{
    func isNumber() -> Bool
    {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
}


extension String
{
    //    var isValidEmail: Bool {
    //
    //        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    //
    //        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    //        return emailTest.evaluate(with: self)
    //    }
    
    func getDateWithFormate(_ formate: String, timezone: String) -> Date
    {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(abbreviation: timezone)
        
        return formatter.date(from: self)!
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

extension String
{
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.sizeToFit()
        
        return label.frame.height
    }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.unicode, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}

extension String
{
    func removeDash() -> String
    {
        return self.replacingOccurrences(of: "-", with: "")
    }
    
    func getAlphabeticString() -> String {
        
        let arrNumerc = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        return self.filter({ !arrNumerc.contains(String($0)) })
    }
    
    func split(by: Character) -> [String]
    {
        return self.split(separator: by).map{ return String($0) }
    }
    
    
    
    /// EZSE: Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
    
    /// EZSE: Trims white space and new line characters
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// EZSE: Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String
{
    var isValidEmail: Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool
    {
        let phoneRegEx = "^\\d{3}\\d{3}\\d{4}$"
        //let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool
    {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&.*-~`\"'#()+,:;<>=^_{}\\]\\[])[A-Za-z\\d$@$!%*?&.*-~`\"'#()+,:;<>=^_{}\\]\\[]{6,}"//"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func getDateWithFormate(formate: String, timezone: String) -> Date
    {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = NSTimeZone(abbreviation: timezone) as TimeZone?
        
        return formatter.date(from: self)! as Date
    }
}


extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}



//MARK: - All Int extensions
extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
    
    /// EZSE: Converts integer value to Double.
    public var toDouble: Double { return Double(self) }
    
    /// EZSE: Converts integer value to Float.
    public var toFloat: Float { return Float(self) }
    
    /// EZSE: Converts integer value to CGFloat.
    public var toCGFloat: CGFloat { return CGFloat(self) }
    
    /// EZSE: Converts integer value to String.
    public var toString: String { return String(self) }
    
    /// EZSE: Converts integer value to UInt.
    public var toUInt: UInt { return UInt(self) }
    
    /// EZSE: Converts integer value to Int32.
    public var toInt32: Int32 { return Int32(self) }
}

public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

//MARK: - All Array extensions
extension Array where Element:Equatable
{
    func removeDuplicates() -> [Element]
    {
        var result = [Element]()
        
        for value in self
        {
            if result.contains(value) == false
            {
                result.append(value)
            }
        }
        
        return result
    }
}
//MARK: - All Dictionary extensions

extension Dictionary
{
    //https://developer.apple.com/swift/bprint/?id=12
    func valuesForKeys(_ keys: [Key]) -> [Value?]
    {
        return keys.map { self[$0] }
    }
    
    func valuesForKeys(_ keys: [Key], notFoundMarker: Value) -> [Value]
    {
        return self.valuesForKeys(keys).map { $0 ?? notFoundMarker }
    }
}


//MARK: - All UIView extensions

extension UIView {
    
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func applyBorder(_ width: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
    }
    
    func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
    
    func displayToast(message: String) {
        
        let style = CSToastStyle(defaultStyle: ())
        
        style?.backgroundColor = UIColor.black
        style?.titleColor = UIColor.white
        style?.messageColor = UIColor.white
        makeToast(message, duration: 3.0, position: CSToastPositionTop, style: style)
        
    }
    
    func blink() {
        
        self.alpha = 0.2
        UIView.animate(withDuration: 1, delay: 2.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
    
}

//MARK: - All UITextField extensions

//extension SkyFloatingLabelTextField {
//    
//    func addTextFieldFloatingProperty() {
//        
//        self.disabledColor = .lightGray
//        self.placeholderColor = .lightGray//Color.APP_THEME_COLOR_SPACE_GRAY
//        self.textColor = .black
//        self.lineColor = Color.APP_THEME_COLOR_SPACE_GRAY
//        self.selectedLineColor = Color.APP_THEME_COLOR_SPACE_GRAY
//        self.tintColor = .black
//        self.titleColor = Color.APP_THEME_COLOR_SPACE_GRAY
//        self.selectedTitleColor = Color.APP_THEME_COLOR_SPACE_GRAY
//    }
//}

extension UITextField
{
    func addPadding(_ padding: CGFloat)
    {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
        
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
//
//            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil, attributes: [NSAttributedStringKey : newValue]?)
            
        }
    }
    
    
    func addImageToRightSide(image: UIImage, width: CGFloat)
    {
       
        let rightView = UIImageView()
        rightView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        rightView.contentMode = .center
        rightView.image = image
    
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    func addImageToLeftSide(image: UIImage, width: CGFloat)
    {
        let rightView = UIImageView()
        rightView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        rightView.contentMode = .center
        rightView.image = image
        
        self.leftView = rightView
        self.leftViewMode = .always
    }
    
    func addImageToLeftSide(image: UIImage, width: CGFloat, height: CGFloat)
    {
        //        let rightView = UIImageView()
        //        rightView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        //        rightView.contentMode = .scaleAspectFit
        //        rightView.image = image
        //
        //        self.leftView = rightView
        //        self.leftViewMode = .always
        
        
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: height, height: width)//CGRect(x: 0, y: 0, width: width, height: height)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let rightView = UIView(frame: CGRect(x: 0, y: self.frame.height/2/4, width: width, height: self.frame.height))
        
        rightView.addSubview(imageView)
        imageView.center = rightView.center
        
        self.leftView = rightView
        self.leftViewMode = .always
    }
    
    func addDropDownArrow()
    {
        let arrowImageview = UIImageView()
        arrowImageview.image = #imageLiteral(resourceName: "ic_arrow_down").tintWithColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
        arrowImageview.contentMode = .center
        arrowImageview.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        self.rightView = arrowImageview
        self.rightViewMode = .always
    }
    
   
    func CornerRadius(radius: CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
  
    func addBorder(width: CGFloat)
    {
        self.layer.borderWidth = width
    }
   
    func addBorderColor(color: UIColor)
    {
        self.layer.borderColor = color.cgColor
    }
}

extension String {
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
}

//MARK: - All UIImageView Extension
extension UIImageView
{
    func setImage(_ image: UIImage, withColor color: UIColor)
    {
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        
        downloaded(from: url, contentMode: mode)
    }
}

//MARK: - All UIImage Extension
extension UIImage
{
    
    func tintWithColor(_ color:UIColor)->UIImage
    {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale);
        //UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        
        // flip the image
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context?.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.fill(rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    
}

extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.40
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
}

extension UIImageView {
    
    func makeRounded() {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

public extension UIImage {
    
    func roundedImage() -> UIImage {
        let imageView: UIImageView = UIImageView(image: self)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = imageView.frame.width / 2
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
}

//MARK: - All UIBarButtonItem Extension
extension UIButton {
    func setUnderlineButton()
    {
        let text = self.titleLabel?.text
        let titleString = NSMutableAttributedString(string: text!)
        //titleString.addAttributes([kCTUnderlineStyleAttributeName as NSAttributedString.Key: NSUnderlineStyle.single.rawValue], range: NSMakeRange(0, (text?.count)!))
        
        
        titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, (text?.count)!))
        
        //titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.characters.count))
        self.setAttributedTitle(titleString, for: .normal)
        
    }
    
    func underline() {
        guard let title = self.titleLabel else { return }
        guard let tittleText = title.text else { return }
        let attributedString = NSMutableAttributedString(string: (tittleText))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (tittleText.count)))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func roundRect_Button_With_BlackShadow(radius: CGFloat,backgroundColor:UIColor) {
        self.backgroundColor = backgroundColor //UIColor(red:17.0/255.0, green:53.0/255.0, blue:115.0/255.0, alpha:1.0)
        //UIColor(red:0.11, green:0.24, blue:0.41, alpha:1.0)// UIColor(red:0.38, green:0.51, blue:0.74, alpha:1.0)
        //self.titleLabel?.font = UIFont(name: "MuseoSans-500", size: 15)
        self.titleLabel?.textColor = UIColor.white
        //self.titleLabel?.text = self.titleLabel?.text?.uppercased()
        self.setTitleColor(UIColor.white, for: UIControl.State())
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3.0
    }
}

//MARK: - All UIBarButtonItem Extension
extension UIBarButtonItem
{
    
    fileprivate var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func updateBadge(_ number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
    
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int)
{
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}


func displayToastOnBottom(message: String)
{
    let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    //alertWindow.windowLevel = UIWindow.Level.alert + 1
    alertWindow.windowLevel = alertWindow.windowLevel + 1
    alertWindow.makeKeyAndVisible()
    let windowView = AppDelegate.shared().window?.rootViewController?.view
    
    let style = CSToastStyle(defaultStyle: ())

    style?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
    //style?.titleColor = UIColor.black
    style?.messageColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)//Color.APP_THEME_COLOR_GREEN
    windowView?.makeToast(message, duration: 2.0, position: CSToastPositionBottom, style: style)
}



func displayAlert(_ title: String, andMessage message: String)
{
    let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    //alertWindow.windowLevel = UIWindow.Level.alert + 1
    alertWindow.windowLevel = alertWindow.windowLevel + 1
    alertWindow.makeKeyAndVisible()

    let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action) -> Void in

        alertWindow.isHidden = true

    }))

    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
}

func displayAlertWithOption(_ title: String, andMessage message: String, yes yesBlock:@escaping () -> Void , no noBlock:@escaping (() -> Void))
{
    let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    //alertWindow.windowLevel = UIWindow.Level.alert + 1
    alertWindow.windowLevel = alertWindow.windowLevel + 1
    alertWindow.makeKeyAndVisible()
    
    let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
        
        alertWindow.isHidden = true
        noBlock()
        
    }))
    
    alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
        
        alertWindow.isHidden = true
        yesBlock()
        
    }))
    
    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
}
func displayAlertWithOneOptionAndAction(_ title: String, andMessage message: String , no noBlock:@escaping (() -> Void))
{
    let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    //alertWindow.windowLevel = UIWindow.Level.alert + 1
    alertWindow.windowLevel = alertWindow.windowLevel + 1
    alertWindow.makeKeyAndVisible()
    
    let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        
        alertWindow.isHidden = true
        noBlock()
        
    }))
    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
}

func setStatusBarBackgroundColor(_ color: UIColor)
{
    guard  let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else {
        return
    }
    
    statusBar.backgroundColor = color
}

func getTimeZoneIdentifier() -> String
{
    return TimeZone.current.identifier
}



func delay(time: Double, closure:
    @escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        closure()
    }
    
}

func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage
{
    
    if image.size.width < targetSize.width || image.size.height < targetSize.height
    {
        return image
    }
    
    let size = image.size
    let widthRatio = targetSize.width / image.size.width
    let heightRatio = targetSize.height / image.size.height
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio)
    {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    }
    else
    {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

//MARK: - All Date Extension
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    

    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
}

extension Date
{
    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool
    {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame
        {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(_ daysToAdd: Int) -> Date
    {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(_ hoursToAdd: Int) -> Date
    {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func addMinutes(minutes: Int) -> Date
    {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func getDateStringWithFormate(_ formate: String, timezone: String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(abbreviation: timezone)
        
        return formatter.string(from: self)
    }
    
    func getFormatedDate() -> String {
    
        
        let tempDate = self.getDateStringWithFormate("yyyy-MM-dd HH:mm:ss", timezone: TimeZone.current.abbreviation()!)
        
        let fromDate = tempDate.getDateWithFormate("yyyy-MM-dd HH:mm:ss", timezone: TimeZone.current.abbreviation()!)
        

        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate, to: Date())
        //print(components)
        var returnString:String = ""
        //print(components.second)
        
        if components.year! >= 1 {
            
            returnString = fromDate.getDateStringWithFormate("dd/MM/yyyy", timezone: TimeZone.current.abbreviation()!)
        }
        else if components.day! >= 7 {
            
            returnString = fromDate.getDateStringWithFormate("MMMM dd", timezone: TimeZone.current.abbreviation()!)
        }
        else if components.day! >= 1 {
            
            returnString = String(describing: components.day!) + " days ago"
        }
        else if components.hour! >= 1 {
            
            returnString = String(describing: components.hour!) + " hour ago"
        }
        else if components.minute! >= 1 {
            
            returnString = String(describing: components.minute!) + " min ago"
        }
        else if components.second! <= 60 {
            returnString = "Just Now"
            
        }
    
        return returnString
    }
}

extension Date
{
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}



//MARK: -

func validateEmail(_ candidate: String) -> Bool
{
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
}

func formatNumberStringToShortForm(_ numberStr: String) -> String
{
    var numberStr = numberStr
    numberStr = numberStr.replacingOccurrences(of: ",", with: "")
    
    
    if let numberDouble = Double(numberStr)// (numberStr as NSString).doubleValue
    {
        
        var shortNumber = numberDouble
        var suffixStr = ""
        
        if(numberDouble >= 1000000000.0)
        {
            suffixStr = "Arab"
            shortNumber = numberDouble / 1000000000.0
        }
        else if(numberDouble >= 10000000.0)
        {
            suffixStr = "Cr"
            shortNumber = numberDouble / 10000000.0
        }
        else if(numberDouble >= 100000.0)
        {
            suffixStr = "Lac"
            shortNumber = numberDouble / 100000.0
        }
        else if(numberDouble >= 1000.0)
        {
            suffixStr = "K"
            shortNumber = numberDouble / 1000.0
        }
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let numberAsString = numberFormatter.string(from: NSNumber(value: shortNumber as Double))
        let finalString = String(format: "%@ %@", numberAsString!, suffixStr)
        
        return finalString
    }
    
    return numberStr
}

func isStringContainsOnlyNumbers(_ string: String) -> Bool
{
    let charactersSet = NSMutableCharacterSet.decimalDigit()
    let badCharacters = charactersSet.inverted
    
    if string.rangeOfCharacter(from: badCharacters) == nil
    {
        print("string was a number")
        
        return true
    }
    else
    {
        print("string contained non-digit characters.")
        
        return false
    }
}

func isStringContainsOnlyNumbersWithFloatValue(_ string: String) -> Bool
{
    let charactersSet = NSMutableCharacterSet.decimalDigit()
    charactersSet.addCharacters(in: ".")
    let badCharacters = charactersSet.inverted
    
    if string.rangeOfCharacter(from: badCharacters) == nil
    {
        print("string was a number")
        
        return true
    }
    else
    {
        print("string contained non-digit characters.")
        
        return false
    }
}

func parseStringBetween(_ stringToParse: String, firstString: String, lastString: String) -> String
{
    let scanner = Scanner(string:stringToParse)
    var scanned: NSString?
    
    if scanner.scanUpTo(firstString, into:nil)
    {
        scanner.scanString(firstString, into:nil)
        if scanner.scanUpTo(lastString, into:&scanned)
        {
            let result: String = scanned as! String
            //print("parse result: \(result)") // result: google
            
            return result
        }
    }
    
    return ""
}

func getParsedImageUrl(_ imageUrl: String) -> String
{
    
    let nativeURL = URL(string: imageUrl)
    
    let pathComponents = nativeURL?.pathComponents
    
    var parsedString = parseStringBetween(imageUrl, firstString: "__", lastString: "__")
    
    parsedString = parsedString.replacingOccurrences(of: "w-", with: "")
    
    if(parsedString.isEmpty)
    {
        return ""
    }
    
    let widthArray = parsedString.components(separatedBy: "-")
    
    //var lowestDiff: Int = Int.max
    
    let device_width = Int(UIScreen.main.bounds.size.width * UIScreen.main.scale)
    
    var finalWidthStr: String = widthArray.last!
    
    for widthStr: String in widthArray
    {
        let currentWidth = Int(widthStr)
        
        /*let diff = abs(device_width - currentWidth!)
         
         if(diff < lowestDiff)
         {
         lowestDiff = diff;
         
         finalWidthStr = widthStr
         }*/
        
        if(currentWidth >= device_width)
        {
            finalWidthStr = widthStr
            break
        }
    }
    
    
    var finalUrl = imageUrl
    
    for component in pathComponents!
    {
        if(component.range(of: parsedString) != nil)
        {
            finalUrl = imageUrl.replacingOccurrences(of: component, with: "w\(finalWidthStr)")
            break
        }
    }
    
    return finalUrl
}

func getParsedImageUrl(_ imageUrl: String, width: Int) -> String
{
    
    let nativeURL = URL(string: imageUrl)
    
    let pathComponents = nativeURL?.pathComponents
    
    var parsedString = parseStringBetween(imageUrl, firstString: "__", lastString: "__")
    
    parsedString = parsedString.replacingOccurrences(of: "w-", with: "")
    
    if(parsedString.isEmpty)
    {
        return ""
    }
    
    let widthArray = parsedString.components(separatedBy: "-")
    
    //var lowestDiff: Int = Int.max
    
    let device_width = Int(CGFloat(width) * UIScreen.main.scale)
    
    var finalWidthStr: String = widthArray.last!
    
    for widthStr: String in widthArray
    {
        let currentWidth = Int(widthStr)
        
        /*let diff = abs(device_width - currentWidth!)
         
         if(diff < lowestDiff)
         {
         lowestDiff = diff;
         
         finalWidthStr = widthStr
         }*/
        
        if(currentWidth >= device_width)
        {
            finalWidthStr = widthStr
            break
        }
    }
    
    
    var finalUrl = imageUrl
    
    for component in pathComponents!
    {
        if(component.range(of: parsedString) != nil)
        {
            finalUrl = imageUrl.replacingOccurrences(of: component, with: "w\(finalWidthStr)")
            break
        }
    }
    
    return finalUrl
}


func getParsedImageUrl(_ imageUrl: String, maxWidth: Int) -> String
{
    
    let nativeURL = URL(string: imageUrl)
    
    let pathComponents = nativeURL?.pathComponents
    
    var parsedString = parseStringBetween(imageUrl, firstString: "__", lastString: "__")
    
    parsedString = parsedString.replacingOccurrences(of: "w-", with: "")
    
    if(parsedString.isEmpty)
    {
        return ""
    }
    
    let widthArray = parsedString.components(separatedBy: "-")
    
    var lowestDiff: Int = Int.max
    
    let device_width = maxWidth
    
    var finalWidthStr: String = widthArray.last!
    
    for widthStr: String in widthArray
    {
        let currentWidth = Int(widthStr)
        
        if(currentWidth <= maxWidth)
        {
            let diff = abs(device_width - currentWidth!)
            
            if(diff < lowestDiff)
            {
                lowestDiff = diff;
                
                finalWidthStr = widthStr
            }
        }
    }
    
    
    var finalUrl = imageUrl
    
    for component in pathComponents!
    {
        if(component.range(of: parsedString) != nil)
        {
            finalUrl = imageUrl.replacingOccurrences(of: component, with: "w\(finalWidthStr)")
            break
        }
    }
    
    return finalUrl
}


func getEncodedUrlComponentString(_ urlStr: String) -> String! {
    return urlStr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
}

func getEncodedUrlQueryString(_ urlStr: String) -> String! {
    return urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
}

func getConstraintForIdentifier(_ identifier: String, fromView: AnyObject) -> NSLayoutConstraint? {
    for subview in fromView.subviews as [UIView] {
        for constraint in subview.constraints as [NSLayoutConstraint] {
            if constraint.identifier == identifier {
                return constraint
            }
        }
    }
    
    return nil
}

func getYouTubeVideoIdFromUrl(_ urlStr: String) -> String {
    let regexString: String = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
    
    let regExp = try! NSRegularExpression(pattern: regexString, options: [.caseInsensitive])
    
    let array: [AnyObject] = regExp.matches(in: urlStr, options: [], range: NSMakeRange(0, urlStr.count))
    if array.count > 0
    {
        let result: NSTextCheckingResult = array.first as! NSTextCheckingResult
        return (urlStr as NSString).substring(with: result.range)
    }
    
    return ""
}

func getYouTubeThumbnailUrlFromVideoUrl(_ urlStr: String) -> String {
    return "http://img.youtube.com/vi/\(getYouTubeVideoIdFromUrl(urlStr))/hqdefault.jpg"
}

func getExtentionFromUrl(_ urlStr: String) -> String {
    let URL = Foundation.URL(string: urlStr)
    
    if let extention = URL?.pathExtension {
        return extention
    }
    
    return ""
}

func appVersion() -> String {
    return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
}
func appBuild() -> String{
    return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
}

func platform() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    
    let machine = systemInfo.machine
    let mirror = Mirror(reflecting: machine)
    var identifier = "unknown"
    
    for child in mirror.children {
        if let value = child.value as? Int8 , value != 0
        {
            identifier.append(String(UnicodeScalar(UInt8(value))))
        }
    }
    
    return identifier
}

func deviceNameString() -> String
{
    
    let pf = platform();
    if (pf == "iPhone1,1")   { return  "iPhone 1G"}
    if ( pf   == "iPhone1,2"  )    { return  "iPhone 3G"}
    if (  pf   == "iPhone2,1"  )    { return  "iPhone 3GS"}
    if (  pf   == "iPhone3,1"  )    { return  "iPhone 4"}
    if (  pf   == "iPhone3,3"  )    { return  "Verizon iPhone 4"}
    if (  pf   == "iPhone4,1"  )    { return  "iPhone 4S"}
    if (  pf   == "iPhone5,1"  )    { return  "iPhone 5 (GSM)"}
    if (  pf   == "iPhone5,2"  )    { return  "iPhone 5 (GSM+CDMA)"}
    if (  pf   == "iPhone5,3"  )    { return  "iPhone 5c (GSM)"}
    if (  pf   == "iPhone5,4"  )    { return  "iPhone 5c (GSM+CDMA)"}
    if (  pf   == "iPhone6,1"  )    { return  "iPhone 5s (GSM)"}
    if (  pf   == "iPhone6,2"  )    { return  "iPhone 5s (GSM+CDMA)"}
    if (  pf   == "iPhone7,1"  )    { return  "iPhone 6 Plus"}
    if (  pf   == "iPhone7,2"  )    { return  "iPhone 6"}
    if (  pf   == "iPhone8,1"  )    { return  "iPhone 6s Plus"}
    if (  pf   == "iPhone8,2"  )    { return  "iPhone 6s"}
    
    if (  pf   == "iPod1,1"  )      { return  "iPod Touch 1G"}
    if (  pf   == "iPod2,1"  )      { return  "iPod Touch 2G"}
    if (  pf   == "iPod3,1"  )      { return  "iPod Touch 3G"}
    if (  pf   == "iPod4,1"  )      { return  "iPod Touch 4G"}
    if (  pf   == "iPod5,1"  )      { return  "iPod Touch 5G"}
    if (  pf   == "iPad1,1"  )      { return  "iPad"}
    
    if (  pf   == "iPad2,1"  )      { return  "iPad 2 (WiFi)"}
    if (  pf   == "iPad2,2"  )      { return  "iPad 2 (GSM)"}
    if (  pf   == "iPad2,3"  )      { return  "iPad 2 (CDMA)"}
    if (  pf   == "iPad2,4"  )      { return  "iPad 2 (WiFi)"}
    if (  pf   == "iPad2,5"  )      { return  "iPad Mini (WiFi)"}
    if (  pf   == "iPad2,6"  )      { return  "iPad Mini (GSM)"}
    if (  pf   == "iPad2,7"  )      { return  "iPad Mini (GSM+CDMA)"}
    if (  pf   == "iPad3,1"  )      { return  "iPad 3 (WiFi)"}
    if (  pf   == "iPad3,2"  )      { return  "iPad 3 (GSM+CDMA)"}
    if (  pf   == "iPad3,3"  )      { return  "iPad 3 (GSM)"}
    if (  pf   == "iPad3,4"  )      { return  "iPad 4 (WiFi)"}
    if (  pf   == "iPad3,5"  )      { return  "iPad 4 (GSM)"}
    if (  pf   == "iPad3,6"  )      { return  "iPad 4 (GSM+CDMA)"}
    if (  pf   == "iPad4,1"  )      { return  "iPad Air (WiFi)"}
    if (  pf   == "iPad4,2"  )      { return  "iPad Air (Cellular)"}
    if (  pf   == "iPad4,4"  )      { return  "iPad mini 2G (WiFi)"}
    if (  pf   == "iPad4,5"  )      { return  "iPad mini 2G (Cellular)"}
    
    if (  pf   == "iPad4,7"  )      { return  "iPad mini 3 (WiFi)"}
    if (  pf   == "iPad4,8"  )      { return  "iPad mini 3 (Cellular)"}
    if (  pf   == "iPad4,9"  )      { return  "iPad mini 3 (China Model)"}
    
    if (  pf   == "iPad5,3"  )      { return  "iPad Air 2 (WiFi)"}
    if (  pf   == "iPad5,4"  )      { return  "iPad Air 2 (Cellular)"}
    
    if (  pf   == "AppleTV2,1"  )      { return  "AppleTV 2"}
    if (  pf   == "AppleTV3,1"  )      { return  "AppleTV 3"}
    if (  pf   == "AppleTV3,2"  )      { return  "AppleTV 3"}
    
    if (  pf   == "i386"  )         { return  "Simulator"}
    if (  pf   == "x86_64"  )       { return  "Simulator"}
    return  pf
}


func getNSUserDefaultObjectForKey(_ key: String) -> AnyObject?
{
    return UserDefaults.standard.object(forKey: key) as AnyObject?
}

/*extension String {
 
 var lastPathComponent: String {
 
 get {
 return (self as NSString).lastPathComponent
 }
 }
 var pathExtension: String {
 
 get {
 
 return (self as NSString).pathExtension
 }
 }
 var stringByDeletingLastPathComponent: String {
 
 get {
 
 return (self as NSString).stringByDeletingLastPathComponent
 }
 }
 var stringByDeletingPathExtension: String {
 
 get {
 
 return (self as NSString).stringByDeletingPathExtension
 }
 }
 var pathComponents: [String] {
 
 get {
 
 return (self as NSString).pathComponents
 }
 }
 
 func stringByAppendingPathComponent(path: String) -> String {
 
 let nsSt = self as NSString
 
 return nsSt.stringByAppendingPathComponent(path)
 }
 
 func stringByAppendingPathExtension(ext: String) -> String? {
 
 let nsSt = self as NSString
 
 return nsSt.stringByAppendingPathExtension(ext)
 }
 }*/

//MARK: -
//MARK: Get library directory path

func getLibraryDirectoryPath() -> String
{
    var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [AnyObject]
    return paths[0] as! String
}

//MARK: Get document directory path

func getDocumentDirectoryPath() -> String
{
    var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [AnyObject]
    return paths[0] as! String
}

//MARK: Get file path from library directory

func getFilePathFromLibraryDirectory(_ fileName: String) -> String
{
    let filePath = getLibraryDirectoryPath().appendingFormat("/%@", fileName)
    
    return filePath
}

//MARK: Get file path from document directory

func getFilePathFromDocumentDirectory(_ fileName: String) -> String
{
    let filePath = getDocumentDirectoryPath().appendingFormat("/%@", fileName)
    
    return filePath
}

//MARK: Check for file exist or not

func isFileOrDirectoryExistAtPath(_ path: String) -> Bool
{
    let fileManager: FileManager = FileManager.default
    if fileManager.fileExists(atPath: path)
    {
        return true
    }
    return false
}

func createDirectoryFilePath(_ filePath: String) -> Bool
{
    do
    {
        try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        return true
    }
    catch let error as NSError
    {
        print("Unable to create directory \(error)")
        return false
    }
}

//MARK: Create directory name at given path

func createDirectory(_ directoryName: String, atFilePath filePath: String) -> Bool
{
    let filePathAndDirectory: String = filePath.appendingFormat("/%@", directoryName)
    
    if isFileOrDirectoryExistAtPath(filePathAndDirectory)
    {
        return true
    }
    
    return createDirectoryFilePath(filePathAndDirectory)
}

//MARK: Create directory at library path

func createDirectoryAtLibraryDirectory(_ directoryName: String) -> Bool
{
    let filePathAndDirectory: String = getLibraryDirectoryPath().appendingFormat("/%@", directoryName)
    if isFileOrDirectoryExistAtPath(filePathAndDirectory)
    {
        return true
    }
    
    return createDirectoryFilePath(filePathAndDirectory)
}

//MARK: Create directory at document path

func createDirectoryAtDocumentDirectory(_ directoryName: String) -> Bool
{
    let filePathAndDirectory: String = getLibraryDirectoryPath().appendingFormat("/%@", directoryName)
    if isFileOrDirectoryExistAtPath(filePathAndDirectory)
    {
        return true
    }
    
    return createDirectoryFilePath(filePathAndDirectory)
}

//MARK: Get count of contents within directory path

func getCountOfContentsWithinDirectory(_ directoryPath: String) -> Int
{
    do
    {
        let contentArray = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
        return contentArray.count
    }
    catch let error as NSError
    {
        print("Unable to get directory content \(error)")
        return 0
    }
}

//MARK: Delete path at given path

func deleteFileFromPath(_ filePath: String) -> Bool
{
    print("Path: %@", filePath)
    let fileManager: FileManager = FileManager.default
    
    do
    {
        try fileManager.removeItem(atPath: filePath)
        return true
    }
    catch let error as NSError
    {
        print("Delete directory error: \(error)")
        return false
    }
    
}

//MARK: Delete all files at given directory path

func deleteAllFilesAtDirectory(_ directoryPath: String) -> Bool
{
    print("Path: %@", directoryPath)
    
    let fileManager: FileManager = FileManager.default
    
    do
    {
        try fileManager.removeItem(atPath: directoryPath)
        let _ = createDirectoryFilePath(directoryPath)
        return true
    }
    catch let error as NSError
    {
        print("Delete directory error: \(error)")
        return false
    }
}

//MARK: Delete file with given search name at given directory path

func deleteFileNameStartWithText(_ searchText: String, atDirectory directory: String)
{
    let fileManager: FileManager = FileManager.default
    
    do
    {
        let dirContents: [String] = try fileManager.contentsOfDirectory(atPath: directory)
        
        for fileString: String in dirContents
        {
            if fileString.lowercased().hasPrefix(searchText.lowercased())
            {
                print("delete file = %@", fileString)
                let _ = deleteFileFromPath(directory.appendingFormat("/%@", fileString))
            }
        }
    }
    catch let error as NSError
    {
        print("Delete directory error: \(error)")
    }
}
