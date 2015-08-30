require 'abcp/connection'
require 'abcp/tecdoc/manufacturer'

module Abcp
  class TecDoc
    include HTTParty
    include Abcp::Connection

    attr_accessor :user_login, :user_psw, :user_key

    base_uri 'http://tecdoc.api.abcp.ru'
    format :json

    def initialize(userlogin, userpsw, userkey)
      raise ArgumentError.new('Error! API keys not valid') if userlogin.nil? || userpsw.nil? || userkey.nil?

      @user_login = userlogin
      @user_psw = userpsw
      @user_key = userkey

      self.class.default_options.merge!(headers: { 'Content-type' => 'application/x-www-form-urlencoded',
                                                   'Accept' => 'application/json' })
    end

    def manufacturers
      request = "/manufacturers?#{user_keys}"
      data = get(request)
      Manufacturer.parse_manufacturers(data)
    end

    def models(manufacturerId)
      raise ArgumentError.new('Error! Pass valid manufacturerId') if manufacturerId.nil?

      request = "/models?manufacturerId=#{manufacturerId}&#{user_keys}"
      response = self.class.get(request)

      JSON.parse(response.body)
    end

    def modifications(manufacturerId, modelId)
      raise ArgumentError.new('Error! Pass valid modifications params') if manufacturerId.nil? || modelId.nil?

      request = "/modifications?manufacturerId=#{manufacturerId}&modelId=#{modelId}&#{user_keys}"
      response = self.class.get(request)
    end

    def tree(modificationId)
      raise ArgumentError.new('Error! Pass valid modificationId') if modificationId.nil?

      request = "/tree?modificationId=#{modificationId}&#{user_keys}"
      response = self.class.get(request)

      JSON.parse(response.body)
    end

    def articles(modificationId, categoryId)
      raise ArgumentError.new('Error! Pass valid articles params') if modificationId.nil? || categoryId.nil?

      request = "/articles?modificationId=#{modificationId}&categoryId=#{categoryId}&#{user_keys}"
      response = self.class.get(request)

      JSON.parse(response.body)
    end

    def analogs(number, type)
      raise ArgumentError.new('Error! Pass analogs of detail') if number.nil?

      request = "/analogs?number=#{number}&type=#{type}&#{user_keys}"
      response = self.class.get(request)

      JSON.parse(response.body)
    end

    def adaptability(articleId, start = 0)
      raise ArgumentError.new('Error! Pass articleId') if articleId.nil?

      request = "/adaptability?articleId=#{articleId}&start=#{start}&#{user_keys}"
      response = self.class.get(request)

      JSON.parse(response.body)
    end

    private

    def user_keys
      "userlogin=#{@user_login}&userpsw=#{@user_psw}&userkey=#{@user_key}"
    end
  end
end
