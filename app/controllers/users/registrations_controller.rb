class Users::RegistrationsController < Devise::RegistrationsController
  # POST /resource
  def create
    build_resource
    puts params
    if verify_recaptcha(request.remote_ip, params)[:status] == 'false'
      @notice = "captcha incorrect"
      respond_to do |format|
      format.html { render :action => "new" }
      #format.xml  { render <img src="http://s2.wp.com/wp-includes/images/smilies/icon_mad.gif?m=1221156833g" alt=":x" class="wp-smiley"> ml => resource.errors, :status => :unprocessable_entity }
      end
    else
      if resource.save
        set_flash_message :notice, :signed_up
        sign_in_and_redirect(resource_name, resource)
      else
        clean_up_passwords(resource)
        render_with_scope :new
      end
    end
  end

end
