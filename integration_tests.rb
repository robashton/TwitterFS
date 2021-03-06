require 'twitterfs'
require 'rubygems'
require 'json'
require 'twitterfspersistance'
require 'Base64'
require 'twitterpersister'

describe "Integration"  do 

  it "should be able to persist data with a different Document system" do

    persister = TwitterPersister.new

    fs = FileSystem.new persister, :isnew => true
    root = fs.root
    
    documenta = Document.new(fs, :title => "Document A", :data =>  "Some Data (a)")
    documentb = Document.new(fs, :title => "Document B", :data => "Some other data (b)")
    
    root.add_documents([documenta, documentb])
    
    dir = Directory.new(fs, nil)
    documentc = Document.new(fs, :title => "Document C", :data => "Some lovely data (c)")
    dir.add_document(documentc)
    
    root.add_directory(dir)
    
    fs.flush()
    
    fs2 = FileSystem.new persister
    
    fs2.root.documents.length.should == 2
    fs2.root.directories.length.should == 1
    fs2.root.directories[0].documents.length == 1
    fs2.root.directories[0].directories.length == 0
  end
  
  it "should be able to persist an image of an inode" do
  
    persister = TwitterPersister.new
    
    fs = FileSystem.new persister, :isnew => true
    file = Document.from_file_path(fs, 'orly.jpg')

    original = nil
    File.open('orly.jpg', 'rb') { |f| original = f.read()}
      
    fs.root.add_document(file)
    fs.flush()
    
    fs = FileSystem.new persister
    
    doc = fs.root.documents[0]
    
    doc.title.should == 'orly.jpg'
    doc.data.length.should == original.length

    File.open('test.jpg', 'wb') {|f| f.write(doc.data) }

  end
  
end

