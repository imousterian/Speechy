require 'rails_helper'

RSpec.describe Content, :type => :model do

    context "Content is valid" do
        it { should have_attached_file(:image) }
        it { should validate_attachment_presence(:image) }
        it { should validate_attachment_content_type(:image).
                allowing('image/png', 'image/gif').
                rejecting('text/plain', 'text/xml') }
        it { should validate_attachment_size(:image).
                less_than(2.megabytes) }
    end

    context "Content is not valid" do
        it "is not valid without an image" do
            content = Content.new(image: nil)
            content.valid?
            expect(content.errors[:image]).to include("can't be blank")
        end
    end




end
