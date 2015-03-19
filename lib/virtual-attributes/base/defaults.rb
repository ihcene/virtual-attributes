class VirtualAttributes::Base
  module Defaults
    extend ActiveSupport::Concern

    def read_attribute(column)
      val = super
      val.nil? ? default_value(column) : val
    end

    private
      def default_value(column)
        default = self.class.columns[column][:options][:default]

        if default
          cast_type(
            column,
            default.respond_to?(:call) ? default.call : default)
        end
      end
  end
end