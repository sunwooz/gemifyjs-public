class JemWorker
  include Sidekiq::Worker
  include SidekiqStatus::Worker
  sidekiq_options retry: false

  def perform(jem_id)
    self.total = 100
    at 0
    jem = Jem.find(jem_id)
    at 5
    repository = jem.create_github_repository
    at 20
    ssh_url = jem.set_ssh_url(repository)
    at 30
    jem.create_gem_directory
    at 45
    # jem.add_collaborator(repository, "sunwooz")
    # jem.initial_push_to_github(ssh_url)
    at 85
    # jem.build_gem
    at 95
    # jem.delete_jem_from_directory
    at 100
  end

end