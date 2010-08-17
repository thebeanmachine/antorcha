#Doet niets volgens mij

# class UserSessionsController < ApplicationController
#   def update
#     (session[:user] << params[:id].to_sym).uniq!
#     redirect_to :back
#   end
#   
#   def destroy
#     session[:user].delete(params[:id].to_sym)
#     redirect_to :back
#   end
# end
