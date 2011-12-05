require "builder"
class ApplicationController < ActionController::Base
  private

  # Находим пользователя с ID, хранящимся в сессии с ключем
  # :current_user_id Это обычный способ обрабатывать вход пользователя
  # в приложении на Rails; вход устанавливает значение сессии, а
  # выход убирает его.
  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by_id(session[:current_user_id])
  end

  def error(text)
    doc = Builder::XmlMarkup.new(:target => out_string = "", :indent => 1)
    doc.Error(text)

    return out_string
  end

  def ok(text)
    doc = Builder::XmlMarkup.new(:target => out_string = "", :indent => 1)
    doc.OK(text)

    return out_string
  end
end
