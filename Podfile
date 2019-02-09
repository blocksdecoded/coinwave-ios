# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://abaikirov@bitbucket.org/abaikirov/muosimplenetwork.git'

def sharedPods
  pod 'Kingfisher', '4.10.1'
  pod 'SQLite.swift'
  pod 'SVGKit', :git => 'https://github.com/SVGKit/SVGKit.git', :branch => '3.x'
  pod 'Charts'
  pod 'SideMenu'
  pod 'Fabric'
  pod 'Crashlytics'
end

target 'Cryptotracker' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  sharedPods

end

target 'DebugCryptotracker' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  sharedPods

end

target 'StagingCryptotracker' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  sharedPods

end
