class Users::PasswordsController < Devise::PasswordsController
  skip_before_filter :validate_user  
end