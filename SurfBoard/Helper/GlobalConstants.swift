import Foundation
import UIKit

var isDevelopment = false
let APPNAME : String = "LINK Program"//"Link Affiliate"
let TokenHeader : String = "Bearer"

//Shadow
let shadowColor: UIColor = UIColor(hexString: "#C7C7C7")
let shadowOpacity: Float = 1
let shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0)
let shadowRadius: CGFloat = 3

extension Notification.Name {
    static let REFRESH_FEVOURITE_RESTAURANT_LIST             =   Notification.Name("REFRESH_FEVOURITE_RESTAURANT_LIST")
}

struct CustomFontName {
    static var helveticaNeue            =   "HelveticaNeue"
    static var helveticaNeueBold        =   "HelveticaNeue-Bold"
    static var helveticaNeueItalic      =   "HelveticaNeue-Italic"
}


let APP_REGULAR_FONT = CustomFontName.helveticaNeue
let APP_BOLD_FONT = CustomFontName.helveticaNeueBold
let APP_ITALIC_FONT = CustomFontName.helveticaNeueItalic
let API_KEY = "a1PYB21QaLV43LTlE786eEtUJBlhDti5yN"

struct Color {
    static var APP_THEME_COLOR                  =   #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
    static var APP_COLOR_LIGHT_GRAY             =   #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    static var APP_COLOR_WHITE                  =   #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static var APP_COLOR_DARK_BLUE              =   #colorLiteral(red: 0.07450980392, green: 0.262745098, blue: 0.5411764706, alpha: 1)
}

struct StatusCode {
    static let error                    =   0
    static let success                  =   1
    static let sessionExpired           =   4
    static let newUser                  =   5
}

enum LoginType: String {
    case normal = "NORMAL"
    case facebook = "FACEBOOK"
    case google = "GOOGLE"
}

class MarkTypeItem {
    var status = ""
    
    init(status: String) {
        
        self.status = status
    }
}

enum MarkType: String {
    
    case yes = "y"
    case no = "n"
    case notAvailable = "N\\A"
    case other = "other"
    
    var instance: MarkTypeItem {
        
        switch self {
            
        //Side menu items
        case .yes:              return MarkTypeItem(status: "1")
        case .no:               return MarkTypeItem(status: "2")
        case .notAvailable:     return MarkTypeItem(status: "3")
        case .other:            return MarkTypeItem(status: "0")
        }
    }
}
//struct APP_LAYOUT
//{
//    static let IS_IPAD = UI_USER_INTERFACE_IDIOM() == .pad
//    static let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == .phone
//    static let IS_RETINA = UIScreen.main.scale >= 2.0
//    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
//    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//    static let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
//    static let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)
//    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH < 568.0
//    static let IS_IPHONE_5 = IS_IPHONE && SCREEN_MAX_LENGTH == 568.0
//    static let IS_IPHONE_6 = IS_IPHONE && SCREEN_MAX_LENGTH == 667.0
//    static let IS_IPHONE_6P = IS_IPHONE && SCREEN_MAX_LENGTH == 736.0
//    static let IS_IPHONE_X = IS_IPHONE && SCREEN_MAX_LENGTH == 812.0  //xs
//    static let IS_IPHONE_XR = IS_IPHONE && SCREEN_MAX_LENGTH == 896.0  // xsMax
//
//    static let IS_IOS_8 = Float(UIDevice.current.systemVersion) ?? 0.0 >= 8.0
//}


//MARK: - API
struct API {
    
    //Base API
    static var SERVER_URL = "http://surfboard-api.ebizwork.com/api/mobile/"
    static var LIVE_URL = "https://linkaffiliateapp.com/api/mobile/"
    static var BASE_URL = API.LIVE_URL // API.SERVER_URL
    
    
    
    //Pusher chat auth
//    static let PUSHER_SERVER_AUTH     = "http://surfboard-api.ebizwork.com/api/broadcasting/auth"
    static let PUSHER_SERVER_AUTH     = "https://linkaffiliateapp.com/api/broadcasting/auth"
    
