#
#  Devise.podspec
#
#  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
#

Pod::Spec.new do |spec|

  spec.name          = 'Devise'
  spec.summary       = 'Simple Devise client for iOS'

  spec.homepage      = 'https://github.com/netguru/devise-ios'
  spec.license       = { :type => 'MIT', :file => 'LICENSE.md' }

  spec.authors       = { 'Patryk Kaczmarek' => 'patryk.kaczmarek@netguru.pl',
                         'Adrian Kashivskyy' => 'adrian.kashivskyy@netguru.pl',
                         'Wojciech Trzasko' => 'wojciech.trzasko@netguru.pl',
                         'Radosław Szeja' => 'radoslaw.szeja@netguru.pl',
                         'Paweł Białecki' => 'pawel.bialecki@netguru.pl'}

  spec.version       = '1.1.1'
  spec.source        = { :git => 'https://github.com/netguru/devise-ios.git', :tag => spec.version.to_s }
  spec.platform      = :ios, '7.0'

  spec.source_files  = 'Devise/**/*.{h,m}'
  spec.requires_arc  = true

  spec.dependency      'UICKeyChainStore', '~> 1.1'
  spec.dependency      'ngrvalidator', '~> 1.2.0'
  spec.dependency      'XLForm', '~> 3.0'

  spec.frameworks     = 'AddressBook', 'AssetsLibrary', 'Foundation', 'CoreLocation', 'CoreMotion', 'CoreGraphics', 'CoreText', 'MediaPlayer', 'Security', 'SystemConfiguration', 'UIKit'
  spec.vendored_frameworks = 'Frameworks/GoogleOpenSource.framework', 'Frameworks/GooglePlus.framework'
  spec.private_header_files = 'Devise/**/*Private.h'

end
