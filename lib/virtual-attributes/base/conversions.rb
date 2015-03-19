class VirtualAttributes::Base
  module Conversions
    extend ActiveSupport::Concern

    module ClassMethods
      def wrap(val)
        case val
        when Hash
          new(val)
        when String
          val.blank? ? new({}) : raise(ArgumentError.new("String is not convertible to #{self.name}"))
        when self
          val
        when NilClass
          new({})
        when OpenStruct
          new val.to_h
        else
          raise ArgumentError.new("#{val.class.name} is not convertible to #{self.name}")
        end
      end
    end
  end
end