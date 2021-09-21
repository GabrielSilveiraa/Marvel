# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MarvelApp' do
  use_frameworks!

  pod 'GMSNetworkLayer', '~> 1.1'
  pod 'Arcane', git: 'https://github.com/onmyway133/Arcane'
  pod 'Kingfisher'

  target 'MarvelAppTests' do
  end

  target 'MarvelAppUITests' do
  end

  target 'MarvelSnapshotTests' do
#    Temporary branch since there's an issue with Xcode 13 and it was not merged to main branch yet
#    pod 'PixelTest'
    pod 'PixelTest', :git => 'https://github.com/keither04/PixelTest.git', :branch => 'bugfix/disambiguate-selector-xcode-13'
  end

end
