class SearchesController < ApplicationController
  before_action :set_search, only: [ :show]

def new
  @search=Search.new
  @tags=Tag.order(name: :asc).pluck(:name)
  @identities=Identity.order(name: :asc).pluck(:name)
end

def create
  @search=Search.create(search_params)
  redirect_to @search
end

def show
  @search=Search.find(params[:id])
  #@search=Search.paginate(page: params[:page], per_page: 5).where(id: params[:id])
  #@search=Search.where(id: params[:id]).paginate(page: params[:page], per_page: 5)
  @images=@search.search_images
end


  private

    def set_search
      @search = Search.find(params[:id])
    end

    def search_params
      params.require(:search).permit(:idwc, :id1, :id2, :tagwc, :tag1, :tag2, :tag3, :tag4, :tag5)
    end

end
