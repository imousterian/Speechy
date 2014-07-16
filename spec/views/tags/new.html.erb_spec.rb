require 'rails_helper'

RSpec.describe "tags/new", :type => :view do
  before(:each) do
    assign(:tag, Tag.new(
      :tagname => "MyString",
      :content_id => 1
    ))
  end

  it "renders new tag form" do
    render

    assert_select "form[action=?][method=?]", tags_path, "post" do

      assert_select "input#tag_tagname[name=?]", "tag[tagname]"

      assert_select "input#tag_content_id[name=?]", "tag[content_id]"
    end
  end
end
