class BlankSlate
  class << self
    def hide(name)
      if instance_methods.include?(name) and
          name !~ /^(__|instance_eval)/
        @hidden_methods ||= {}
        @hidden_methods[name] = instance_method(name)
        undef_method name
      end
    end

    def find_hidden_method(name)
      @hidden_methods ||= {}
      @hidden_methods[name] || superclass.find_hidden_method(name)
    end

    def reveal(name)
      unbound_method = find_hidden_method(name)
      fail "Don't know how to reveal method '#{name}'" unless unbound_method
      define_method(name, unbound_method)
    end
  end
  instance_methods.each { |m| hide(m) }
end

require 'rspec'

describe "Blank Slate" do

  before :all do
    @bs = BlankSlate.new
  end

  specify "Call Inspect" do
    lambda{@bs.inspect}.should raise_error NoMethodError
  end

  specify "Call to_s" do
    lambda{@bs.to_s}.should raise_error NoMethodError
  end

  specify "Call Methods" do
    lambda{@bs.methods}.should raise_error NoMethodError
  end

  specify "Reveal Each Method" do
    BlankSlate.reveal :inspect
    BlankSlate.reveal :to_s
    BlankSlate.reveal :methods
  end

  specify "Call Inspect" do
    @bs.inspect
  end

  specify "Call to_s" do
    @bs.to_s
  end

  specify "Call Methods" do
    @bs.methods
  end

end

