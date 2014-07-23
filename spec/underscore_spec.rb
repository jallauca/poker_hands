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

  context "dispatch" do
    let(:k_true) { ->{  true } }
    let(:k_false) { ->{  false } }
    let(:k_nil) { ->{  nil } }
    let(:k_empty_array) { ->{  [] } }
    let(:k_array) { ->{  ["a", "b", "c"] } }
    let(:k_string) { ->{  "test" } }
    let(:k_n) { ->{ 0 } }

    it "dispatches first function that returns truthy" do
      dispatcher = Underscore.dispatch(k_true)
      expect( dispatcher[] ).to be true

      dispatcher = Underscore.dispatch(k_false, k_true)
      expect( dispatcher[] ).to be true

      dispatcher = Underscore.dispatch(k_false, k_true, k_nil)
      expect( dispatcher[] ).to be true

      dispatcher = Underscore.dispatch(k_false, k_empty_array, k_true, k_nil)
      expect( dispatcher[] ).to eq([])

      dispatcher = Underscore.dispatch(k_false, k_array, k_true)
      expect( dispatcher[] ).to eq( k_array[] )

      dispatcher = Underscore.dispatch(k_false, k_array, k_true)
      expect( dispatcher[] ).to eq( k_array[] )
    end

    it "returns nil if no function returns truthy" do
      dispatcher = Underscore.dispatch(k_false)
      expect( dispatcher[] ).to be_nil

      dispatcher = Underscore.dispatch(k_false, k_nil)
      expect( dispatcher[] ).to be_nil
    end
  end
end
