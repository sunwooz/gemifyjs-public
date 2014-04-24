class DeleteJemWorker
  include Sidekiq::Worker
  include SidekiqStatus::Worker
  sidekiq_options retry: false

  def perform(jem_id)
    jem = Jem.find(jem_id)
    jem.delete_jem_repo if jem.has_repo?
    jem.delete_jem_rubygem 
  end

end