    //User Auth_Api
    static let LOGIN                  =   "login"
    static let REGISTER               =   "register"
    static let FORGET_PASSWORD        =   "forgot-password"
    static let RESET_PASSWORD         =   "user/reset-password"
    static let UPDATE_USER_PROFIE     =   "user/update"
    static let UPDATE_USER_IMAGE      =   "user/upload-image"
    static let UPDATE_WAIVER_DATA     =   "user/update-user-info"
    static let CHECK_WAIVER           =   "location/customer-wavier/get"
    static let FETCH_WAIVER_SIGNOF    =   "setting/fetch-waiver-signoff"
    static let SUBMIT_WAIVER          =   "location/customer-wavier/accept"
    static let SUBMIT_REQUEST         =   "request-info"
    static let CURRENT_USER_PROFIE    =   "user/current"
    static let SEARCH_LOCATION        =   "location/search-Location"
    static let STRIPE_PAYMENT         =   "stripe"
    static let STRIPE_PAYMENT_NEW     =   "location/booking_histories/add"
    static let ADD_TO_FAV             =   "location/favorite-Location"
    static let PATH_SET_API           =   "user/choose-path"
    static let GET_HOLIDAYS           =   "location/active-days/get"//"location/holidays/get"
    static let GET_SESSION            =   "location/session-data"
    static let CHECK_BOOKING          =   "user/check-booking"
    static let CHECK_BOOKING_STATUS   =   "location/booking-status"
    static let CHECK_MEMBERSHIP       =   "subscription/check"
    static let CREATE_MEMBERSHIP      =   "subscription/create"
    static let CONFIRM_SUBSCRIPTION   =   "subscription/confirm"
    static let GET_PROGRESSION_DATA   =   "user/progression"
    static let GET_UPCOMING_SESSION   =   "sessions/upcoming-sessions"
    static let GET_PAST_SESSION       =   "sessions/previous-sessions"
    static let SUBMIT_RATING          =   "sessions/rating"
    static let PUSH_NOTIFICATION      =   "notification/user-token"
    static let GET_TIME_SLOT          =   "time-slot/get"
    static let GET_ACTIVE_HOURS       =   "location/active-hours"
    static let CHECK_AVAIBILITY       =   "location/get-time-data"
    static let GET_PROGRESSION_LEVEL_FEES          =   "user/progression-level"
    static let CREATE_STRIPE_CUST     =   "user/create-stripe-customer"
    static let CREATE_PAYMENT_INTENT  =   "user/create-payment-intent"
    static let GET_CUSTOMER_WAVIER    =   "location/customer-wavier/get"
    static let GET_MSG_API            =   "chat/fetch-messages"
    static let SEND_MSG_API           =   "chat/send-message"
    static let DELETE_MSG_API         =   "chat/delete-message"
    static let BUY_BOARD              =   "user/boards"
    
    //chat
    static let FETCH_ROOMS            =   "chat/fetch-rooms"
    static let CREATE_ROOMS           =   "chat/create-room"
    static let SEARCH_CONTACT         =   "chat/search-contact"
    
    //membership
    static let FETCH_MEMBERSHIP       =   "membership/fetch"
    static let CANCEL_MEMBERSHIP      =   "membership/cancel"
    static let RESTART_MEMBERSHIP     =   "membership/restart"
    static let DEFAULT_MEMBERSHIP     =   "membership/make-default"
    static let GET_MEMBERSHIP_FEES    =   "user/retrive-user-membership"
    
    //Cancel Session
    static let CANCEL_SESSION         =   "sessions/cancel"
    static let RESCHEDULE_SESSION     =   "location/booking_histories/update"
    static let GET_LOCATION_DETAILS_OF_SESSION         =   "sessions/get-details"
    
    
}
struct MSG {
    static let NO_RESPONSE              = "No Response from Server."
    static let SOMETHINGWRONG           = "Something went Wrong."
    static let WRONG_CREDS              = "Incorrect credentials."
    static let NO_NETWORK               = "No network available."
    static let SUCCESSFULLY_UPDATE      = "Successfully Updated."
    static let SUCCESSFULLY_DELETE      = "Successfully Deleted."
    static let SUCCESSFULLY_CREATE      = "Successfully Created."
    static let RECEVINIG_CALL           = "You will be receiving a call."
    static let CONTACT_ADMIN            = "There was a problem, please contact your admin."
    static let TRY_AGAIN                = "There was a problem, please try again."
    
}

struct SESSION_TYPE {
    static let NORMAL_SESSION               = "normal_session"
    static let PROGRESSION_ENROLL           = "progression_enrollment"
    static let PROGRESSION_1                = "progression_level_1"
    static let PROGRESSION_2                = "progression_level_2"
    static let PROGRESSION_3                = "progression_level_3"
    static let PROGRESSION_4                = "progression_level_4"
    static let DISCOVERY_SESSION            = "discovery_lesson"

}

class UserDetail: NSObject
{
    static let shared = UserDetail()
    
    static var user_ID:String                = ""
    static var user_FirstName:String         = ""
    static var user_LastName:String          = ""
    static var user_MiddleName:String        = ""
    static var user_Email:String             = ""
    
}
class CompanyDetail: NSObject
{
    static let shared = CompanyDetail()
    
    static var company_ID:Int!
    static var company_Name:String         = ""
    static var company_Email:String        = ""
    
}
class CardDetail: NSObject
{
    static let shared = CardDetail()
    
    static var Card_ID:Int              = 0
    static var Card_Name:String         = ""
    static var Card_Number:String       = ""
}

struct traderMenu {
    static var SNEAK_PEAK = 0
    static var ORDERS = 1
    static var ORDER_PLACED = 2
    static var  RECEIVED_ORDER = 3
    static var MAKE_OFFER = 4
    static var PRODUCT_LIST = 5
    static var SELL_PRODUCTS = 6
    static var PRODUCT_FOR_SALE = 7
    static var  WISHLIST = 8
    static var REFER_A_FRIEND = 9
}


