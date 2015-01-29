require 'rails_helper'

RSpec.describe SearchController, :type => :controller do

  describe "GET search" do
    it "gets search results" do
      get :user_search
    end
  end
end