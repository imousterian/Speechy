require 'rails_helper'

RSpec.describe "contents/index", :type => :view do
  before(:each) do
    assign(:contents, [
      Content.create!(
        :type => "Type",
        :is_public => false,
        :dblink => "Dblink",
        :user_id => 1
      ),
      Content.create!(
        :type => "Type",
        :is_public => false,
        :dblink => "Dblink",
        :user_id => 1
      )
    ])
  end

  it "renders a list of contents" do
    render
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Dblink".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
