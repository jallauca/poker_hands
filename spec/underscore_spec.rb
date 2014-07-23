require File.join(File.dirname(__FILE__), '../lib', 'underscore')

describe Underscore do
  context "lambdas" do
    let(:name) { -> { "Alicia" } }
    let(:greet) { ->(name) { "Hello, #{name}!" } }
    let(:goodbye) { ->(intro) { "#{intro} Good bye!" } }
    let(:name_with_args) { ->(x) { x } }
    let(:name_with_two_args) { ->(n, ln) { "#{n} #{ln}" } }

    it "compose one function" do
      composition = Underscore.compose(name)
      expect(composition[]).to eq("Alicia")
    end

    it "compose two functions" do
      composition = Underscore.compose(greet, name)
      expect(composition[]).to eq("Hello, Alicia!")
    end

    it "compose three functions" do
      composition = Underscore.compose(goodbye, greet, name)
      expect(composition[]).to eq("Hello, Alicia! Good bye!")
    end

    it "compose right one function" do
      composition = Underscore.compose_right(name)
      expect(composition[]).to eq("Alicia")
    end

    it "compose right two functions" do
      composition = Underscore.compose_right(name, greet)
      expect(composition[]).to eq("Hello, Alicia!")
    end

    it "compose right three functions" do
      composition = Underscore.compose_right(name, greet, goodbye)
      expect(composition[]).to eq("Hello, Alicia! Good bye!")
    end

    it "compose right three functions and one arg" do
      composition = Underscore.compose_right(name_with_args, greet, goodbye)
      expect( composition[ "Francesca" ] ).to eq("Hello, Francesca! Good bye!")
    end

    it "compose right three functions and two args" do
      composition = Underscore.compose_right(name_with_two_args, greet, goodbye)
      expect( composition[ "Alicia", "Keys" ] ).to eq("Hello, Alicia Keys! Good bye!")
    end

    it "compose right three functions and one arg skipped" do
      composition = Underscore.compose_right(name_with_args, greet, goodbye)
      expect { composition[ ] }.to raise_error
    end

    it "compose right three functions and one of two args skipped" do
      composition = Underscore.compose_right(name_with_two_args, greet, goodbye)
      expect { composition[ "Alicia" ] }.to raise_error
    end
  end

  context "methods" do
    before do
      class TestObject
        def self.name() "Alicia" end
        def self.greet(name) "Hello, #{name}!" end
        def self.goodbye(intro) "#{intro} Good bye!" end
        def self.name_with_args(x) x end
        def self.name_with_two_args(n, ln) "#{n} #{ln}" end
      end
    end

    it "compose one function" do
      composition = Underscore.methods_compose(TestObject, :name)
      expect(composition[]).to eq("Alicia")
    end

    it "compose two functions" do
      composition = Underscore.methods_compose(TestObject, :greet, :name)
      expect(composition[]).to eq("Hello, Alicia!")
    end

    it "compose three functions" do
      composition = Underscore.methods_compose(TestObject, :goodbye, :greet, :name)
      expect(composition[]).to eq("Hello, Alicia! Good bye!")
    end

    it "compose right one function" do
      composition = Underscore.methods_compose_right(TestObject, :name)
      expect(composition[]).to eq("Alicia")
    end

    it "compose right two functions" do
      composition = Underscore.methods_compose_right(TestObject, :name, :greet)
      expect(composition[]).to eq("Hello, Alicia!")
    end

    it "compose right three functions" do
      composition = Underscore.methods_compose_right(TestObject, :name, :greet, :goodbye)
      expect(composition[]).to eq("Hello, Alicia! Good bye!")
    end

    it "compose right three functions and one arg" do
      composition = Underscore.methods_compose_right(TestObject, :name_with_args, :greet, :goodbye)
      expect( composition[ "Francesca" ] ).to eq("Hello, Francesca! Good bye!")
    end

    it "compose right three functions and two args" do
      composition = Underscore.methods_compose_right(TestObject, :name_with_two_args, :greet, :goodbye)
      expect( composition[ "Alicia", "Keys" ] ).to eq("Hello, Alicia Keys! Good bye!")
    end

    it "compose right three functions and one arg skipped" do
      composition = Underscore.methods_compose_right(TestObject, :name_with_args, :greet, :goodbye)
      expect { composition[ ] }.to raise_error
    end

    it "compose right three functions and one of two args skipped" do
      composition = Underscore.methods_compose_right(TestObject, :name_with_two_args, :greet, :goodbye)
      expect { composition[ "Alicia" ] }.to raise_error
    end
  end
end
