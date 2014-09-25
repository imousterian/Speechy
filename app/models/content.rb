class Content < ActiveRecord::Base

    scope :updated,   ->   { order('updated_at DESC') }
    scope :by_height, ->   { order('height DESC') }
    scope :belongs_to_user, ->(userid) { where(['contents.user_id = ? OR is_public = ?', userid, 'true']) }
    scope :visible_to_admin, -> {where(['is_public=?', 'true'])}

    paginates_per 12

    belongs_to :user
    has_many :taggings, :dependent => :destroy

    has_many :tags, through: :taggings, :dependent => :destroy
    has_many :student_responses, through: :taggings

    has_attached_file :image, :styles => { :original => ["100%", :jpg], :thumb => ["100x100#", :jpg] },
                                        :storage => :s3,
                                        :s3_credentials => {
                                            :bucket => ENV['S3_BUCKET_NAME'],
                                            :access_key_id => ENV['AWS_ACCESS_KEY'],
                                            :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                                        },
                                        :path => '/:class/:attachment/:id_partition/:style/:filename',
                                        :url => ':s3_domain_url'

    validates_attachment :image, :presence => true

    validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/pjpeg',
                                   'image/jpg', 'image/png', 'image/gif'], :message => "Image has to be in a valid format: only JPG, PNG, GIF, or JPEG is allowed."

    validates_attachment :image, :size => {:in => 0..2.megabytes, :message => "Image must be less than 2 MB in size."}

    validates :tag_list, :presence => true

    before_save :extract_dimensions

    serialize :dimensions

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
                Tag.where(tagname: t.strip).first_or_create!
            end
        end
    end

    # Helper method to determine whether or not an attachment is an image.
    # @note Use only if you have a generic asset-type model that can handle different file types.
    def image?
        image_content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}
    end

    def content_public_as_string
        self.is_public ? "Yes" : "No"
    end

    private

        def extract_dimensions
            return unless image?
            tempfile = image.queued_for_write[:original]
            unless tempfile.nil?
                geometry = Paperclip::Geometry.from_file(tempfile)
                self.dimensions = [geometry.width.to_i, geometry.height.to_i]
                self.height = geometry.height.to_i
            end
        end

end
