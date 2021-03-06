class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :open_db
  # after_filter :close_db

  # before_filter :authenticate_user!

  helper_method :current_user
  helper_method :signed_in?

  protected

  def authenticate_user!
    redirect_to "/db/users/sign_in" if current_user.nil?
  end

  def current_user
    @_current_user ||= Db::User.find(session["warden.user.db_user.key"][1][0]) rescue nil
  end

  def signed_in?
    !current_user.nil?
  end

  def open_db
    Db::Database.init("db/dev.neodatis")


    if Db::User.all.count == 0
      Db::User.create(:email => "admin@test.com", :role => Db::RoleType.value_of("ADMIN"), :first_name => "Admin", :last_name => "Testowy", :password => "password", :password_confirmation => "password")
      Db::User.create(:email => "manager@test.com", :role => Db::RoleType.value_of("MANAGER"), :first_name => "Manager", :last_name => "Testowy", :password => "password", :password_confirmation => "password")
      Db::User.create(:email => "user@test.com", :role => Db::RoleType.value_of("NORMAL"), :first_name => "User", :last_name => "Testowy", :password => "password", :password_confirmation => "password")
    end
  end

  # def close_db
  #   Db::Database.commit
  #   Db::Database.close
  # end
end
