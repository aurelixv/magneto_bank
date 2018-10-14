class ApplicationController < ActionController::Base
    def hello
        render html: "Welcome to Magneto Bank"
    end 
end
