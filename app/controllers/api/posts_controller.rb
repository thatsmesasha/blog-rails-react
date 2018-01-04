module Api
  class PostsController < ApplicationController
    before_action :find_post, only: [:update, :show, :destroy, :tags, :likes, :comments]

    def index
      posts_per_page = 3
      posts = Post.all
      #check for tag
      if /^\w+$/ === params["tag"]
        posts = posts.joins(:tags).where({tags: {name: params["tag"]}})
      end
      #check for user
      if /^\w+$/ === params["username"]
        posts = posts.joins(:user).where({users: {name: params["username"]}})
      end
      posts = posts.order('updated_at DESC')
      #check if page is provided and is a positive number
      if /^\d+$/ === params["offset"] and params["offset"].to_i > 0
        # start from page number
        posts = posts.offset(params["offset"])
      end
      render json: posts.limit(posts_per_page)
    end

    def create
      post = Post.create(post_params)
      if post.valid?
        post.add_tags
        render json: post
      else
        render json: post.errors.messages, status: :bad_request
      end
    end

    def destroy
      @post.remove_tags
      render json: @post.destroy
    end

    def update
      if @post
        old_body = @post.body
        if @post.update_attributes(post_params)
          @post.update_tags(old_body, post_params[:body])
        else
          render json: @post.errors.messages, status: :bad_request
          return
        end
      end
      render json: @post
    end

    def show
      render json: @post
    end

    def comments
      if @post
        render json: @post.comments.order(:updated_at)
      else
        render json: nil
      end
    end

    def tags
      if @post
        render json: @post.tags
      else
        render json: nil
      end
    end

    def likes
      if @post
        render json: @post.likes
      else
        render json: nil
      end
    end

    private

    def find_post
      @post = Post.find_by(id: params[:id])
    end

    def post_params
      params.require(:post).permit(:id, :user_id, :body)
    end
  end
end
