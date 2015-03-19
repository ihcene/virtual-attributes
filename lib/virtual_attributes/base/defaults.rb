class VirtualAttributes::Base
  module Defaults
    extend ActiveSupport::Concern

    def read_attribute(column)
      super.tap do |val|
        val.nil? ? default_value(column) : val
      end
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