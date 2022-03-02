# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def common
  use_frameworks!
  pod 'QDCore', :path => 'library/ios-core'
  pod 'CLLocalization'
  pod 'QDWhiteLabel', :path => 'library/ios-whiteLabel'
  pod 'MaterialComponents'
  pod 'PhoneNumberKit'
  pod 'ObjectMapper'
  pod 'ProgressHUD'
  pod 'Kingfisher'
  pod 'Cosmos'
  pod 'FSCalendar'
  pod 'IQKeyboardManagerSwift'
end

target 'patient' do
    common
end

target 'doctor' do
    common
end

post_install do |installer| installer.pods_project.targets.each do |target| target.build_configurations.each do |config| config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0' end end end
