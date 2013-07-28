#!/usr/bin/env ruby

require 'albacore'
require 'fileutils'

CONFIG        = 'Debug'
RAKE_DIR      = File.expand_path(File.dirname(__FILE__))
SOLUTION_DIR  = RAKE_DIR + "/Highway/"
TEST_DIR      = SOLUTION_DIR + "/test/"
SRC_DIR       = SOLUTION_DIR + "/src/"
SOLUTION_FILE = 'Highway.Insurance.sln'
MSTEST        = ENV['VS110COMNTOOLS'] + "..\\IDE\\mstest.exe"
NUGET         = SOLUTION_DIR + "/.nuget/nuget.exe"

# --- Retrieve a list of all Test DLLS -------------------------------------------------------
Dir.chdir('test')
TEST_DLLS     = Dir.glob('*Tests').collect{|dll| File.join(dll, 'bin', CONFIG, dll + '.dll')}.map{|dll| 'test/' + dll }
Dir.chdir('../..')
# --------------------------------------------------------------------------------------------

task :default                     => ['build:msbuild']
task :test                        => ['build:mstest' ]
task :package                     => ['package:packall']
task :push                        => ['package:pushall']

namespace :build do

  msbuild :msbuild, [:targets] do |msb, args|
    args.with_defaults(:targets => :Build)
    msb.properties :configuration => CONFIG
    msb.targets args[:targets]
    msb.solution = "#{SOLUTION_DIR}/#{SOLUTION_FILE}"
  end
  
  desc "MSTest Test Runner Example"
	mstest :mstest => :msbuild do |mstest|
	    mstest.command = "C:\\Program Files (x86)\\Microsoft Visual Studio 10.0\\Common7\\IDE\\mstest.exe"
	    mstest.assemblies TEST_DLLS
	end
end
	
namespace :package do
	
	def create_packs()
		sh '.nuget/nuget.exe pack Highway/src/Highway.Insurance.UI/Highway.Insurance.UI.csproj -o pack'
		sh '.nuget/nuget.exe pack Highway/src/Highway.Insurance.UI.Web/Highway.Insurance.UI.Web.csproj -o pack'
		sh '.nuget/nuget.exe pack Highway/src/Highway.Insurance.UI.Windows/Highway.Insurance.UI.Windows.csproj -o pack'
	end
		
	task :packall => [ :clean ] do
		Dir.mkdir('pack')
		create_packs	
		Dir.glob('pack/*') { |file| FileUtils.move(file,'nuget/') }
		Dir.rmdir('pack')
	end
	
	task :pushall => [ :clean ] do
		Dir.mkdir('pack')
		create_packs	
		Dir.chdir('pack')
		Dir.glob('*').each do |file| 
			sh '../.nuget/nuget.exe push ' + file
			FileUtils.move(file,'../nuget/')
		end
		Dir.chdir('..')
		Dir.rmdir('pack')
	end
	
	task :clean do
		if Dir.exists? 'pack' 
			FileUtils.remove_dir 'pack', force = true
		end
	end
end