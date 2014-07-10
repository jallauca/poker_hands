Gem::Specification.new do |s|
  s.name        = 'poker'
  s.version     = File.read('VERSION').chomp
  s.date        = '2014-08-28'
  s.summary     = 'Determine the poker winner'
  s.description = 'Determine the poker winner in a game of N-hands, N-cards'
  s.authors     = ["Jaime Allauca"]
  s.email       = 'jallauca@google.com'
  s.files       = ['lib/poker.rb']
  s.homepage    = 'https://github.com/jallauca/poker_hands'
  s.license       = 'MIT'
end
