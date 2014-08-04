require 'dropbox_sdk'

class Content < ActiveRecord::Base

    # default_scope { order('updated_at DESC') }
    scope :updated,   ->   { order('updated_at DESC') }
    scope :by_height, ->   { order('height DESC') }
    paginates_per 6

    belongs_to :user
    has_many :taggings

    has_many :tags, through: :taggings, :dependent => :destroy
    has_many :student_responses, through: :taggings

    has_attached_file :image

    after_initialize :init_attachment

    validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/pjpeg',
                                   'image/jpg', 'image/png', 'image/tif', 'image/gif'], :message => "has to be in a proper format"

    validates_attachment_presence :image

    validates_attachment_size :image, :less_than => 1.megabytes

    before_save :extract_dimensions

    serialize :dimensions

    # after_find :delete_image

    # after_save :delete_image

    # after_commit :delete_image



    def self.tagged_with(name)
        Tag.find_by_name!(tagname).contents
    end

    def self.tag_counts
         Tag.select("tags.*, count(taggings.tag_id) as count").joins(:taggings).group("tags.id")
         # Tag.select("tags.*, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
    end

    def self.select_tags
        Tag.select("tags.*").joins(:taggings).group("tags.id")
    end

    def tag_list
        tags.map(&:tagname).join(", ")
    end

    def tag_list=(tagnames)
        self.tags = tagnames.split(",").map do |n|
            Tag.where(tagname: n.strip).first_or_create!
        end
    end

    # Helper method to determine whether or not an attachment is an image.
    # @note Use only if you have a generic asset-type model that can handle different file types.
    def image?
        upload_content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}
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

        def extract_dimensions
            return unless image?
            tempfile = image.queued_for_write[:original]
            unless tempfile.nil?
                geometry = Paperclip::Geometry.from_file(tempfile)
                self.dimensions = [geometry.width.to_i, geometry.height.to_i]
                self.height = geometry.height.to_i
            end
        end

        # def delete_image

        #    if not self.changed?

        #     # puts "gfd"
        #     logger.debug "#{3}"

        #         if not self.image.exists?(:original)
        #             self.destroy!
        #         end
        #     end
        # end

end
