require 'dropbox_sdk'

class Content < ActiveRecord::Base


    belongs_to :user
    has_many :tags, :dependent => :destroy
    has_attached_file :image
    after_initialize :init_attachment
    # after_update :init_attachment

    # has_attached_file   :image, :styles => { :small => "100x100#", :thumb => "200x200#" },
    #                     :storage => :dropbox,
    #                     # :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
    #                     # :dropbox_credentials => ha,
    #                     :dropbox_options => {},
    #                     :path => "Public/:style/:id_:filename",
    #                     :dropbox_visibility => 'private'

    # validates_attachment_content_type :image, :content_type => /^image\/(jpeg|png|gif|tiff|tif)$/,
                                        # :message => "has to be in a proper format"
    validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/pjpeg',
                                   'image/jpg', 'image/png', 'image/tif', 'image/gif'], :message => "has to be in a proper format"

    validates_attachment_presence :image

    validates_attachment_size :image, :less_than => 1.megabytes


    private

    # def init_attachment
    #     self.class.has_attached_file :audio,
    #     :storage => :dropbox,
    #     :dropbox_credentials => { app_key: DROPBOX_KEY,
    #                              app_secret: DROPBOX_SECRET,
    #                              access_token: self.user.token,
    #                              access_token_secret: self.user.secret,
    #                              user_id: self.user.id
    #                              access_type: "app_folder"},
    #     :dropbox_options => {}
    # end

        def init_attachment
            # need to make sure whether the user authorized the app. Or move it somewhere else?
            # puts "Usr #{User.current}"
            # dbsession = DropboxSession.deserialize(User.current.dropbox_session)

            # client = DropboxClient.new(dbsession, DROPBOX_APP_MODE) #raise an exception if session not authorized

            # user_id = client.account_info['uid']
            # str = User.current.dropbox_session
            # access_token_secret, access_token_token, request_token_secret, request_token_token, app_secret, app_key = str.delete("-").scan(/\S+/)

            # self.class.has_attached_file :image, :styles => { :small => "100x100#", :thumb => "200x200#" },
            #                 :storage => :dropbox,
            #                 :dropbox_credentials => { :app_key => "jf80ghxyb2r0y2m", #DROPBOX_APP_KEY, #app_key,
            #                                           :app_secret => "f8ocxq13461xlkl", #DROPBOX_APP_KEY_SECRET, #app_secret,
            #                                           :access_token => User.current.access_token,
            #                                           :access_token_secret => User.current.access_secret,
            #                                           :user_id => User.current.uid,
            #                                           :access_type => "dropbox" },
            #                 :dropbox_options => {},
            #                 :path => "SLPAPP/:style/:id_:filename",
            #                 :dropbox_visibility => 'private'

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
