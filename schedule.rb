
#every 1.day, :at => '19:00' do
every 1.day, :at => '16:00' do
  runner 'Job.run'
end
