module SessionsHelper
=begin
  def sign_in(user)
    if session[:staysignedin]
      cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    else
      session[:user_id] = user.id
    end
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end
  
  def current_user
      @current_user ||= user_from_remember_token
  end
 

  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
     
    if !cookies[:remember_token].nil?
      cookies.delete(:remember_token)
    end
    session[:user_id] = nil
    session[:staysignedin] = nil
    self.current_user = nil
  end
  
  
  private

    def user_from_remember_token
      !cookies[:remember_token].nil? ?  User.authenticate_with_salt(*remember_token):(!session[:user_id].nil? ? User.find_by_id(session[:user_id]) : nil )
   end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
=end
end
