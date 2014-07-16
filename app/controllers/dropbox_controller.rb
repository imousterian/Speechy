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
        dbsession.get_access_token
        session[:dropbox_session] = dbsession.serialize
        current_user.update_attributes(:dropbox_session => session[:dropbox_session])
        session.delete :dropbox_session
        flash[:notice] = "You have successfully authorized with dropbox."

        redirect_to root_path

    end

    def upload
        # Check if user has no dropbox session...re-direct them to authorize
        return redirect_to(:action => 'authorize') unless session[:dropbox_session]

        dbsession = DropboxSession.deserialize(current_user.dropbox_session)
        client = DropboxClient.new(dbsession, DROPBOX_APP_MODE) #raise an exception if session not authorized
        info = client.account_info # look up account information

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

    def long_share(client, path)
        session = DropboxOAuth2Session.new(client.create_oauth2_access_token(), nil)
        response = session.do_get "/shares/auto/#{client.format_path(path)}", {"short_url" => false}
        Dropbox::parse_response(response)
    end

end # end of class

