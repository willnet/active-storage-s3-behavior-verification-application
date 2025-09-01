class DocumentsController < ApplicationController
  before_action :set_document, only: [:show]

  def index
    @documents = Document.all
  end

  def show
    @signed_url = @document.file.url
    @public_url = @document.file.url.split('?').first
    @signed_url_expires_in = @document.file.url(expires_in: 1.second)
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    
    if @document.save
      redirect_to @document, notice: 'Document was successfully created.'
    else
      render :new
    end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :file)
  end
end
