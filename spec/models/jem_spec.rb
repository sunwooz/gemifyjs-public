require 'spec_helper'

describe Jem do

  let(:jem) { Jem.create(
    name: 'Test-gem', 
    author: 'sunwooz', 
    version_number: '1.2.3', 
    description: 'Description', 
    email: 'yangsunwoo@gmail.com', 
    summary: 'Summary here', 
    homepage: 'http://www.github.com') 
  }

  before {
    jem.delete_github_repository
  }
  
  describe "#create_gem_directory" do
    it "uses the correct gem id" do
      jem_id = jem.create_gem_directory
      jem.delete_jem_from_directory
      expect(jem_id).to eq(jem.id)
    end

    it "creates a folder in the jems_tmp directory with the folder name being the name of the jem" do
      pending
    end
  end

  describe "#set_ssh_url" do
    it "sets the correct repo url" do
      repository = jem.create_github_repository
      jem.set_ssh_url(repository)
      jem.delete_github_repository
      expect(jem.gem_repo).to eq( "http://www.github.com/gemify-js/Test-gem")
    end

    it "sets the correct ssh url" do
      repository = jem.create_github_repository
      jem.set_ssh_url(repository)
      jem.delete_github_repository
      expect(jem.ssh_url.downcase).to eq("git@github.com:gemify-js/Test-gem.git".downcase)
    end
  end

  describe "#add_collaborator" do
    it "sets the collaborator with the correct account" do
      client = jem.github_login
      repository = jem.create_github_repository
      jem.add_collaborator(repository, "sunwooz")
      expect(client.collaborators(repository)).to eq("sunwooz")
      jem.delete_github_repository
    end
  end

  # def add_collaborator(repository, collab_name=nil)
  #   client = github_login
  #   collab_name.nil? ? collab = ENV['COLLAB_NAME'] : collab = collab_name

  #   client.add_collaborator(repository.full_name, collab)
  # end

  describe "#create_github_repository" do
    it "returns the correct repository" do
      repository = jem.create_github_repository
      full_name = repository.full_name
      jem.delete_github_repository
      expect(full_name).to eq("gemify-js/#{jem.name}")
    end
  end

  describe "#find_directory" do
    it "should return the jem's directory in jems_tmp folder" do
      correct_directory = Dir.pwd + "/jems_tmp/#{jem.name}"
      correct_directory.should eq(jem.send(:find_directory))
    end
  end

end