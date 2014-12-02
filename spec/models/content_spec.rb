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

    context "Content returns public/private as a string" do
        content = Content.new
        it "should return yes as string" do
            content.is_public = true
            expect(content.content_public_as_string).to eq 'Yes'
        end
        it "should return no as string" do
            content.is_public = false
            expect(content.content_public_as_string).to eq 'No'
        end
    end

    context "Content's tag associations" do
        content = Content.new
        let(:user) {FactoryGirl.create(:user)}
        it "should have proper tags" do
            content.tag_list = 'good, bad'
            expect(content.tag_list).to eq 'good, bad'
        end

        it "returns matching taggings" do
            content = build(:content)
            content.save(:validate => false)
            tag = create(:tag, :tagname => 'good')
            tagging = create(:tagging, content_id: content.id, tag_id: tag.id)
            taggin = content.taggings.map(&:id).join(', ')
            expect(content.matching_taggings).to eql (taggin)
        end

        it "returns selected tags and tag counts" do
            content = build(:content, user_id: user.id)
            content.save(:validate => false)
            tag = create(:tag, :tagname => 'good')
            tagging = create(:tagging, content_id: content.id, tag_id: tag.id)
            expect(Content.tag_counts(user).first).to eql Tag.all.first
            expect(Content.select_tags(user).first).to eql Tag.all.first
        end
    end

    describe "content's dimensions are saved" do
        let(:content){FactoryGirl.build(:content)}
        before do
            content.save(:validate => false)
        end
        it "saves the height" do
            expect(content.height).to eql 95
        end
        it "saves the dimenstions" do
            expect(content.dimensions).to eql [43,95]
        end
    end

end


























