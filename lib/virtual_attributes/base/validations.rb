module VirtualAttributes::Base::Validations
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
  end
end