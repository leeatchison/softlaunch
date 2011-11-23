require 'spec_helper'

describe "Soft Launch Asker" do
  before :each do
    SoftLaunch.reset
    SoftLaunch.config_file=Rails.root.join "spec/config_templates/basic.yml"
  end
  it "should report launched if feature is enabled" do
    launched?(:feature1).should be_true
  end
  it "should report not launched if feature is disabled" do
    launched?(:feature2).should be_false
  end
  it "should report launched if feature is user and there is a proper cookie" do
    SoftLaunch.cookies={:soft_launch_feature3=>true}
    launched?(:feature3).should be_true
  end
  it "should report not launched if feature is user and there is no proper cookie" do
    SoftLaunch.cookies={}
    launched?(:feature1).should be_false
  end
end
