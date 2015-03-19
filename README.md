# Overview

Virtual Attributes is a [Ruby gem](https://rubygems.org/profiles/aritylabs) and an ActiveRecord extension that allows you to create advanced and structered serialized attributes.

To install it, add this line to you `Gemfile` and `bundle install`.

```ruby
source 'https://rubygems.org'
    
gem 'virtual-attributes'
# ...
```

Virtual Attributes offers: 
* Built-in type cast ;
* Default values ;
* Executable default values (impossible with migrations!) ;
* Validations ;
* Migration like syntax.


# Usage

You can use it on your models exactly like a Ruby on Rails migration ! 

```ruby
class Client < ActiveRecord::Base
  serialize :contact do |t|
    t.string  :firstname, :lastname
    t.date    :birthdate,               default: Date.new(1980, 1, 1)
    t.integer :gender,                  default: 0
    t.integer :country_id
    t.string  :phone
    t.boolean :show_phone,              default: proc{ Configuration.show_phone_by_default }
  end
end
```

On your forms you can use it with `fields_for` :

```erb
<%= form_for @client do |f| %>
  <fieldset id="contact" class="">
    <legend>Contact</legend>
 
    <%= f.fields_for :contact, f.object.contact do |ff| %>
      <dl>
        <dt>Firstname  </dt><dd><%= ff.text_field :firstname %></dd>
        <dt>Lastname   </dt><dd><%= ff.text_field :lastname %></dd>
        <dt>Birthdate  </dt><dd><%= ff.date_field :birthdate %></dd>
        <dt>Gender     </dt><dd><%= ff.select :gender, [[:male, 0], [:female, 1]] %></dd>
        <dt>Country    </dt><dd><%= ff.select :country_id, [["Algeria", 1], ["France", 2]] %></dd>
        <dt>Phone      </dt><dd><%= ff.text_field :phone %></dd>
        <dt>Show phone?</dt><dd><%= ff.check_box :show_phone %></dd>
      </dl>
    <% end %>
  </fieldset>
  
  <dl>
    <dt>Company name</dt> <dd><%= f.text_field :name %></dd>
    <dt>Email</dt>        <dd><%= f.text_field :email %></dd>
  </dl>
 
  <p>
    <%= f.submit "Submit", :disable_with => 'Submiting...' %>
  </p>
<% end %>
```

And that's it! Virtual Attributes will convert the controller parameters to an instance of a dynamically created class named `Client::ContactVirtualAttributes`.
Then, it will cast, validate and do all the magic for you.

# Outside of ActiveRecord

You can use Virtual Attributes outside of ActiveRecord, by inheriting your classes from `VirtualAttributes::Base`.

```ruby
class ClientContact < VirtualAttributes::Base
  string    :fullname,  default: ""
  string    :login,     default: ->(e){  e.fullname.reverse }
  date      :birthdate, default: "1963/11/22"
  boolean   :rockstar,  default: false
  integer   :age

  validates_presence_of :fullname, :login, :age
end
```

```ruby
irb(main):011:0> a = ClientContact.new
=> #<ClientContact:0x007ff3b4078640>
irb(main):012:0> a.fullname = "John Doe"
=> "John Doe"
irb(main):013:0> a.login
=> "eoD nhoJ"
irb(main):014:0> a.birthdate
=> Fri, 22 Nov 1963
irb(main):015:0> a.rockstar
=> false
irb(main):016:0> a.valid?
=> false
irb(main):017:0> a.errors
=> #<ActiveModel::Errors:0x007ff3ab3130e8 @base=#<ClientContact:0x007ff3b4078640 @fullname="John Doe", @validation_context=nil, @errors=#<ActiveModel::Errors:0x007ff3ab3130e8 ...>>, @messages={:age=>["doit être rempli(e)"]}>
irb(main):018:0> a.errors.full_messages
=> ["Age doit être rempli(e)"]

```

However, VirtualAttributes internals rely on ActiveRecord and has it as a mandatory dependancy.

# License

Virtual Attributes is Copyright©2015 Arity Labs, inc. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.

# En français

Ce gem est produit à partir d'un tutoriel didactic en français, publié sur le [blog Arity Labs](http://www.aritylabs.com/post/110984413977/champs-virtuels-avec-activerecord-model-types).
