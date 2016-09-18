source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'CageMem0ry' do
    pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit.git', :tag => '0.30.0.beta2'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
