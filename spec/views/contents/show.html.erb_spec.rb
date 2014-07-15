require 'rails_helper'

RSpec.describe "contents/show", :type => :view do
  before(:each) do
    @content = assign(:content, Content.create!(
      :type => "Type",
      :is_public => false,
      :dblink => "Dblink",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Dblink/)
    expect(rendered).to match(/1/)
  end
end
