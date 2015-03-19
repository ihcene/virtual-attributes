require 'spec_helper'

RSpec.describe VirtualAttributes::Serialization do
  before :each do
    @klass = ValidationTestSerializeClass = Class.new(ActiveRecord::Base) do
      concerning :NoNeedDatabase do
        attr_accessor :contact

        def initialize(*)
        end

        def save(validate = true)
          validate ? valid? : true
        end

        module ClassMethods
          def columns
            @columns ||= [];
          end

          def column(name, sql_type = nil, default = nil, null = true)
            columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
              sql_type.to_s, null)
          end
        end
      end

      serialize :contact do |t|
        t.string    :fullname, default: ""
        t.string    :login, default: ->(e){  e.fullname.reverse }
        t.date      :birthdate, default: "1963/11/22"
        t.boolean   :rockstar, default: false
        t.integer   :age
      end
    end

    @instance = @klass.new
  end

  it "create a namespaced class of the right type" do
    expect(@klass).to be_const_defined(:'ContactVirtualAttributes')
    expect(@klass.const_get(:'ContactVirtualAttributes').superclass).to eql(VirtualAttributes::Base)
  end

  it "should produce instances that return the right type" do
    expect(@instance.contact).to be_a(VirtualAttributes::Base)
  end

  it "should accept open structs and hashes" do
    expect{ @instance.contact = OpenStruct.new(fullname: 'John Doe') }.to_not raise_error
    expect(@instance.contact.fullname).to eql 'John Doe'

    expect{ @instance.contact = {login: 'John Doe'} }.to_not raise_error
    expect(@instance.contact.login).to eql 'John Doe'
  end

  it "should refuses other types" do
    expect{ @instance.contact = 42 }.to raise_error(/is not convertible/)
  end
end