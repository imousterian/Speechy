require 'dropbox_sdk'

class DropboxController < ApplicationController

    def authorize

        dbsession = DropboxSession.new(DROPBOX_APP_KEY, DROPBOX_APP_KEY_SECRET)
        #serialize and save this DropboxSession
        session[:dropbox_session] = dbsession.serialize
        #pass to get_authorize_url a callback url that will return the user here
        redirect_to dbsession.get_authorize_url url_for(:action => 'dropbox_callback')

    end

    def dropbox_callback

        dbsession = DropboxSession.deserialize(session[:dropbox_session])
        access = dbsession.get_access_token
        # http://localhost:3000/dropbox/dropbox_callback?oauth_token=kPsrzWUL9wuVsKzA&uid=318287546
        # puts "#{a.key}"
        # puts "#{params[:oauth_token]}"
        # access_token = dbsession.get_access_token(:oauth_verifier => params[:oauth_token])
        # puts "LLALALAL #{dbsession.access_token.serialize}" #{}" #{access_token.token} #{access_token.secret}"
        # Parameters: {"oauth_token"=>"mfQfCEh3XyVkfwO0", "uid"=>"5991997"}

        # do I need to pass and/or store access_token etc somehow differently? In a binary format?
        session[:dropbox_session] = dbsession.serialize
        current_user.update_attributes( :dropbox_session => session[:dropbox_session],
                                        :uid => params[:uid],
                                        :access_token => access.key,
                                        :access_secret => access.secret
            )

        # access_token_secret, access_token_token, request_token_secret, request_token_token, app_secret, app_key = str.delete("-").scan(/\S+/)
        puts "#{current_user.dropbox_session}"
        puts "#{current_user.access_token} #{current_user.access_secret}"

        # session2 = DropboxOAuth2Session.new(access_token, nil)

        session.delete :dropbox_session
        flash[:notice] = "You have successfully authorized with dropbox."

        redirect_to root_path

    end

    def upload
        # Check if user has no dropbox session...re-direct them to authorize
        return redirect_to(:action => 'authorize') unless session[:dropbox_session]

        dbsession = DropboxSession.deserialize(current_user.dropbox_session)

        puts "#{dbsession.to_s}"

        # puts "LLALALAL #{dbsession.access_token.serialize} #{dbsession.request_token.serialize}"

        client = DropboxClient.new(dbsession, DROPBOX_APP_MODE) #raise an exception if session not authorized
        info = client.account_info # look up account information

        # puts " testtt #{dbsession.get_request_token} #{client.create_oauth2_access_token()}"


        if request.method != "POST"
            # show a file upload page
            render :inline =>
                "#{info['email']} <br/><%= form_tag({:action => :upload}, :multipart => true) do %><%= file_field_tag 'file' %><%= submit_tag %><% end %>"
            return
        else
            # upload the posted file to dropbox keeping the same name
            # upload it to the folder SLPAPP. If the folder doesn't exist, it will be created
            file_to_upload = "SLPAPP/#{params[:file].original_filename}"

            response = client.put_file(file_to_upload, params[:file].read)

            test = client.shares(response['path'], false)

            flash[:notice] = "#{test}"

            redirect_to root_path

        end
    end

    # private

    #     def set_user_dropbox_attr
    #         access_token_secret, access_token_token, request_token_secret, request_token_token, app_secret, app_key = str.delete("-").scan(/\S+/)
    #         current_user.update_attributes(:dropbox_session => session[:dropbox_session])
    #     end

    #     def long_share(client, path)
    #         session = DropboxOAuth2Session.new(client.create_oauth2_access_token(), nil)
    #         response = session.do_get "/shares/auto/#{client.format_path(path)}", {"short_url" => false}
    #         Dropbox::parse_response(response)
    #     end

end # end of class

