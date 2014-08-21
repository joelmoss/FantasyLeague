class ConversationsController < ApplicationController
  before_action :authenticate_manager!, :require_mobile!
  # before_action :new_conversation, only: [:new, :create]
  before_action :fetch_conversation, only: [:show, :edit, :update, :destroy]
  add_breadcrumb 'Messages', :conversations_path
  helper_method :setup_conversation


  # GET /conversations
  def index
    @conversations = Conversation.all
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new

    add_breadcrumb 'Creating...', new_conversation_path
  end

  # POST /conversations
  def create
    @conversation = Conversation.new(conversation_params)

    if @conversation.save
      redirect_to @conversation, notice: 'Conversation was successfully created.'
    else
      render :new
    end
  end

  def edit
    add_breadcrumb @conversation, @conversation
    add_breadcrumb 'Editing...', edit_conversation_path
  end

  # PATCH/PUT /conversations/1
  def update
    if @conversation.update(conversation_params)
      redirect_to @conversation, notice: 'Conversation was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /conversations/1
  def destroy
    @conversation.destroy
    redirect_to conversations_url, notice: 'Conversation was successfully destroyed.'
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def fetch_conversation
      @conversation = Conversation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def conversation_params
      params.require(:conversation).permit(:subject, :recipient_id, messages_attributes: [:body])
    end

    def setup_conversation(conversation)
      conversation.tap do |rec|
        rec.messages.build if rec.messages.empty?
      end
    end
end
