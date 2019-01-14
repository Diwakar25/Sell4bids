# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end


target 'Sell4Bids' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Sell4Bids
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'PageMenu'
  pod 'MessageKit', '1.0.0'
  pod 'TableFlip'
  pod 'Firebase/Storage'
  pod 'SDWebImage/WebP'
  pod 'FirebaseUI/Storage'
  #pod 'FMMosaicLayout'
  pod 'GoogleMaps'
  pod 'FBSDKCoreKit'
  #Facebook
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
  pod 'GooglePlaces'
  pod 'GoogleMaps'
  pod 'GooglePlacePicker'
  pod 'JKDropDown', '~> 1.0'
  pod 'TGPControls'
  pod 'Firebase/Messaging'
  pod 'Cosmos', '~> 12.0'
  pod 'Alamofire', '~> 4.5'
  pod 'SVProgressHUD-0.8.1'
  pod 'JGProgressHUD'
  pod 'SwiftMessages', '~> 5.0.0'
  pod 'Fabric', '~> 1.7.6'
  pod 'Crashlytics', '~> 3.10.1'
  pod 'IQKeyboardManagerSwift'
  pod 'XLPagerTabStrip', '~> 8.0.1'
  pod 'SwiftSortUtils'
  pod 'SwiftyJSON'
  pod 'SwiftyStoreKit'
  pod 'BSImagePicker', '~> 2.8'
end
