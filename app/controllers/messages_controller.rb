class MessagesController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_message, only: [:show, :edit, :update, :destroy]


  # POST /messages
  def create
    @message = conversation.messages.build(message_params)

    if @message.save
      redirect_to conversation, notice: 'Message was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      redirect_to conversation, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
    redirect_to conversations_url, notice: 'Message was successfully destroyed.'
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = conversation.messages.find(params[:id])
    end

    def conversation
      @conversation ||= Conversation.find(params[:conversation_id])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:body)
    end

end
