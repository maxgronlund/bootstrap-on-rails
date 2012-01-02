require 'spec_helper'
 
describe 'home page' do
  it 'welcomes the user' do
    visit '/'
    page.should have_content('log in')
  end

  it "should log us in", :js => false do
    FactoryGirl.create :user, :email => 'someone@example.com', :password => 'someone1234'
    visit '/'
    click_on 'log in'
    within("#user_new") do
      fill_in 'email', :with => 'someone@example.com'
      fill_in 'password', :with => 'someone1234'
      click_on 'Sign in'  # this be an Ajax button -- only works with Selenium
    end
    page.should have_content('Signed in successfully.')
    page.should have_content('home')
    page.should_not have_content('admin')
  end

  it "should log us in as admin", :js => false do
    FactoryGirl.create :admin, :email => 'admin@example.com', :password => 'admin1234'
    visit '/'
    click_on 'log in'
    within("#user_new") do
      fill_in 'email', :with => 'admin@example.com'
      fill_in 'password', :with => 'admin1234'
      click_on 'Sign in'
    end
    page.should have_content('Signed in successfully.')
    page.should have_content('home')
    page.should have_content('admin')
  end
end
