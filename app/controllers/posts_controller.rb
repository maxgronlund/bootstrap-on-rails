class PostsController < InheritedResources::Base
  
#  def create
#    create! { posts_path}
#  end
#  
#  def update
#    update! {post_path(@post)}
#  end

  def create
     @post = Post.new(params[:post])

     if @post.save
       redirect_to @post, notice: 'Note was successfully created.'
     else
       render action: "new"
     end
   end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      redirect_to @post, notice: 'Note was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_url 
  end
end
