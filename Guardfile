guard :rspec, :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| r = "spec/lib/#{m[1]}_spec.rb"; puts r; r }
  watch('spec/spec_helper.rb')  { "spec" }
end
