class SearchesController < ApplicationController
  before_action :set_search, only: [ :show]

def new
  @search=Search.new
  @search.user_id = current_user.id
  @tags=Tag.order(name: :asc).pluck(:name)
  @identities=Identity.where(user_id: current_user.id).order(name: :asc).pluck(:name)
end

def create
  @search=Search.create(search_params)
  redirect_to @search
end

def show
  @search=Search.find(params[:id])
  # puts "##### Show #####"
  @search.user_id = current_user.id
   #puts "current_user.id" + current_user.id.to_s
  #@search=Search.paginate(page: params[:page], per_page: 5).where(id: params[:id])
  #@search=Search.where(id: params[:id]).paginate(page: params[:page], per_page: 5)
  @images=@search.search_images
end


  private

    def set_search
      @search = Search.find(params[:id])
    end

    def search_params
      params.require(:search).permit(:user_id,:idwc, :id1, :id2, :tagwc, :tag1, :tag2, :tag3, :tag4, :tag5)
    end

end
