#
# Copyright (c) 2018 PSPDFKit GmbH. All rights reserved.
#
# The PDFXKit is licensed with a modified BSD license. Please see License for
# details. This notice may not be removed from this file.
#

Pod::Spec.new do |spec|
  spec.name = "PSPDFKit.swift"
  spec.version = "1.0.0"
  spec.summary = ""
  spec.documentation_url = ""

  spec.description = ""

  spec.homepage = "http://github.com/PSPDFKit/PSPDFKit.swift"
  spec.license = { :type => "BSD (modified)", :file => "LICENSE.md" }

  spec.author = { "PSPDFKit GmbH" => "info@pspdfkit.com" }
  spec.social_media_url = "http://twitter.com/pspdfkit"

  spec.platform = :ios, "11.0"
  spec.ios.deployment_target = "9.0"
  
  spec.swift_version = "4.0"
  spec.cocoapods_version = '>= 1.4.0'

  spec.source = { :git => "git@github.com:PSPDFKit/PSPDFKit.swift.git", :branch => "master" }
  spec.source_files = "Sources", "Sources/**/*.{h,m,swift}"
  spec.public_header_files = "Sources/**/*.{h,apinotes}"

  spec.requires_arc = true

  spec.module_name = 'PSPDFKitSwift'
  spec.dependency "PSPDFKit"
end