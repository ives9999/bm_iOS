# Uncomment the next line to define a global platform for your project
#platform :ios, '11.0'

target 'bm' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for bm
  pod 'Alamofire', '~> 5.4'
  pod 'Socket.IO-Client-Swift'
  pod 'Device.swift'
  pod 'AlamofireImage'
  pod 'TRVideoView'
  pod 'UIColor_Hex_Swift'
  pod 'SwipeCellKit'
  #pod 'ReachabilitySwift'
  pod 'OneSignalXCFramework', '>= 3.0.0', '< 4.0'
  
  pod 'ECPayPaymentGatewayKit', '~> 1.0.4'
  pod 'PromiseKit' , '~> 6.8.3'
  pod 'IQKeyboardManagerSwift'
  pod 'KeychainSwift' , '~> 16.0'
  pod 'SwiftyJSON' , '~> 4.2.0'
  pod 'SwiftyXMLParser' , :git => 'https://github.com/yahoojapan/SwiftyXMLParser.git'
  pod 'CryptoSwift', '~> 1.4.1'
  
  pod 'SnapKit', '~> 5.6.0'
  pod 'JXBanner'
  pod 'SCLAlertView'
  pod 'AssistantKit'
  
  #youtube
  pod 'YouTubePlayer'
  
  #qrcode
  #platform :ios, '10.0'
  pod 'MercariQRScanner'
end

target 'bmNotificationServiceExtension' do
  use_frameworks!
  pod 'OneSignalXCFramework', '>=3.0.0', '<4.0'
end

static_frameworks = ['ECPayPaymentGatewayKit']
pre_install do |installer|
  installer.pod_targets.each do |pod|
    if static_frameworks.include?(pod.name)
      puts "#{pod.name} installed as static framework!"
      def pod.static_framework?;
        true
      end
    end
  end
end
