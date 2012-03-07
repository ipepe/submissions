# encoding: UTF-8
require 'spec_helper'

describe ApplicationHelper do
  describe "fix URL" do
    it "should prepend 'http://' if missing" do
      helper.prepend_http('www.dtsato.com').should == 'http://www.dtsato.com'
    end

    it "should not change URL if starts with 'http://'" do
      helper.prepend_http('http://dtsato.com').should == 'http://dtsato.com'
    end

    it "should ignore case when fixing" do
      helper.prepend_http('HTTP://dtsato.com/some/path-01').should == 'HTTP://dtsato.com/some/path-01'
    end

    it "should not prepend on empty string" do
      helper.prepend_http('').should == ''
      helper.prepend_http(nil).should be_nil
      helper.prepend_http('   ').should == '   '
    end
  end

  describe "sort link" do
    before(:each) do
      @params = {:controller => :organizer_sessions, :action => :index}
    end

    it "should link down if nothing set" do
      helper.sortable_column('test', :id, @params).should == '<a href="/organizer_sessions?column=id&amp;direction=down">test</a>'
    end

    it "should link down if was going up on that column" do
      @params[:column] = 'id'
      @params[:direction] = 'up'
      helper.sortable_column('test', :id, @params).should == '<a href="/organizer_sessions?column=id&amp;direction=down">test</a>'
    end

    it "should link up if was going down on that column" do
      @params[:column] = 'id'
      @params[:direction] = 'down'
      helper.sortable_column('test', :id, @params).should == '<a href="/organizer_sessions?column=id&amp;direction=up">test</a>'
    end

    it "should link down if was going down on another column" do
      @params[:column] = 'author_id'
      @params[:direction] = 'down'
      helper.sortable_column('test', :id, @params).should == '<a href="/organizer_sessions?column=id&amp;direction=down">test</a>'
    end

    it "should reset page when sorting is clicked" do
      @params[:column] = 'id'
      @params[:direction] = 'up'
      @params[:page] = 2
      helper.sortable_column('test', :id, @params).should == '<a href="/organizer_sessions?column=id&amp;direction=down">test</a>'
    end
  end
  
  describe "twitter_avatar" do
    it "should be blank if user has no twitter username" do
      user = FactoryGirl.build(:user)
      helper.twitter_avatar(user).should be_blank
    end
    
    it "should use user's twitter username to make API call" do
      user = FactoryGirl.build(:user, :twitter_username => 'dtsato')
      helper.twitter_avatar(user).should =~ /https:\/\/twitter.com\/api\/users\/profile_image\/dtsato/
    end
    
    it "should allow customized sizes" do
      user = FactoryGirl.build(:user, :twitter_username => 'dtsato')
      helper.twitter_avatar(user, :size => :mini).should =~ /dtsato\?size=mini/
      helper.twitter_avatar(user, "size" => :mini).should =~ /dtsato\?size=mini/
    end
  end

  describe "translated_country" do
    it "should return translated country from code" do
      helper.translated_country(:BR).should == 'Brasil'
      helper.translated_country('US').should == 'Estados Unidos'
      helper.translated_country('fr').should == 'França'
    end
  end
  
  describe "translated_state" do
    it "should return translated state from code" do
      helper.translated_state(:SP).should == 'São Paulo'
      helper.translated_state('RJ').should == 'Rio de Janeiro'
    end
  end
  
  describe "present_date" do
    before :each do
      @date = Time.zone.now
      helper = mock(helper)
    end

    it "should make date bold if current date matches" do
      helper.expects(:current_date).with(nil).returns([@date, :submissions])
      helper.present_date(nil, [@date, :submissions]).should == "<strong>#{l(@date)}: #{t('conference.dates.submissions')}</strong>"
    end

    it "should leave date if current date doesn't matches" do
      helper.expects(:current_date).with(nil).returns([@date + 1, :notifications])
      helper.present_date(nil, [@date, :submissions]).should == "#{l(@date)}: #{t('conference.dates.submissions')}"
    end

    it "should leave date if current date is nil" do
      helper.expects(:current_date).with(nil).returns(nil)
      helper.present_date(nil, [@date, :submissions]).should == "#{l(@date)}: #{t('conference.dates.submissions')}"
    end
  end

  describe "current_date" do
    before :each do
      @date = Time.zone.now
      @conference = Conference.new
      @dates = [[@date, :submissions], [@date + 1.day, :notification]]
      @conference.expects(:dates).returns(@dates)
    end

    it "should find the first date if conference's first date is previous to now" do
      DateTime.expects(:now).returns(@date - 1.day)
      helper.current_date(@conference).should == @dates.first
    end

    it "should find the second date if conference's second date is previous to now" do
      DateTime.expects(:now).returns(@date + 1.minute)
      helper.current_date(@conference).should == @dates.last
    end

    it "should find nil if current conference's last date is before now" do
      DateTime.expects(:now).returns(@date + 2.days)
      helper.current_date(@conference).should be_nil
    end
  end
end
