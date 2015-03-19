class VirtualAttributes::Base
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :columns
    end

    def initialize(attrs = {})
      attrs.each_pair do |k, v|
        send "#{k}=", v
      end
    end

    def read_attribute(column)
      instance_variable_get("@#{column}").presence
    end

    def write_attribute(column, value)
      instance_variable_set "@#{column}", value
    end

    module ClassMethods
      def column(name, options = {})
        (self.columns ||= {})[name] = {
          options:  options.with_indifferent_access
        }

        define_method name do
          read_attribute(name)
        end

        define_method :"#{name}=" do |value|
          write_attribute(name, value)
        end
      end
    end
  end
end