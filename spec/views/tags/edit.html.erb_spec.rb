require 'rails_helper'

RSpec.describe "tags/edit", :type => :view do
  before(:each) do
    @tag = assign(:tag, Tag.create!(
      :tagname => "MyString",
      :content_id => 1
    ))
  end

  it "renders the edit tag form" do
    render

    assert_select "form[action=?][method=?]", tag_path(@tag), "post" do

      assert_select "input#tag_tagname[name=?]", "tag[tagname]"

      assert_select "input#tag_content_id[name=?]", "tag[content_id]"
    end
  end
end
