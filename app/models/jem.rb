require_relative '../validators/url_validator'
require_relative '../validators/version_validator'

class Jem < ActiveRecord::Base
  has_many :scripts, dependent: :destroy
  has_many :activities, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, uniqueness: true, format: { without: /\s/ }
  # validates :github, :presence: true
  validates :author, presence: true
  validates :version_number, presence: true, version: true
  validates :description, presence: true
  validates :email, format: { with: /@/ }
  validates :summary, presence: true
  validates :github, url: true

  def create_gem_directory
    `RAILS_ENV="#{Rails.env.to_s}" rails g gemify #{self.id}`
    self.id
  end

  def create_github_repository
    client = github_login
    repository = client.create_repository(self.name, { 
      :description => self.description, 
      :homepage => self.homepage,
      :private => false,
      :has_issues => true,
      :organization => 'gemify-me',
      :has_wiki => true,
      :has_downloads => true
    })

    self.homepage = repository.html_url
    self.save

    repository
  end

  def delete_github_repository
    client = github_login
    client.delete_repository("gemify-me/#{self.name}")
  end


  def set_ssh_url(repository)
    self.gem_repo = 'http://www.github.com/gemify-me/' + self.name
    self.ssh_url = repository.ssh_url
    self.save

    self.ssh_url
  end

  def add_collaborator(repository, collab_name=nil)
    client = github_login
    collab_name.nil? ? collab = ENV['COLLAB_NAME'] : collab = collab_name
    client.add_collaborator(repository.full_name, collab)
  end

  def get_ssh_url
    client = github_login
    repository = client.repository("gemify-me/#{self.name}")

    self.ssh_url = repository.ssh_url
    self.save
    self.ssh_url
  end

  def initial_push_to_github(ssh_url)
    target = find_directory
    Dir.chdir(target) do
      `git init`
      `git add .`
      `git config --global credential.helper cache`
      `git config --global credential.helper "cache --timeout=9999"`
      `git config remote.origin.url https://gemify-js:#{ENV['HTTPS_GITHUB_PASSWORD']}@github.com/gemify-me/#{self.name}.git`
      puts `git remote -v`
      `git config --global user.email "gemifyjs@gmail.com"`
      `git config --global user.name "sunwoo yang"`

      `git commit -am "Initial Commit"`
      #`git remote add #{self.name} #{ssh_url}`
      #`git push #{self.name} master`
      `git push origin master`
      #`git remote rm #{self.name}`
      `git remote rm origin`
    end
  end

  def update_push_to_github(ssh_url)
    target = find_directory
    Dir.chdir(target) do
      `git add .`
      `git commit -am "#{self.commit_message}"`
      # `git remote add #{self.name} #{ssh_url}`
      `git push #{self.name} master`
      `git remote rm #{self.name}`
    end
  end

  def clone_remove_and_regenerate_files
    jems_tmp_folder = File.join(Rails.root.to_s, "/jems_tmp/")
    jems_tmp_gem_folder = File.join(Rails.root.to_s, "/jems_tmp/#{self.name}")

    Dir.chdir(jems_tmp_folder) do
      puts "LINE 74 PWD IS #{Dir.pwd}"
      `git clone #{self.ssh_url} #{self.name}`
      sleep(3)
    end

    Dir.chdir(jems_tmp_gem_folder) do
      puts "LINE 78 PWD IS #{Dir.pwd}"
      puts "MOVED TO #{self.name}"
      `git add .`
      `git commit -am "hi"`
      `git remote add #{self.name} #{ssh_url}`
      `git pull #{self.name} master`
      puts "PULLED"
      sleep(4)
      puts "LINE 86 PWD IS #{Dir.pwd}"
      `rm -rf lib/`
      puts "REMOVED LIB/"
      `rm -rf vendor/`
      puts "REMOVED VENDOR/"
      puts "PWD IS #{Dir.pwd}"
      puts "LINE 92 PWD IS #{Dir.pwd}"
      `rm README.md`
      `rm #{self.name}.gemspec`
      `cd ../..`
      self.create_gem_directory
    end

  end

  def build_gem
    target = find_directory
    Dir.chdir(target) do
      `gem build #{self.name}.gemspec`
      `gem push -k #{ENV["RUBYGEM_API_KEY"]} #{self.name}-#{version_number}.gem`
    end
  end

  def delete_jem_from_directory
    target = File.join(Rails.root.to_s, "/jems_tmp")
    Dir.chdir(target) do
      `rm -rf #{self.name}`
    end
  end

  def delete_jem_repo
    client = github_login
    client.delete_repository("gemify-me/#{self.name}")
  end


  def get_jem_versions
    versions = JSON.parse(Typhoeus.get("http://rubygems.org/api/v1/versions/#{self.name}.json").response_body)
    version_numbers = versions.map{|version| version["number"]}
    return version_numbers
  end

  def delete_jem_rubygem
    # `bundle exec rake yank_all_versions["#{self.name}"]`
    name = self.name
    versions = get_jem_versions
    version_numbers = versions.map{|version| version["number"]}
    version_numbers.each do |version|
      puts version
      request = Typhoeus::Request.new(
        "https://rubygems.org/api/v1/gems/yank",
        method: :delete,
        body: "this is a request body",
        params: { gem_name: "#{name}",
                  version: "#{version}"},
        headers: { Authorization: "07608ba71bc8526a4e424fba01bd04ba" }
      )
      puts name
      puts version
      request.run
    end
  end

  def has_files?
    self.scripts.empty? ? false : true
  end

  def has_repo?
    client = github_login
    result = client.repository?("gemify-me/#{self.name}")

    if result == true
      errors.add(:name, "already exists on Github")
      return result
    else
      return result
    end
  end

  def has_rubygems?
    begin
      has_gem = Gem::Specification::find_by_name(self.name)
    rescue Gem::LoadError
      has_gem = false
    end

    if has_gem == false
      return false
    else
      errors.add(:name, "already exists on Rubygems")
      return true
    end
  end

  def github_login
    Octokit::Client.new(:login => ENV["GITHUB_EMAIL"], :password => ENV["GITHUB_PASSWORD"])
  end

  def self.get_message(pct_complete)
    messages = ['Injecting Redbull Into Bloodstream...', 'Initializing Hamsters...', 'Calculating Mass of Moon...', 'Solving World Hunger...', 'Milking Goats...', 'Breeding Corgis...', 'Whipping Developers...', 'Pretending To Gemify...', 'Fermenting Cheese...', 'Asking Logan For Help...', 'Crying On Friday', 'Arel Readying Boat']
    if pct_complete == 100
      job_message = 'Gemified!'
    else
      job_message = messages[rand(0..messages.size-1)]
    end
    job_message
  end

  private
  
    def find_directory
      Rails.root.to_s + "/jems_tmp/#{self.name}"
    end

    def all_repoes
      @client.repositories
    end

    def set_default
     self.homepage = "http://gemifyjs.com" unless self.homepage
     self.github = "https://github.com/gemify-me" unless self.github
     self.email = "no@email.com" unless self.email
     self.save
   end
end
