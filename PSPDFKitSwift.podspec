#
#  Copyright (c) 2018 PSPDFKit GmbH. All rights reserved.
#
#  The PSPDFKit Sample applications are licensed with a modified BSD license.
#  Please see License for details. This notice may not be removed from
#  this file.
#

Pod::Spec.new do |spec|
  spec.name = "PSPDFKitSwift"
  spec.version = "1.0.2"
  spec.summary = "A set of wrappers and extensions to the PSPDFKit frameworks to improve the Swift experience."

  spec.homepage = "http://github.com/PSPDFKit/PSPDFKitSwift"
  spec.license = { :type => "BSD (modified)", :file => "LICENSE.md" }

  spec.author = { "PSPDFKit GmbH" => "info@pspdfkit.com" }
  spec.social_media_url = "http://twitter.com/pspdfkit"
  
  spec.platform = :ios, "11.0", :osx, "10.13"
  spec.ios.deployment_target = "10.0"
  spec.osx.deployment_target = "10.12"
  
  spec.swift_version = "4.1"
  spec.cocoapods_version = '>= 1.5.3'

  spec.source = { :git => "https://github.com/PSPDFKit/PSPDFKitSwift.git", :tag => '1.0.2' }
  spec.source_files = "Sources", "Sources/**/*.swift"
  spec.ios.exclude_files = "Sources/**/*+macOS.swift"
  spec.osx.exclude_files = "Sources/**/*+iOS.swift", "Sources/**/PSPDFViewController.swift"

  spec.requires_arc = true

  spec.module_name = 'PSPDFKitSwift'
  spec.dependency "PSPDFKit/Swift"
end
