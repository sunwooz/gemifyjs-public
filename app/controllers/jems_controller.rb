class JemsController < ApplicationController

  def new
    @jem = Jem.new
  end

  def create
    @jem = Jem.new(jem_params)
    @jem.user_id = current_user.id
    repo_validation = @jem.has_repo?
    rubygems_validation = @jem.has_rubygems?

    respond_to do |format|
      if repo_validation == false && rubygems_validation == false
        if@jem.save
          track_activity(@jem, @jem, current_user)
          format.html { redirect_to @jem, notice: 'Jem was successfully created.' }
        else
          format.html { render action: 'new' }
        end
      else
        format.html { render action: 'new' }
      end
    end
  end

  def index
    @user_gems = current_user.jems
    @jems = Jem.all
    @users_count = User.all.length
    @scripts_count = Script.all.length
    @activities = Activity.all.order("created_at desc").limit(30)
    @activities_count = Activity.all.length
  end

  def show
    @script = Script.new
    @jem = Jem.find(params[:id])
    @activities = @jem.activities.all.order("created_at desc").limit(5)
  end

  def gemify_jem
    @jem = Jem.find(params[:id].to_i)
    ## checks if repo already exists
    if @jem.has_repo? == false && @jem.has_rubygems? == false
      @activity = track_activity(@jem, @jem, current_user)
      if @jem.has_files?
        @job_id = JemWorker.perform_async(@jem.id)
        respond_to do |format|
          format.js
        end
      end
    else
      respond_to do |format|
        format.js {render :partial => 'error'}
      end
    end
  end

  def gemify_updated_jem
    @jem = Jem.find(params[:id].to_i)
    @activity = track_activity(@jem, @jem, current_user)
    if @jem.has_files?
      @job_id = UpdateJemWorker.perform_async(@jem.id)
      respond_to do |format|
        format.js
      end
    end
  end

  def percentage_done
    job_id = params[:job_id]

    container = SidekiqStatus::Container.load(job_id)

    @pct_complete = container.pct_complete
    @job_message = Jem.get_message(@pct_complete)

    respond_to do |format|
      format.json { 
        render :json => {
          :percentage_done => @pct_complete,
          :job_message => @job_message
        }
      }
    end
  end

  def get_gem_repo
    jem = Jem.find(params[:jem_id].to_i)

    jem.rubygem_link = "https://rubygems.org/gems/" + jem.name
    jem.save

    @gem_repo_link = jem.gem_repo
    @rubygem_link = jem.rubygem_link

    respond_to do |format|
      format.json { 
        render :json => {
          :rubygem_link => @rubygem_link,
          :gem_repo_link => @gem_repo_link
        }
      }
    end
  end

  def update_version
    jem = Jem.find(params[:id])

    jem.version_number = params[:new_jem_version]
    jem.commit_message = params[:new_commit_message]

    @version = jem.version_number
    
    if jem.save
      @version = jem.version_number
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @jem = Jem.find(params[:id])
    if @jem.update_attributes(jem_params)
      track_activity(@jem, @jem, current_user)
      redirect_to jem_path(@jem)
    else
      render :new
    end
  end

  def edit
    @jem = Jem.find(params[:id])
  end

  def destroy
    @jem = Jem.find(params[:id])
    # @jem.delete_jem_repo if @jem.has_repo?
    # @jem.delete_jem_rubygem if @jem.has_rubygems?
    @job_id = DeleteJemWorker.perform_async(@jem.id)

    if @jem.destroy
      redirect_to jems_path
    else
      redirect_to jem_path(@jem)
    end
  end

  private

  def jem_params
    params.require(:jem).permit(:github, :name, :description, :author, :summary, :homepage, :version_number, :email)
  end
end
