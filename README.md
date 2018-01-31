# PSPDFKitSwift

**Note**: [PSPDFKit](http://pspdfkit.com) is a *commercial* product and requires
a [paid license](https://pspdfkit.com/sales/). Please sign up for a [free trial](http://pspdfkit.com/try)
to receive an evaluation license if you haven't a production license yet.

## Introduction

## Getting Started

Make sure you have access to PSPDFKit either as a customer or by signing up for
a [free trial](https://pspdfkit.com/try/).

### Using CocoaPods

We assume you are familiar with [CocoaPods](https://cocoapods.org), otherwise
please consult the documentation first. You'll have to add PSPDFKitSwift and PSPDFKit as a dependency to your `Podfile`. You need to add `post_install` action to install additional resources.

``` Ruby
# Replace `YourAppName` with your app's target name.
target :YourAppName do
  use_frameworks!

  # Replace `YOUR_COCOAPODS_KEY` with your own.
  pod 'PSPDFKit', podspec: 'https://customers.pspdfkit.com/cocoapods/YOUR_COCOAPODS_KEY/latest.podspec'
  pod 'PSPDFKitSwift', :git => "git@github.com:PSPDFKit/PDFKitSwift.git", :branch => "master"
end

post_install do |installer|
  puts "Install PSPDFKit.apinotes"
  `curl -s -f -L https://raw.githubusercontent.com/PSPDFKit/PSPDFKitSwift/master/PSPDFKit.apinotes -o Pods/PSPDFKit/PSPDFKit.framework/Headers/PSPDFKit.apinotes`
end
```

**Note:** make sure to replace `YourAppName` with your app name and
`YOUR_COCOAPODS_KEY` with your own key provided by PSPDFKit GmbH. You can find
your key either in [customer portal](https://customers.pspdfkit.com/) or by
requesting an [evaluation license](https://pspdfkit.com/try/).


Now run `pod install`. Afterwards you should be able to build & run your project
without errors.

### Manual Set-Up

**Note:** manual set-up is only for experts, we assume you know what you are
doing. If you are unsure, please use CocoaPods or Carthage instead.

First, build the PSPDFKitSwift framework:

* Clone `git@github.com:PSPDFKit/PDFKitSwift.git`
* Copy `PSPDFKit.framework` into `PSPDFKitSwift/Frameworks`
* Copy `PSPDFKitUI.framework` into `PSPDFKitSwift/Frameworks`
* Open the terminal and `cd` into the `PSPDFKitSwift` directory
* Run `rake compile`

You should now have the `PDFFKitSwift.framework` in the `Build` folder. Next, add
the `PSPDFKit.framework`,`PSPDFKitUI.framework` and  `PDFFKitSwift.framework` to your project:

* Follow the [*Getting Started*](https://pspdfkit.com/guides/ios/current/getting-started/integrating-pspdfkit/) instructions for PSPDFKit.

* Perform steps (1) and (2) from the above *Getting Started* guide, Section
  [Integrating the Dynamic Framework](https://pspdfkit.com/guides/ios/current/getting-started/integrating-pspdfkit/#toc_integrating-the-dynamic-framework),
  and add PSPDFKitSwift to your app similar to how you did it with PSPDFKit above. You
  may also want to set up your [test targets](https://pspdfkit.com/guides/ios/current/getting-started/integrating-pspdfkit/#toc_test-targets) accordingly.
  **Note:** make sure to adapt the path for the "Run Script" build phase for PSPDFKitSwift.

You should now be able to build & run your app.

## Limitations

PSPDFKitSwift is beta software, many parts aren't implemented yet.

## Contributing

If you want to work on PSPDFKitSwift, perform the following steps:

* Clone `git@github.com:PSPDFKit/PSPDFKitSwift.git`
* Copy `PSPDFKit.framework` into `PSPDFKitSwift/Frameworks`
* Copy `PSPDFKitUI.framework` into `PSPDFKitSwift/Frameworks`
* Open `PSPDFKitSwift.xcodeproj` in Xcode >= 9

Please [sign our CLA agreement](https://pspdfkit.com/guides/web/current/miscellaneous/contributing/) so we can accept your pull requests.

Technical notes:

* All PSPDFKitSwift source files live in the `Sources` directory.
* PSPDFKit and PSPDFKitUI modules are re-exported automatically.
* PSPDFKit.apinotes is a textile file that adjust the API visibility.

## Known Issues

**Linker warning when building without Carthage**. In order to support Carthage
out-of-the-box with per-customer PSPDFKit URL, we've added the _parent_
Carthage build folder to the "Framework Search Paths". When building without
Carthage, this produces the following warning:

```
ld: warning: directory not found for option '-F/Users/konstantinbe/Projects/PSPDFKit/PSPDFKitSwift/../../../Carthage/Build/iOS'
```

--------------------------------------------------------------------------------

**Conflicting gesture recognizers**. Your gesture recognizers might be in
conflict with some of PSPDFKit's recognizers. If so, implement the
`gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)` delegate method
for the conflicting gesture recognizer and return `true`.

## License

The PSPDFKitSwift wrapper is released under a modified version of the BSD license, see
[LICENSE.md](LICENSE.md) found at the root of this git repo.