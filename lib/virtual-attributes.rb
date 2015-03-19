class VirtualAttributes
end

require 'virtual-attributes/base/attributes'
require 'virtual-attributes/base/casts'
require 'virtual-attributes/base/conversions'
require 'virtual-attributes/base/defaults'
require 'virtual-attributes/base/validations'
require 'virtual-attributes/base'

require 'virtual-attributes/serialization'

ActiveRecord::Base.singleton_class.send :include, VirtualAttributes::Serialization::ClassMethods