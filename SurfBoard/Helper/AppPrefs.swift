

import UIKit
import CoreLocation

class AppPrefs: NSObject
{

    static let shared = AppPrefs()
    
    private let IS_USER_LOGIN_KEY                           =   "IS_USER_LOGIN"
    private let USER_DATA_KEY                               =   "USER_DATA"
    private let USER_ID_KEY                                 =   "USER_ID"
    private let USER_ROLE_KEY                               =   "USER_ROLE_KEY"
    private let USER_NAME_KEY                               =   "USER_NAME_KEY"
    private let USER_PROFILE_KEY                            =   "USER_PROFILE_KEY"
    private let BILLING_ADDRESS_KEY                         =   "BILLING_ADDRESS_KEY"
    private let SHIPPING_ADDRESS_KEY                        =   "SHIPPING_ADDRESS_KEY"
    private let DYNAMIC_MENU_KEY                            =   "DYNAMIC_MENU_KEY"
    private let SESSION_ID_KEY                              =   "SESSION_ID_KEY"
    private let REMAMBER_ME_KEY                             =   "REMAMBER_ME_KEY"
    private let NEED_TO_DISPLAY_INSTRUCTIONS_KEY            =   "NEED_TO_DISPLAY_INSTRUCTIONS_KEY"
    private let OFFICE_NO                                   =   "OfficeNumber"
    private let CELL_PHONE_NO                               =   "CellPhoneNumber"
   

    func setDataToPreference(data: AnyObject, forKey key: String) {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(archivedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getDataFromPreference(key: String) -> AnyObject? {
        let archivedData = UserDefaults.standard.object(forKey: key)
        
        if(archivedData != nil) {
            return NSKeyedUnarchiver.unarchiveObject(with: archivedData! as! Data) as AnyObject?
        }
        return nil
    }
    
    func removeDataFromPreference(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func isKeyExistInPreference(key: String) -> Bool {
        if(UserDefaults.standard.object(forKey: key) == nil) {
            return false
        }
        
        return true
    }
    
    
    //MARK: - User login boolean
    
    func setIsUserRememberLogin(isUserLogin: Bool) {
        setDataToPreference(data: isUserLogin as AnyObject, forKey: REMAMBER_ME_KEY)
    }
    
    func isUserRememberLogin() -> Bool {
        let isUserLogin = getDataFromPreference(key: REMAMBER_ME_KEY)
        return isUserLogin == nil ? false:(isUserLogin as! Bool)
    }
    
    
    func setIsUserLogin(isUserLogin: Bool) {
        setDataToPreference(data: isUserLogin as AnyObject, forKey: IS_USER_LOGIN_KEY)
    }
    
    func isUserLogin() -> Bool {
        let isUserLogin = getDataFromPreference(key: IS_USER_LOGIN_KEY)
        return isUserLogin == nil ? false:(isUserLogin as! Bool)
    }
    
    //MARK: - User data
    func saveUserData(dataObject: [String: AnyObject]) {
        setDataToPreference(data: dataObject as AnyObject, forKey: USER_DATA_KEY)
    }
    
    func getUserDataJson() -> [String: AnyObject] {
        return getDataFromPreference(key: USER_DATA_KEY) as? [String: AnyObject] ?? [String: AnyObject]()
    }
    
    func getUserData() -> UserData {
        let data = getDataFromPreference(key: USER_DATA_KEY) as? [String: AnyObject] ?? [String: AnyObject]()
        return UserData(data: data)
    }


    func removeUserData() {
        removeDataFromPreference(key: USER_DATA_KEY)
    }
    
    
    
    
    //MARK: - User Id
    func saveUserId(userId: String) {
        setDataToPreference(data: userId as AnyObject, forKey: USER_ID_KEY)
    }
    
    func getUserId() -> String {
        return getDataFromPreference(key: USER_ID_KEY) as? String ?? ""
    }
    
    func removeUserId() {
        removeDataFromPreference(key: USER_ID_KEY)
    }
    
    //MARK: - Session Id
    func saveSessionId(userId: String) {
        setDataToPreference(data: userId as AnyObject, forKey: SESSION_ID_KEY)
    }
    
    func getSessionId() -> String {
        return getDataFromPreference(key: SESSION_ID_KEY) as? String ?? ""
    }
    
    func removeSessionId() {
        removeDataFromPreference(key: SESSION_ID_KEY)
    }
    
    
    //MARK: - UserName
    func saveUserName(name: String) {
        setDataToPreference(data: name as AnyObject, forKey: USER_NAME_KEY)
    }
    
    func getUserName() -> String {
        return getDataFromPreference(key: USER_NAME_KEY) as? String ?? ""
    }
    
    func removeUserName() {
        removeDataFromPreference(key: USER_NAME_KEY)
    }
    
    
    //MARK: - UserName
    func saveUserProfile(url: String) {
        setDataToPreference(data: url as AnyObject, forKey: USER_PROFILE_KEY)
    }
    
    func getUserProfile() -> String {
        return getDataFromPreference(key: USER_PROFILE_KEY) as? String ?? ""
    }
    
    func removeUserProfile() {
        removeDataFromPreference(key: USER_PROFILE_KEY)
    }
    
    //MARK: - Set Need to display instactions boolean -
    func setIsNeedToDisplayInstructions(isNeeded: Bool) {
        setDataToPreference(data: isNeeded as AnyObject, forKey: NEED_TO_DISPLAY_INSTRUCTIONS_KEY)
    }
    
    func isNeedToDisplayInstructions() -> Bool {
        let isUserLogin = getDataFromPreference(key: NEED_TO_DISPLAY_INSTRUCTIONS_KEY)
        return isUserLogin == nil ? false:(isUserLogin as! Bool)
    }
    
    //MARK: - Cell Phone Number / Office_Number
    func saveOfficeNumber(officeNo: String) {
        setDataToPreference(data: officeNo as AnyObject, forKey: OFFICE_NO)
    }
    
    func getOfficeNumber() -> String {
        return getDataFromPreference(key: OFFICE_NO) as? String ?? ""
    }
    
    func removeOfficeNumber() {
        removeDataFromPreference(key: OFFICE_NO)
    }
    
    func saveCellPhoneNumber(cellphoneNo: String) {
        setDataToPreference(data: cellphoneNo as AnyObject, forKey: CELL_PHONE_NO)
    }
    
    func getCellPhoneNumber() -> String {
        return getDataFromPreference(key: CELL_PHONE_NO) as? String ?? ""
    }
    
    func removeCellPhoneNumber() {
        removeDataFromPreference(key: CELL_PHONE_NO)
    }
}
