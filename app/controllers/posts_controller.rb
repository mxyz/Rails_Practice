class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :removetag, :addtag]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @user = current_user
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  def removetag
    deletetag = Tag.find(params[:tag_id])
    @post.tags.delete(deletetag)
    redirect_to edit_post_path
  end

  def addtag
    addtag = Tag.find(params[:tag_id])
    @post.tags << addtag
    redirect_to edit_post_path
  end

  # GET /posts/1/edit
  def edit
    @allTag = Tag.all 
    @allTag = @allTag.to_a
    @post.tags.each do |tag| 
      @allTag.each do |tag2| 
        if ( tag.id == tag2.id ) 
          @allTag.delete(tag2) 
        end
      end
    end
 end

  # POST /posts
  # POST /posts.json
  def create
      @post = Post.new(post_params)
    respond_to do |format|
      if @post.user_id != current_user.id
	format.html { redirect_to @post, notice: 'Post was unsuccessfully created.' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      else

	@post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
@tag = Tag.find(4)
@post.tags << @tag
	#logger.debug 'count = ' + @post.tags.count.to_s + ' tag count = ' + temptag.posts.count.to_s
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :title, :body)
    end
end
