task :default do
  sh 'rspec spec'
end

desc "Prepare archive for deployment"
task :archive do
  sh 'zip -r ~/whatif.zip autoload/ doc/whatif.txt plugin/'
end
