require 'rails_helper'


feature 'Home page' do

    scenario "When user is not signed in or signed up" do

        visit root_path

        expect(page).to have_selector('h1', text: 'Welcome')

        expect(page).to_not have_title ('| Home')

        expect(page).to have_css("#sign_up_button")

        expect(page).to have_link("Sign up now!")

    end

    scenario "User signs up successfully" do

        visit root_path
        click_link "Sign up"
        expect(page).to have_title(full_title('Sign up'))

        fill_in "user_email", with: "fidel@fidel.com"
        fill_in "user_password", with: "fidelfidel"
        fill_in "user_password_confirmation", with: "fidelfidel"
        click_button "Sign up"
        expect(page).to have_text("Welcome! You have signed up successfully.")
        expect(page).to have_text("Logged in as fidel@fidel.com")

    end

    scenario "About links work" do
        visit root_path
        click_link "About"
        expect(page).to have_title(full_title('About'))
    end

    scenario "Help links work" do
        visit root_path
        click_link "Help"
        expect(page).to have_title(full_title('Help'))
    end

    scenario "Contact links work" do
        visit root_path
        click_link "Contact"
        expect(page).to have_title(full_title('Contact'))
    end


end

