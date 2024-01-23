# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'Scanner' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Scanner

 pod 'ImageSlideshow'
 pod ‘GoogleAPIClientForREST/Drive’
 pod ‘GoogleSignIn’
 pod 'Kingfisher'
 pod 'SVPullToRefresh'
 pod 'YandexMobileMetrica', '4.5.2'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
               end
          end
   end
end


