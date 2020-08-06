# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SurfBoard' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    pod 'Alamofire'
    pod 'Toast'
    pod 'SDWebImage'
    pod 'SlideMenuControllerSwift'
    pod 'MBProgressHUD'
    pod 'SkyFloatingLabelTextField'
    pod 'Stripe'
    pod 'JNKeychain'
    pod 'PusherSwift'
    pod 'Firebase/Crashlytics'
    pod 'Firebase/Analytics'
    pod 'Crashlytics'
    
    #pod 'CropViewController'
    #pod 'FBSDKCoreKit'
    #pod 'FBSDKShareKit'
    #pod 'FBSDKLoginKit'
    #pod 'Firebase/Auth'
    
    # Pods for SurfBoard
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
    end
end
