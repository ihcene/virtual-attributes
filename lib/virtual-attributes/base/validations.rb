class VirtualAttributes::Base
  module Validations
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Validations
    end
  end
end