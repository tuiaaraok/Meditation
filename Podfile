# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target 'Meditation' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Meditation
  pod 'FDWaveformView'
  pod 'FirebaseAnalytics'
  pod 'Firebase/RemoteConfig'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
end
