module VirtualAttributes::Serialization
  extend ActiveSupport::Concern

  module ClassMethods
    def serialize(*args, &block)
      if block_given?
        attr_name  = args.first.to_s.presence || raise(ArgumentError.new('Attr name is mandatory'))
        klass_name = "#{attr_name.classify}VirtualAttributes"

        klass = Class.new VirtualAttributes::Base
        const_set klass_name, klass

        yield const_get klass_name

        super attr_name, const_get(klass_name)

        validates attr_name, virtual_attributes: true

        define_method :"#{attr_name}=" do |val|
          super self.class.const_get(klass_name).wrap(val)
        end
      else
        super(*args)
      end
    end

    class ::VirtualAttributesValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return unless value.is_a?(VirtualAttributes::Base::Validations)

        if value.invalid?
          record.errors[attribute] << value.errors.full_messages.join('. ')
        end
      end
    end

  end
end