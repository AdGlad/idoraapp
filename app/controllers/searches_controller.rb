class SearchesController < ApplicationController
  before_action :set_search, only: [ :show]

def new
  @search=Search.new
  @tags=Tag.pluck(:name)
  @identities=Identity.pluck(:name)
end

def create
  @search=Search.create(search_params)
  redirect_to @search
end

def show
  @search=Search.find(params[:id])
end


  private

    def set_search
      @search = Search.find(params[:id])
    end

    def search_params
      params.require(:search).permit(:idwc, :id1, :id2, :tagwc, :tag1, :tag2, :tag3, :tag4, :tag5)
    end

end
