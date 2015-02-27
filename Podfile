#
#  Podfile
#
#  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
#

# Pod sources
source 'https://github.com/CocoaPods/Specs.git'

# Initial configuration
platform :ios, '7.0'
inhibit_all_warnings!

# Framework dependencies
pod 'AFNetworking', '~> 2.5'
pod 'UICKeyChainStore', '~> 1.1'
pod 'XLForm', '~> 2.1'
pod 'NGRValidator', '~> 0.4.2'
pod 'Facebook-iOS-SDK', '~> 3.23'

# Unit tests exclusive dependencies
target 'Tests', exclusive: true do link_with 'Unit Tests', 'Functional Tests'
  pod 'Kiwi', '~> 2.3'
  pod 'OHHTTPStubs', '~> 3.1'
  pod 'KIF-Kiwi', '~> 0.2'
end
