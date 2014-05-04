class AccountsController < ApplicationController
  def new
  end

  def create
    auth = env["omniauth.auth"]
    @account = Account.find_or_initialize_by(uid: auth["uid"])
    @account.username = auth["info"]["nickname"]
    @account.name = auth["info"]["name"]
    @account.token = auth["credentials"]["token"]
    @account.secret = auth["credentials"]["secret"]
    @account.save!
  end

  def update
    @account = Account.find(params[:id])
    @account.update based_on: @account.client.user(params[:account][:based_on])[:id]
    @account.delay.update_model
  end
end
