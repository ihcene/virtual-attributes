module VirtualAttributes::Base::Casts
  extend ActiveSupport::Concern

  TYPES = ActiveRecord::Base.connection.native_database_types.keys - [:primary_key]

  def write_attribute(column, value)
    super column, cast_type(column, value)
  end

  def cast_type(column, value)
    self.class.columns[column][:castor].send(:cast_value, value)
  end

  module ClassMethods
    def column(name, type, options = {})
      raise ArgumentError unless type.to_sym.in? TYPES

      super(name, options)

      self.columns[name.to_sym][:type]   = type.to_sym,
      self.columns[name.to_sym][:castor] =
        ActiveRecord::Type.const_get(type.to_s.classify)
                          .new(options.symbolize_keys
                                      .slice(:precision, :scale, :limit))
    end
  end
end