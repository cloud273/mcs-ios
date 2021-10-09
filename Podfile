# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def common
  use_frameworks!
  pod 'QDCore', :path => 'library/ios-core'
  pod 'CLLocalization'
  pod 'QDWhiteLabel', :path => 'library/ios-whiteLabel'
  pod 'MaterialComponents', '~> 122.0.1'
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


