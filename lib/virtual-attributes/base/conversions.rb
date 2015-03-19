class VirtualAttributes::Base
  module Conversions
    extend ActiveSupport::Concern

    module ClassMethods
      def wrap(val)
        case val
        when Hash
          new(val)
        when self
          val
        else
          raise ArgumentError.new("#{val.class.name} is not convertible to #{self.name}")
        end
      end
    end
  end
end