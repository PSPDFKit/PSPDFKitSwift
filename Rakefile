#
# Copyright (c) 2018 PSPDFKit GmbH. All rights reserved.
#
# The PSPDFKit.swift is licensed with a modified BSD license. Please see License for
# details. This notice may not be removed from this file.
#
# General Guidelines
# ------------------
#
# Try to avoid file and directory names containing *spaces*.
#
# On the other hand, *quote* every file and directory reference when passing
# it to a command if the reference *might* contain a space.
#
# Avoid encapsulating parts of the build script into functions. As a rule of
# thumb: no function other than `run` should call a shell command (exception:
# generic one-liners to check something for example) and no function should
# call the `run` function itself, `run` is only intended to be used at the task
# level.
#
# Keep intermediate results. If you need to modify a previous result, copy it
# first. This will ease debugging if something goes wrong and allows you to
# comment out certain stages of the script to save time when working on it.
#
# When working within a deep-ish path, consider cd-ing into the directory first.
# You have to do this for each run call, simply prepend your actual command
# with something like `cd some/deep/directory/; ...`. Do *not* change the
# working directory for the whole script though (using Ruby's `File.chdir` &
# friends).

# Naming Conventions: Constants
# -----------------------------
#
# * A directory name is suffixed with `_DIRECTORY`
# * A file's base name constant is suffixed with `_NAME`
# * A file's full name including extension is suffixed with `_FILE`
# * A full file or directory path (absolute & relative) is suffixed with `_PATH`
# * A directory path should *not* end with a slash `/`
#
# Try to avoid full path constants because it becomes really difficult to read
# and understand the build script, i.e. what file or directory is referenced or
# created and where.

require 'rubygems'

# --------------------------------------------------------------- Options ------

NAME = ENV['name'] || ""
DIRECTORY = ENV['directory'] || "Build"
VERBOSE = ENV['verbose'] || false

# ------------------------------------------------------------- Constants ------

CONFIGURATION = "Release"
DERIVED_DATA = "#{DIRECTORY}/Xcode"
SDK_SIM = "iphonesimulator12.0"
SDK_IOS = "iphoneos12.0"
SDK_MACOS = "macosx10.14"
SCHEME_IOS = "PSPDFKitSwift"
SCHEME_MACOS = "PSPDFKitSwift-macOS"
XCODE_FLAGS_IOS = "-configuration #{CONFIGURATION} -scheme #{SCHEME_IOS} -derivedDataPath \"#{DERIVED_DATA}\""
XCODE_FLAGS_MACOS = "-configuration #{CONFIGURATION} -scheme #{SCHEME_MACOS} -derivedDataPath \"#{DERIVED_DATA}\""
XCODE_PROJECT = "PSPDFKitSwift.xcodeproj"

# ---------------------------------------------------------------- Colors ------

TERMINAL = STDOUT.tty?

BOLD = TERMINAL ? "\x1B[0;1m" : ""
RESET = TERMINAL ? "\x1B[0m" : ""

BLACK = TERMINAL ? "\x1B[0;30m" : ""; RED = TERMINAL ? "\x1B[0;31m" : ""; GREEN = TERMINAL ? "\x1B[0;32m" : ""; YELLOW = TERMINAL ? "\x1B[0;33m" : ""; BLUE = TERMINAL ? "\x1B[0;34m" : ""; MAGENTA = TERMINAL ? "\x1B[0;35m" : ""; CYAN = TERMINAL ? "\x1B[0;36m" : ""; WHITE = TERMINAL ? "\x1B[0;37m" : ""
BLACK_BRIGHT = TERMINAL ? "\x1B[1;30m" : ""; RED_BRIGHT = TERMINAL ? "\x1B[1;31m" : ""; GREEN_BRIGHT = TERMINAL ? "\x1B[1;32m" : ""; YELLOW_BRIGHT = TERMINAL ? "\x1B[1;33m" : ""; BLUE_BRIGHT = TERMINAL ? "\x1B[1;34m" : ""; MAGENTA_BRIGHT = TERMINAL ? "\x1B[1;35m" : ""; CYAN_BRIGHT = TERMINAL ? "\x1B[1;36m" : ""; WHITE_BRIGHT = TERMINAL ? "\x1B[1;37m" : ""

