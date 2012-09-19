#Define a module
class_module = Object.const_get("Module")
instance_of_class_module = class_module.new
Object.const_set("MyModule", instance_of_class_module)


#Define a class
class_class = Object.const_get("Class")
instance_of_class_class = class_class.new
instance_of_class_module.const_set("MyClass", instance_of_class_class)

#Define a method
instance_of_class_class.send(:define_method, :my_method) {"Hello"}

#create an instance
instance_of_class = instance_of_class_class.new

#call it!
raise "this is wrong" unless instance_of_class.my_method == "Hello"

#We can refer to it like this as well!
a = MyModule::MyClass.new
raise "this is wrong" unless a.my_method == "Hello"

#This is the same as
module MyModule
  class MyClass
    def my_method
      "Hello"
    end
  end
end

puts "DONE!"