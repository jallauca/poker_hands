require File.join(File.dirname(__FILE__), '../lib', 'underscore')

describe Underscore do
  context "lambdas" do
    let(:name) { lambda { "Alicia" } }
    let(:greet) { lambda { |name| "Hello, #{name}!" } }
    let(:goodbye) { lambda { |intro| "#{intro} Good bye!" } }
    let(:name_with_args) { lambda { |x| x } }
    let(:name_with_two_args) { lambda { |n, ln| "#{n} #{ln}" } }

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
end
