# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ShoppingApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ShoppingApp

pod 'Kingfisher', '~> 7.0'
pod 'Alamofire'
pod 'SnapKit', '~> 5.6.0'
pod 'PKHUD', '~> 5.0'

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
