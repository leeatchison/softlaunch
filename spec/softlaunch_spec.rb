require 'spec_helper'

describe SoftLaunch do
  before :each do
    SoftLaunch.reset
    SoftLaunch.config_file="spec/config_templates/basic.yml"
  end
  it "reads configuration from a specified configuration file" do
    SoftLaunch.config_file.should eq "spec/config_templates/basic.yml"
  end
  it "allows setting features as enabled" do
    sl=SoftLaunch.find "feature1"
    sl.name.should eq "My New Feature 1"
    sl.enabled?.should be_true
    sl.disabled?.should be_false
    sl.user_specific?.should be_false
  end
  it "allows setting features as disabled" do
    sl=SoftLaunch.find "feature2"
    sl.name.should eq "My New Feature 2"
    sl.enabled?.should be_false
    sl.disabled?.should be_true
    sl.user_specific?.should be_false
  end
  it "allows setting features as user enablable" do
    sl=SoftLaunch.find "feature3"
    sl.name.should eq "My New Feature 3"
    sl.enabled?.should be_false
    sl.disabled?.should be_false
    sl.user_specific?.should be_true
  end
  it "should report launched if feature is enabled" do
    sl=SoftLaunch.find "feature1"
    sl.launched?.should be_true
  end
  it "should report not launched if feature is disabled" do
    sl=SoftLaunch.find "feature2"
    sl.launched?.should be_false
  end
  it "should report launched if feature is user and there is a proper cookie" do
    SoftLaunch.cookies={:soft_launch_feature3=>true}
    sl=SoftLaunch.find "feature3"
    sl.launched?.should be_true
  end
  it "should report not launched if feature is user and there is no proper cookie" do
    SoftLaunch.cookies={}
    sl=SoftLaunch.find "feature3"
    sl.launched?.should be_false
  end
  it "should be able to get a list of all features" do
    list=SoftLaunch.all
    list.size.should eq 3
    list[0].name.should eq "My New Feature 1"
    list[1].name.should eq "My New Feature 2"
    list[2].name.should eq "My New Feature 3"
  end
  it "should be able to look up a feature by feature name" do
    feature=SoftLaunch.find "feature2"
    feature.name.should eq "My New Feature 2"
  end
  it "should be able to look up a feature by user code" do
    feature=SoftLaunch.find_by_usercode "thisisasampleusercode"
    feature.name.should eq "My New Feature 3"
  end
  
  it "should be able to set a cookie to enable a feature" do
    cookies={}
    cookies[:soft_launch_feature3].should be_nil
    SoftLaunch.cookies=cookies
    sl=SoftLaunch.find "feature3"
    sl.enable=true
    cookies[:soft_launch_feature3].should be_true
  end
  it "should be able to clear a cookie to disable a feature" do
    cookies={:soft_launch_feature3=>true}
    cookies[:soft_launch_feature3].should be_true
    SoftLaunch.cookies=cookies
    sl=SoftLaunch.find "feature3"
    sl.enable=false
    cookies[:soft_launch_feature3].should be_nil
  end
  
end
