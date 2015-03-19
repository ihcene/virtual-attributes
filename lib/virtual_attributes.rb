class VirtualAttributes
end

require 'virtual_attributes/base/attibutes'
require 'virtual_attributes/base/casts'
require 'virtual_attributes/base/conversions'
require 'virtual_attributes/base/defaults'
require 'virtual_attributes/base/validations'
require 'virtual_attributes/base'

require 'virtual_attributes/serialization'

ActiveRecord::Base.singleton_class.send :include, VirtualAttributes::Serialization::ClassMethods