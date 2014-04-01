# Put your step definitions here
Then(/^a file named "(.*?)" should exist in my current directory$/) do |filename|
  # Aruba cd's to tmp/aruba before it runs things, ugh
  path = File.join(Dir.pwd, "tmp", "aruba", filename)
  expect(File.exist?(path)).to be_true
end

Then(/^the file named "(.*?)" should contain "(.*?)"$/) do |filename, content|
  # Aruba cd's to tmp/aruba before it runs things, ugh
  path = File.join(Dir.pwd, "tmp", "aruba", filename)
  expect(File.read(path)).to include(content)
end
