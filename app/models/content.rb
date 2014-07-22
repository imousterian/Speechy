require 'dropbox_sdk'

class Content < ActiveRecord::Base

    default_scope { order('updated_at DESC') }
    paginates_per 6

    belongs_to :user
    has_many :taggings

    has_many :tags, through: :taggings #:dependent => :destroy

    has_attached_file :image
    after_initialize :init_attachment

    validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/pjpeg',
                                   'image/jpg', 'image/png', 'image/tif', 'image/gif'], :message => "has to be in a proper format"

    validates_attachment_presence :image

    validates_attachment_size :image, :less_than => 1.megabytes

    def self.tagged_with(name)
        Tag.find_by_name!(tagname).contents
    end

    def self.tag_counts
         Tag.select("tags.*, count(taggings.tag_id) as count").joins(:taggings).group("tags.id")
         # Tag.select("tags.*, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
    end

    def tag_list
        tags.map(&:tagname).join(", ")
    end

    def tag_list=(tagnames)
        self.tags = tagnames.split(",").map do |n|
            Tag.where(tagname: n.strip).first_or_create!
        end
    end


    private

        def init_attachment

            self.class.has_attached_file :image, :styles => { :original => ["100%", :jpg],
                                                              :small => ["100x100#", :jpg],
                                                              :thumb => ["100x100#", :jpg] },
                            :storage => :dropbox,
                            :dropbox_credentials => { :app_key => DROPBOX_APP_KEY,
                                                      :app_secret => DROPBOX_APP_KEY_SECRET,
                                                      :access_token => self.user.access_token,#User.current.access_token,
                                                      :access_token_secret => self.user.access_secret,#User.current.access_secret,
                                                      :user_id => self.user.uid,#User.current.uid,
                                                      :access_type => "dropbox" },
                            :dropbox_options => {},
                            :path => "SLPAPP/:style/:id_:filename",
                            :unique_filename => true,
                            :dropbox_visibility => 'private'

        end

end
