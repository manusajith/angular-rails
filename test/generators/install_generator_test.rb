require 'test_helper'
require 'generators/generators_test_helper'
require "generators/angular/install/install_generator"
require 'mocha/api'

class InstallGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper
  tests Angular::Generators::InstallGenerator
  
  def setup
    mkdir_p "#{destination_root}/app/assets/javascripts"
    cp fixture("application.js"), "#{destination_root}/app/assets/javascripts"
    Rails.application.class.stubs(:name).returns("Dummy::Application")
    
    super
  end

  test "Assert template directory structure is created" do
    run_generator
    assert_directory angular_templates_path
    assert_file "#{angular_templates_path}/.gitkeep"
  end

  test "Assert angular directory structure is created" do
    run_generator
    
    %W{controllers filters services widgets}.each do |dir|
      assert_directory "#{angular_path}/#{dir}"
      assert_file "#{angular_path}/#{dir}/.gitkeep"
    end
  end

  test "Assert angular spec directory structure is created" do
    run_generator
    assert_directory angular_spec_path
    assert_file "#{angular_spec_path}/.gitkeep"
  end
  

  test "Assert no gitkeep files are created when skipping git" do
    run_generator [destination_root, "--skip-git"]
    
    %W{controllers filters services widgets}.each do |dir|
      assert_no_file "#{angular_path}/#{dir}/.gitkeep"
    end
		assert_no_file "#{angular_spec_path}/.gitkeep"
		assert_no_file "#{assets_path}/templates/.gitkeep"
  end
  
  test "Assert application.js require angular.js and angular directory" do
    run_generator
    
    assert_file "app/assets/javascripts/application.js" do |application|
      assert_match /require angular.min(.*)require angle-up(.*)require_tree \.\/angular/m, application
    end
  end  
  
  def fixture(file)
    File.expand_path("fixtures/#{file}", File.dirname(__FILE__))
  end
  
end

