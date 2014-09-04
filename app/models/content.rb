require 'dropbox_sdk'

class Content < ActiveRecord::Base

    scope :updated,   ->   { order('updated_at DESC') }
    scope :by_height, ->   { order('height DESC') }
    scope :belongs_to_user, ->(userid) { where(['contents.user_id = ? OR is_public = ?', userid, 'true']) }
    scope :visible_to_admin, -> {where(['is_public=?', 'true'])}

    paginates_per 6

    belongs_to :user
    has_many :taggings, :dependent => :destroy

    has_many :tags, through: :taggings, :dependent => :destroy
    has_many :student_responses, through: :taggings

    has_attached_file :image

    after_initialize :init_attachment

    validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/pjpeg',
                                   'image/jpg', 'image/png', 'image/tif', 'image/gif'], :message => "has to be in a proper format"

    validates_attachment_presence :image

    validates_attachment_size :image, :less_than => 1.megabytes

    validates :tag_list, :presence => true

    before_save :extract_dimensions

    serialize :dimensions

    # before_save :redelegate_to_admin

    def matching_taggings
        taggings.map(&:id).join(', ')
    end

    def self.tagged_with(name)
        Tag.find_by_name!(tagname).contents
    end

    def self.tag_counts(userid)
        Tag.joins(:contents).where(['contents.user_id = ? OR contents.is_public = ?', userid, 'true']).
            select("tags.*, count(taggings.tag_id) as count").joins(:taggings).group("tags.id")
    end

    def self.select_tags(userid)
        Tag.joins(:contents).where(['contents.user_id = ? OR contents.is_public = ?', userid, 'true']).
            select("tags.*").joins(:taggings).group("tags.id")
    end

    def tag_list
        tags.map(&:tagname).join(", ")
    end

    def tag_list=(tagnames)
        if !tagnames.nil?
            tagnames.downcase!
            tagnames = tagnames.split(',').collect(&:strip).uniq.join(',')
            self.tags = tagnames.split(",").map do |t|
                # puts ("before creating a tag")
                # tagg = self.tags.find_by(t.strip)
                # puts "tagg: #{tagg}"
                Tag.where(tagname: t.strip).first_or_create!
                # Tag.create_with(tagname: t.strip).find_or_create_by(tagname: t.strip)
                # puts ("after creating a tag")
            end
        end
    end

    # Helper method to determine whether or not an attachment is an image.
    # @note Use only if you have a generic asset-type model that can handle different file types.
    def image?
        upload_content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}
    end

    def content_public_as_string
        self.is_public ? "Yes" : "No"
    end

    private

        # dropbox was replaced with AWS. Code is left here in case it will be decided to bring it back later.
        def init_attachment_dropbox

                self.class.has_attached_file :image, :styles => { :original => ["100%", :jpg],
                                                                  :small => ["100x100#", :jpg],
                                                                  :thumb => ["100x100#", :jpg] },
                                :storage => :dropbox,
                                :dropbox_credentials => { :app_key => DROPBOX_APP_KEY,
                                                          :app_secret => DROPBOX_APP_KEY_SECRET,
                                                          :access_token => self.user.access_token,
                                                          :access_token_secret => self.user.access_secret,
                                                          :user_id => self.user.uid,
                                                          :access_type => "dropbox" },
                                :dropbox_options => {},
                                :path => "SLPAPP/:style/:id_:filename",
                                :unique_filename => true,
                                :dropbox_visibility => 'private'

        end

        def init_attachment

            self.class.has_attached_file :image, :styles => { :original => ["100%", :jpg],
                                                                  :small => ["100x100#", :jpg],
                                                                  :thumb => ["100x100#", :jpg] },
                                                    :storage => :s3,
                                                    :s3_credentials => {
                                                            :bucket => ENV['S3_BUCKET_NAME'],
                                                            :access_key_id => ENV['AWS_ACCESS_KEY'],
                                                            :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                                                        }, #"#{Rails.root}/config/aws.yml",

                                                    :path => '/:class/:attachment/:id_partition/:style/:filename',
                                                    :url => ':s3_domain_url'

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

        def redelegate_to_admin
            if self.is_public
                admin = User.where(:admin => true).first
                admin_id = admin.id
                self.user_id = admin_id
            end
        end

end
