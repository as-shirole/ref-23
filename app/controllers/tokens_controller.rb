class TokensController < ApplicationController
  before_action :set_token, only: [:show, :edit, :update, :destroy]

  # GET /tokens
  # GET /tokens.json
  def index
    @tokens = Token.all
  end

  # GET /tokens/1
  # GET /tokens/1.json
  def show
  end

  # GET /tokens/new
  def new
    @token = Token.new
  end

  # GET /tokens/1/edit
  def edit
  end

  # POST /tokens
  # POST /tokens.json
  def create
    subscription_params = params[:subscription]
    token = Token.where(web_token: subscription_params[:endpoint])
      if token.empty?
        token = Token.new
        token.web_token = subscription_params[:endpoint]
        token.p256dh = subscription_params.dig(:keys, :p256dh)
        token.auth = subscription_params.dig(:keys, :auth)
        token.last_messsage_sent_at = Date.today
        token.user_id = current_user.id.to_s unless current_user.nil?
        token.save!
        cookies.signed[:token_id] = token.id.to_s
        # render status: 204, nothing: true and return
      else
        token = token.last
        token.user_id = current_user.id.to_s unless current_user.nil?
        token.existing_record_message
        cookies.signed[:token_id] = token.last.id.to_s
        # render status: 204, nothing: true and return
      end
    respond_to do |format|
      format.html { }
      format.js { render json: {token_id: token.id.to_s}}
      format.json { render json: {token_id: token.id.to_s}}
    end
  end

  # PATCH/PUT /tokens/1
  # PATCH/PUT /tokens/1.json
  def update
    respond_to do |format|
      if @token.update(token_params)
        format.html { redirect_to @token, notice: 'Token was successfully updated.' }
        format.json { render :show, status: :ok, location: @token }
      else
        format.html { render :edit }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tokens/1
  # DELETE /tokens/1.json
  def destroy
    @token.destroy
    respond_to do |format|
      format.html { redirect_to tokens_url, notice: 'Token was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_token
      @token = Token.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def token_params
      params.require(:token).permit(:web_token)
    end
end
