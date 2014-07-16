require 'rails_helper'

RSpec.describe "tags/show", :type => :view do
  before(:each) do
    @tag = assign(:tag, Tag.create!(
      :tagname => "Tagname",
      :content_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Tagname/)
    expect(rendered).to match(/1/)
  end
end
