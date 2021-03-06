module Underscore
  def self.methods(context, *methods)
    methods.map { |m| context.method(m) }
  end

  def self.compose(*functions)
    ->(*args) do
      result = functions[-1][*args]
      functions[0..-2].reverse.each do |f|
        result = f[result]
      end
      result
    end
  end

  def self.compose_right(*functions)
    compose *functions.reverse
  end

  def self.methods_compose(context, *methods)
    compose *methods(context, *methods)
  end

  def self.methods_compose_right(context, *methods)
    methods_compose(context, *(methods.reverse))
  end

  def self.dispatch(*functions)
    ->(*args) do
      functions.each do |f|
        result = f[*args]
        return result if result
      end
      nil
    end
  end

  def self.methods_dispatch(context, *methods)
    dispatch *methods(context, *methods)
  end
end

class Proc
  def *(g)
    Underscore.compose(self, g)
  end
end
