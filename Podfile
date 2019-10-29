platform :ios, '8.0'
use_frameworks!

target 'Kitman' do
    
    pod 'PureLayout', '~> 3.0.2'
    pod 'MBProgressHUD'
    pod 'OneSignal'
    pod 'IQKeyboardManagerSwift'
    pod 'SwiftKeychainWrapper'
    pod 'RSKImageCropper'
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireObjectMapper'
    pod 'Kingfisher'
    pod 'JSSAlertView'
    pod 'SwiftyJSON'
    pod 'Firebase/Core'
    pod 'Firebase/AdMob'
    pod 'CountryPicker'
    pod 'FBSDKCoreKit'
    pod 'FBSDKShareKit'
    pod 'FBSDKLoginKit'
    pod 'Fabric'
    pod 'Crashlytics'
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

