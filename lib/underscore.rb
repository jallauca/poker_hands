module Underscore
  def self.compose(*functions)
    lambda do |*args|
      result = functions[-1][*args]
      functions[0..-2].reverse.each do |f|
        result = f[result]
      end
      result
    end
  end

  def self.compose_right(*functions)
    compose *(functions.reverse)
  end
end

class Proc
  def *(g)
    Underscore.compose(self, g)
  end
end
