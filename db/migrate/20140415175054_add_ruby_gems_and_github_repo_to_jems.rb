class AddRubyGemsAndGithubRepoToJems < ActiveRecord::Migration
  def change
  	add_column :jems, :gem_repo, :string
  	add_column :jems, :rubygem_link, :string
  end
end