OK = GREEN + "OK" + RESET
FAILED = RED + "FAILED" + RESET
SKIPPED = YELLOW + "SKIPPED" + RESET

ERROR = RED + "Error:" + RESET
WARNING = YELLOW + "Warning:" + RESET

# ----------------------------------------------------------------- Tasks ------

desc "Check prerequisites"
task :check do
  tell "Checking whether PSPDFKit.framework present"
  assert File.directory?("Frameworks/PSPDFKit.framework"), """
    #{ERROR} couldn't find #{BOLD}PSPDFKit.framework#{RESET}. Please download the
    PSPDFKit framework and copy it into the #{BOLD}Frameworks/#{RESET} folder.
    https://pspdfkit.com
  """

  tell "Checking whether PSPDFKitUI.framework present"
  assert File.directory?("Frameworks/PSPDFKitUI.framework"), """
    #{ERROR} couldn't find #{BOLD}PSPDFKitUI.framework#{RESET}. Please download the
    PSPDFKit framework and copy it into the #{BOLD}Frameworks/#{RESET} folder.
    https://pspdfkit.com
  """

  tell "Checking whether iOS SDK 12 present"
  assert `xcrun xcodebuild -showsdks | grep iphoneos12`.to_s.strip.length > 0, """
  #{ERROR} couldn't find iOS 12 SDK. Please make sure you have the appropriate
  version of Xcode installed and use xcode-select to make it the default on
  the command line.
  """
end

task 'check:macos' do
  tell "Checking whether PSPDFKit.framework present"
  assert File.directory?("Frameworks/PSPDFKit.framework"), """
    #{ERROR} couldn't find #{BOLD}PSPDFKit.framework#{RESET}. Please download the
    PSPDFKit framework and copy it into the #{BOLD}Frameworks/#{RESET} folder.
    https://pspdfkit.com
  """
  
  tell "Checking whether macOS SDK 10.14 present"
  assert `xcrun xcodebuild -showsdks | grep macosx10.14`.to_s.strip.length > 0, """
  #{ERROR} couldn't find macOS 10.14 SDK. Please make sure you have the appropriate
  version of Xcode installed and use xcode-select to make it the default on
  the command line.
  """
end

desc "Compile PSPDFKitSwift framework (simulator)"
task 'compile:simulator' => [:check, :prepare] do
  tell "Compiling PSPDFKitSwift framework (simulator)"
  run "xcrun xcodebuild -project #{XCODE_PROJECT} -sdk #{SDK_SIM} #{XCODE_FLAGS_IOS}", :time => true, :quiet => true
end

desc "Compile PSPDFKitSwift framework (device)"
task 'compile:device' => [:check, :prepare] do
  tell "Compiling PSPDFKitSwift framework (device)"
  run "xcrun xcodebuild -project #{XCODE_PROJECT} -sdk #{SDK_IOS} #{XCODE_FLAGS_IOS}", :time => true, :quiet => true
end

desc "Copying univeral PSPDFKitSwift framework"
task 'install:simulator' => ['compile:simulator'] do
  run "rm -rf #{DIRECTORY}/PSPDFKitSwift.framework"
  run "cp -R #{DERIVED_DATA}/Build/Products/#{CONFIGURATION}-iphonesimulator/PSPDFKitSwift.framework #{DIRECTORY}/PSPDFKitSwift.framework/"
end

task 'install:device' => ['compile:device'] do
  run "cp -R #{DERIVED_DATA}/Build/Products/#{CONFIGURATION}-iphoneos/PSPDFKitSwift.framework #{DIRECTORY}/"
  run %{lipo -create -output "#{DIRECTORY}/PSPDFKitSwift.framework/PSPDFKitSwift" "#{DERIVED_DATA}/Build/Products/#{CONFIGURATION}-iphonesimulator/PSPDFKitSwift.framework/PSPDFKitSwift" "#{DERIVED_DATA}/Build/Products/#{CONFIGURATION}-iphoneos/PSPDFKitSwift.framework/PSPDFKitSwift"}
