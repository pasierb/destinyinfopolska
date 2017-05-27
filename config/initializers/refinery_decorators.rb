%w(
  app/decorators/models
  app/decorators/controllers
).each do |dir|
  Dir[File.expand_path(File.join(Rails.root, dir)) + "/**/*.rb"].each do |file|
    require file
  end
end

