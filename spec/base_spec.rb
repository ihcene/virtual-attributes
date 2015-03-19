require 'spec_helper'

RSpec.describe VirtualAttributes::Base do
  describe "Accessors" do
    it "should define accessors" do
      klass = Class.new(VirtualAttributes::Base) do
        string :username
      end

      instance = klass.new
      expect(instance).to respond_to :username
      expect(instance).to respond_to(:'username=').with(1).argument

      instance.username = 'John'
      expect(instance.username).to eql('John')
    end

    it "should allow defining several attributes at once" do
      klass = Class.new(VirtualAttributes::Base) do
        string :firstname, :lastname
      end
      instance = klass.new

      expect(instance).to respond_to :firstname, :lastname
    end
  end

  describe "Type casts" do
    before(:each) do
      @klass = Class.new(VirtualAttributes::Base) do
        string    :username
        date      :birthdate
        boolean   :rockstar
        integer   :age
      end
      @instance = @klass.new
    end

    it "should cast dates correctly" do
      @instance.birthdate = "1963/11/22"
      expect(@instance.birthdate).to eql Date.new(1963, 11, 22)
    end

    it "should cast booleans correctly" do
      @instance.rockstar = 1
      expect(@instance.rockstar).to eql true

      @instance.rockstar = "1"
      expect(@instance.rockstar).to eql true

      @instance.rockstar = "t"
      expect(@instance.rockstar).to eql true

      @instance.rockstar = "true"
      expect(@instance.rockstar).to eql true

      @instance.rockstar = 0
      expect(@instance.rockstar).to eql false

      @instance.rockstar = "0"
      expect(@instance.rockstar).to eql false

      @instance.rockstar = "f"
      expect(@instance.rockstar).to eql false

      @instance.rockstar = "false"
      expect(@instance.rockstar).to eql false
    end

    it "should cast integer correctly" do
      @instance.age = "23"
      expect(@instance.age).to eql 23

      @instance.age = "23 apples"
      expect(@instance.age).to eql 23

      @instance.age = "I have 23 apples"
      expect(@instance.age).to eql 0

      @instance.age = 42.0
      expect(@instance.age).to eql 42

      @instance.age = BigDecimal.new('42.67')
      expect(@instance.age).to eql 42
    end

    it "should cast strings correctly" do
      @instance.username = 42
      expect(@instance.username).to eql "42"

      @instance.username = String
      expect(@instance.username).to eql "String"
    end
  end

  describe "Default values" do
    before :each do
      @klass = Class.new(VirtualAttributes::Base) do
        string    :fullname, default: "John Doe"
        string    :login, default: ->(e){  e.fullname.reverse }
        date      :birthdate, default: ->(){ raise ArgumentError }
        date      :birthdate_to_cast, default: "1963/11/22"
        boolean   :rockstar
        integer   :age
      end
      @instance = @klass.new
    end

    it "should return default value when nil" do
      expect(@instance.fullname).to eql 'John Doe'
    end

    it "should ignore default value if not nil" do
      @instance.fullname = 'Stephen King'
      expect(@instance.fullname).to_not eql 'John Doe'
      expect(@instance.fullname).to eql 'Stephen King'
    end

    it "should ignore default value even if blank" do
      @instance.fullname = ''
      expect(@instance.fullname).to_not eql 'John Doe'
    end

    it "should call default value proc" do
      expect{@instance.birthdate}.to raise_error(ArgumentError)
    end

    it "should allow passing the model to default value procs" do
      expect(@instance.login).to eql "eoD nhoJ"
    end

    it "should cast default value" do
      expect(@instance.birthdate_to_cast).to eql Date.new(1963, 11, 22)
    end
  end

  describe "Validations" do
    before :each do
      @klass = ValidationTestClass = Class.new(VirtualAttributes::Base) do
        string    :fullname, default: ""
        string    :login, default: ->(e){  e.fullname.reverse }
        date      :birthdate, default: "1963/11/22"
        boolean   :rockstar, default: false
        integer   :age

        validates_presence_of :fullname, :login, :age
      end
      @instance = @klass.new
    end

    it "should validate correctly" do
      expect(@instance.valid?).to be(false)

      expect(@instance.errors[:fullname].length).to eql 1
      expect(@instance.errors[:login].length).to eql 1
      expect(@instance.errors[:age].length).to eql 1
      expect(@instance.errors[:birthdate].length).to eql 0
    end
  end
end