end

desc "Compile univeral PSPDFKitSwift framework"
task :compile => ['compile:simulator', 'compile:device', 'install:simulator', 'install:device'] do
  tell "Framework is ready at Frameworks/PSPDFKitSwift.framework"
  run "cp -R #{DIRECTORY}/PSPDFKitSwift.framework Frameworks/"
end

desc "Compile PSPDFKitSwift framework for macOS"
task 'compile:macos' => ['check:macos', 'prepare:macos'] do
  run "xcrun xcodebuild -project #{XCODE_PROJECT} -sdk #{SDK_MACOS} #{XCODE_FLAGS_MACOS}", :time => true, :quiet => true
  run "rm -rf #{DIRECTORY}/PSPDFKitSwift.framework"
  run "cp -R #{DERIVED_DATA}/Build/Products/#{CONFIGURATION}/PSPDFKitSwift.framework #{DIRECTORY}/"
  tell "Framework is ready at Frameworks/PSPDFKitSwift.framework"
  run "rm -rf Frameworks/PSPDFKitSwift.framework"
  run "cp -R #{DIRECTORY}/PSPDFKitSwift.framework Frameworks/"
end

desc "show help"
task :help do
  run "rake -T", :silent => true
end

task :clean do
  tell "Cleaning"
  run "rm -rf #{DIRECTORY}", :log => false
end

task :prepare do
  tell "Preparing"
  run "mkdir -p #{DIRECTORY}", :log => false
end

task 'prepare:macos' do
  tell "Preparing"
  run "mkdir -p #{DIRECTORY}", :log => false
end

# ----------------------------------------------------------- Functions ------

def assert(condition, message = "")
  unless condition
    puts message + "\n\n"
    exit 1
  end
end

def check(condition)
  unless condition
    puts FAILED
    exit 1
  end
end

def run(command, options = {})
  system_options = {}
  system_options[:out] = File::NULL if options[:quiet] && !VERBOSE
  system_options[:err] = File::NULL if options[:quiet] && !VERBOSE

  success = false

  duration = measure do
    success = system("set -e; set -u; set -o pipefail; #{command}", system_options)
    check success unless options[:survive]
  end

  puts "Finished in #{duration}" if options[:time]
  success
end

def put(string)
  print(string)
  STDOUT.flush
end

def log(message)
  puts message if VERBOSE
end

def tell(message)
  puts "#{BLUE}==>#{RESET} #{WHITE}#{message}#{RESET}"
end

def ask(message)
  put message + " [y/n] "
  answer = STDIN.getc
  puts "\n"
  %w[y n].include?(answer) ? answer : ask(message)
end

def read(file_path)
  File.open(file_path, "r", &:read)
end

def write(file_path, string)
  log "Writing file: #{file_path}"
  File.open(file_path, "w") { |file| file.write string }
end

def replace(string, with:, in:)
  file_path = binding.local_variable_get(:in)
  content = read file_path
  content.gsub!(string, with)
  write file_path, content
end

def measure
  start_time = Time.new
  yield
  end_time = Time.new
  duration(end_time - start_time)
end

def duration(total_seconds)
  hours = (total_seconds / 60.0 / 60.0).floor
  minutes = (total_seconds / 60.0 - hours * 60.0).floor
  seconds = (total_seconds - hours * 60.0 * 60.0 - minutes * 60.0).round

  duration = "#{seconds} seconds"
  duration = "#{minutes} minutes, #{duration}" if minutes.positive? || hours.positive?
  duration = "#{hours} hours, #{duration}" if hours.positive?

  duration
end

def invoke(task, *arguments)
  Rake::Task[task].invoke(*arguments)
end