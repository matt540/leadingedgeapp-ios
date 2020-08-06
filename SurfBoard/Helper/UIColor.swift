import UIKit


extension UIColor
{
    convenience init(hexString: String)
    {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hexString.hasPrefix("#")
        {
            let index   = hexString.index(hexString.startIndex, offsetBy: 1)
            let hex     = hexString.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexInt64(&hexValue)
            {
                if hex.count == 6
                {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                }
                else if hex.count == 8
                {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0  
                }
                else
                {
                    print("invalid rgb string, length should be 7 or 9", terminator: "")
                }
            }
            else
            {
                print("scan hex error", terminator: "")
            }
        }
        else
        {
            print("invalid rgb string, missing '#' as prefix", terminator: "")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    var toHexString: String {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}

func RGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor
{
    return UIColor(red: (r) / 255.0, green: (g) / 255.0, blue:(b) / 255.0, alpha: 1)
}
func RGBCG(r: CGFloat, g: CGFloat, b: CGFloat) -> CGColor
{
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1).cgColor
}
