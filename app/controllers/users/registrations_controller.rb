class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :validate_user
end