# namespace :scheduler do
    # desc "Delete guest users"
    task scheduler: :environment do
        puts "Delete guest users"
        User.where(guest: :true).destroy_all
    end

# end
