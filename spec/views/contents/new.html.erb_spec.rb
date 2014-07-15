require 'rails_helper'

RSpec.describe "contents/new", :type => :view do
  before(:each) do
    assign(:content, Content.new(
      :type => "",
      :is_public => false,
      :dblink => "MyString",
      :user_id => 1
    ))
  end

  it "renders new content form" do
    render

    assert_select "form[action=?][method=?]", contents_path, "post" do

      assert_select "input#content_type[name=?]", "content[type]"

      assert_select "input#content_is_public[name=?]", "content[is_public]"

      assert_select "input#content_dblink[name=?]", "content[dblink]"

      assert_select "input#content_user_id[name=?]", "content[user_id]"
    end
  end
end
