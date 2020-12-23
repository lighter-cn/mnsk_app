class CodesController < ApplicationController
  before_action :authenticate_user! # ログイン状態のチェック

  def show
    # オーナーかどうかチェック
    # 有効かどうか判定

  end

  def create
    # subとuser.id引っ張ってくる
    # ユーザーが購入済みかチェック
    # 期限内かチェック
    # 今日一度も発行していないかチェック
    # コードを発行

  end

  def update
    # 使用されたら使用済みにする
  end
end
