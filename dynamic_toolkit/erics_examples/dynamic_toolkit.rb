#---------------------
# The Dyanmic Toolkit
#---------------------

#------------
# Reflection
#------------

class Reflect

  @civ = "civ"
  @@cv = "cv"

  def initialize
    @iv = "iv"
  end

  def method1
    "1"
  end

  def self.method2
    "2"
  end

end

r = Reflect.new
def r.method3
  "3"
end

raise "This is wrong" unless Reflect.instance_variables.include? :@civ
raise "This is wrong" unless Reflect.class_variables.include? :@@cv
raise "This is wrong" unless Reflect.instance_methods.include? :method1
raise "This is wrong" unless Reflect.methods.include? :method2

raise "This is wrong" unless r.instance_variables.include? :@iv
raise "This is wrong" unless r.methods.include? :method1
raise "This is wrong" unless r.methods.include? :method3
raise "This is wrong" unless r.singleton_methods.include? :method3

#-----
# eval
#-----

str = "Hello"
result = eval "str + ' World!'"
raise 'This is wrong' unless result == "Hello World!"

#--------------
# instance_eval
#--------------

class Foo; end
Foo.instance_eval do
  def bar
    "bar"
  end
end

f = Foo.new
f.instance_eval do
  def baz
    "baz"
  end
end

raise 'This is wrong' unless Foo.bar == "bar"
raise 'This is wrong' unless Foo.methods.include? :bar
raise 'This is wrong' unless f.baz == "baz"
raise 'This is wrong' unless f.methods.include? :baz
raise 'This is wrong' unless f.singleton_methods.include? :baz

#-----------
# class_eval
#-----------
Foo.class_eval do
  def bar
    "Hello"
  end
end

f = Foo.new
raise 'This is wrong' unless f.bar == "Hello"
raise 'This is wrong' unless f.methods.include? :bar
raise 'This is wrong' unless Foo.instance_methods.include? :bar

#-----------
# Class.new
#-----------

Example = Class.new do

  def foo
    "Hello"
  end

end

a = Example.new

raise "This is wrong" unless a.class == Example
raise "This is wrong" unless a.foo == "Hello"

#-----------
# const_get
#-----------

module SomeMod
  class Foo; end
end

foo = SomeMod.const_get("Foo")
f = foo.new

raise "This is wrong" unless f.class == SomeMod::Foo

#-----------
# const_set
#-----------

SomeMod.const_set("Bar", Class.new do
  def something
    "Hello"
  end
end)

bar = SomeMod::Bar.new
raise "This is wrong" unless bar.something == "Hello"

#---------------
# define_method
#---------------

begin
  Example.define_method(:baz) {"Sup Bro"}
  raise "This shouldn't run"
rescue NoMethodError; end

Example.send(:define_method, :baz) {"Sup Bro"}

raise "This is wrong" unless a.baz == "Sup Bro"

#--------------
# remove_method
#--------------

class MyClass
  def my_method
    "base class"
  end
end

class MySubClass < MyClass
  def my_method
    "sub class"
  end
end

mc = MyClass.new
msc = MySubClass.new

raise 'This is wrong' unless mc.my_method == "base class"
raise 'This is wrong' unless msc.my_method == "sub class"

MySubClass.send(:remove_method, :my_method)

raise 'This is wrong' unless mc.my_method == "base class"
raise 'This is wrong' unless msc.my_method == "base class"

#-------------
# undef_method
#-------------

class MyClass
  def my_method
    "base class"
  end
end

class MySubClass < MyClass
  def my_method
    "sub class"
  end

end

mc = MyClass.new
msc = MySubClass.new

raise 'This is wrong' unless mc.my_method == "base class"
raise 'This is wrong' unless msc.my_method == "sub class"

MySubClass.send(:undef_method, :my_method)

raise 'This is wrong' unless mc.my_method == "base class"
begin
  msc.my_method
  raise "Should not run"
rescue NoMethodError; end

#---------------
# method_missing
#---------------

class RespondsToAnything
  def method_missing(sym, *args)
    "Hello"
  end
end

r = RespondsToAnything.new
raise 'This is wrong' unless r.showmethemoney == "Hello"
raise 'This is wrong' unless r.whoisjohngalt == "Hello"
raise 'This is wrong' unless r.blahblahblahblahblah == "Hello"

#------------
# metaclasses
#------------

class SomeClass; end

sc1 = SomeClass.new
def sc1.some_method
  "Yo Yo!"
end

sc2 = SomeClass.new

raise 'This is wrong' unless sc1.some_method == "Yo Yo!"

begin
  sc2.some_method
  raise 'This should not run'
rescue NoMethodError; end

#Alternatively we can write to the instances metaclass

class SomeClass
  def metaclass
    class << self
      self
    end
  end
end

sc1.metaclass.send(:define_method, :some_other_method) {"Yo Yo Again!"}

raise 'This is wrong' unless sc1.some_other_method == "Yo Yo Again!"


begin
  sc2.some_other_method
  raise 'This should not run'
rescue NoMethodError; end

#DONE!
puts "DONE!"
