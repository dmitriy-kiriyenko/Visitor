require 'spec_helper'

class Unknown
end

class TestRoot
end

module TestNesting
end

module TestMixin
end

class TestDescendant < TestRoot
end

class TestDescendantWithMixin < TestRoot
  include TestMixin
end

class TestUnlistedDescendant < TestRoot
end

class TestNesting::Object < TestRoot
end

class TestNesting::UnlistedObject < TestRoot
end

class First < TestRoot
end

class Second < TestRoot
end

class TestingVisitor < Visitor::Base
  add_accept_method! :test_method, :to => [First, Second]
  add_accept_method! :test_method_singular, :to => TestRoot
  add_accept_method! :to => String
  add_accept_method! :test_default_method

  visitor_for String do |s|
    "It's a string"
  end

  visitor_for Object do |o|
    "It's an object"
  end

  visitor_for TestRoot do |o|
    "It's a test root"
  end

  visitor_for TestDescendant do |o|
    "It's a test descendant"
  end

  visitor_for TestNesting::Object do |o|
    "It's a test nested object"
  end

  visitor_for TestMixin do |o|
    "It's a test mixin"
  end

  visitor_for First, Second do |o|
    "It's one of the test pair"
  end

  visitor_for Fixnum do |x|
    x * 2
  end

  visitor_for "StillUndeclaredClass" do |o|
    "It's a still undeclared class"
  end
end

class StillUndeclaredClass
end

describe Visitor::Base do
  subject { TestingVisitor.new }

  describe "#visit" do
    it "should call correct method for core class" do
      subject.visit("hello").should == "It's a string"
    end

    it "should call correct method for object" do
      subject.visit(Object.new).should == "It's an object"
    end

    it "should call object method for unknown class" do
      subject.visit(Unknown.new).should == "It's an object"
    end

    it "should call correct method for test root class" do
      subject.visit(TestRoot.new).should == "It's a test root"
    end

    it "should call correct method for test descendant class" do
      subject.visit(TestDescendant.new).should == "It's a test descendant"
    end

    it "should call correct method for test descendant class with mixin" do
      subject.visit(TestDescendantWithMixin.new).should == "It's a test mixin"
    end

    it "should call parent method for test unlisted descentant class" do
      subject.visit(TestUnlistedDescendant.new).should == "It's a test root"
    end

    it "should call correct method for test nesting object class" do
      subject.visit(TestNesting::Object.new).should == "It's a test nested object"
    end

    it "should call parent method for test nesting unlisted object class" do
      subject.visit(TestNesting::UnlistedObject.new).should == "It's a test root"
    end

    it "should call correct method for still undeclared class using string" do
      subject.visit(StillUndeclaredClass.new).should == "It's a still undeclared class"
    end

    it "should handle several classes in declaration" do
      subject.visit(First.new).should == subject.visit(Second.new)
    end

    it "should receive an argument in a block" do
      subject.visit(5).should == 10
    end
  end

  describe ".add_accept_method!" do
    it "should add accept method with given name to given classes" do
      first, second = First.new, Second.new
      first.test_method.should == subject.visit(first)
      second.test_method.should == subject.visit(second)
    end

    it "should add accept method with given name to given class without array literal" do
      object = TestRoot.new
      object.test_method_singular.should == subject.visit(object)
    end

    it "should determine a default method name from class name" do
      string = "Hello world!"
      string.testing.should == subject.visit(string)
    end

    it "should determine a default targets as Object" do
      object = Object.new
      object.test_default_method.should == subject.visit(object)
    end
  end

end
