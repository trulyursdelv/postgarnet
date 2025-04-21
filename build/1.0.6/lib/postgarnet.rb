require 'net/smtp'

class FormatError < StandardError
  def initialize(msg)
    super
  end
end

class TransactionError < StandardError
  def initialize(msg)
    super
  end
end

class Postgarnet
  @@version = "1.0.6"
  
  def initialize(username: nil, password: nil)
    @username, @password, @subject, @content, @recipient, @author = @username, @smtp = nil
    unless username.nil? || password.nil?
      login(username: username, password: password)
    end
    @headers = {
      "mime-version" => "1",
      "content-type" => "text/html"
    }
  end
  
  def subject(text=nil, payload=nil)
    unless text.nil? || text.is_a?(String)
      raise FormatError, "Subject must be a string"
    end
    unless payload.nil? || payload.is_a?(Hash)
      raise FormatError, "Payload must be a hash"
    end
    if text.nil?
      return @subject
    else
      @subject = payload.nil? ? text : use_payload(payload, text)
    end
  end
  
  def content(text=nil, payload=nil)
    unless text.nil? || text.is_a?(String)
      raise FormatError, "Subject must be a string"
    end
    unless payload.nil? || payload.is_a?(Hash)
      raise FormatError, "Payload must be a hash"
    end
    if text.nil?
      return @content
    else
      @content = payload.nil? ? text : use_payload(payload, text)
    end
  end
  
  def to(recipient=nil)
    unless recipient.nil? || recipient.is_a?(String)
      raise FormatError, "Recipient (to) must be a string"
    end
    if recipient.nil?
      return @recipient
    else
      @recipient = recipient
    end
  end
  
  def from(author=nil)
    unless author.nil? || author.is_a?(String)
      raise FormatError, "Author (from) must be a string"
    end
    if author.nil?
      return @author
    else
      @author = author
    end
  end
  
  def header(key, value=nil)
    unless key.is_a?(String) || key.is_a?(Symbol)
      raise FormatError, "Header key must be a string or a symbol"
    end
    unless value.nil? || value.is_a?(String)
      raise FormatError, "Header value must be a string"
    end
    if value.nil?
      return @headers[key]
    else
      @headers[key] = value
    end
  end
  
  def headers(value=nil)
    unless value.nil? || value.is_a?(Hash)
      raise FormatError, "Header value must be a hash"
    end
    if value.nil?
      return @headers.clone
    else
      @headers = value.clone
    end
  end
  
  def connect(host: "smtp.gmail.com", port: 587)
    if @username.nil? || @password.nil?
      raise TransactionError, "You need to login first"
    end
    begin
      @smtp = Net::SMTP.new(host, port)
      @smtp.enable_starttls
      if block_given?
        block.call
      end
    rescue Exception => e
      raise TransactionError, "Error when connecting: #{e}"
    else
      true
    end
  end
  
  def login(username:, password:)
    unless @smtp.nil?
      raise TransactionError, "A connection already exists. Disconnect to the server first to login a new account."
    end
    if username.include?("@")
      username = username.split("@")[0]
    end
    @username = "#{username}@gmail.com"
    @password = password
    return @username.clone
  end
  
  def logout
    if @username.nil? && @password.nil?
      raise TransactionError, "No account to log out"
    end
    unless @smtp.nil?
      raise TransactionError, "To log out, disconnect to the server first."
    end
    @username = nil
    @password = nil
  end
  
  def disconnect
    if @smtp.nil?
      raise TransactionError, "No connection to disconnect"
    end
    @smtp = nil
  end
  
  def smtp
    if @smtp.nil?
      raise TransactionError, "Connect to the server first"
    end
    return @smtp
  end
  
  def send(client="localhost", &block)
    if [@username, @password, @author, @recipient, @subject, @content].any?(&:nil?)
      raise FormatError, "Incomplete parameters"
    end
    if @smtp.nil?
      raise TransactionError, "Connect to the server first"
    end
    begin
      message = self.create_msg
      @smtp.start(client, @username, @password, :plain) do
        @smtp.send_message(message, @username, @recipient)
        if block_given?
          block.call
        end
        true
      end
    rescue Exception => e
      raise TransactionError, "Error when sending: #{e}"
    end
  end
  
  private
  def use_payload(payload, content)
    params = payload.clone
    params.merge!({
      from: @author,
      to: @recipient,
      author: @author,
      recipient: @recipient
    })
    content.gsub(/\{(.+?)\}/) do
      params[$1.to_s] || params[$1.to_sym] || "{#{$1}}"
    end
  end
  
  def create_msg
    headers = @headers.map { |key, value| "#{key}: #{value}" }.join("\n")
    return "From: #{@author} <#{@username}>\nTo: #{@recipient} <#{@recipient}>\nSubject: #{@subject}\n#{headers}\n\n<html><body>#{@content}</body></html>"
  end
end