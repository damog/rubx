require "ftools"
require "mechanize"

class Gistit < WWW::Mechanize
 
	yml = YAML.load_file("config/gist.yml")
	GIST_EMAIL = yml["gist_email"]
	GIST_PASSWORD = yml["gist_password"]

  GIST_URL = "http://gist.github.com/gists"
  LOGIN_URL = "https://gist.github.com/session"
  LOGIN_SUCCESS_URL = "http://gist.github.com/"
  LOGIN_FAIL_URL = LOGIN_URL
  
  GIST_SUCCESS_URL = Regexp.new('http://gist.github.com/(\d+)')
  GIST_FAIL_URL = "http://gist.github.com/gists/new"
  
  TYPES = [
    ["Plain Text", '.txt'],
    ["Ruby", '.rb'],
    ["Javascript", '.js'],
    ["HTML", '.html'],
    ["RHTML", '.rhtml'],
    ["XML", '.xml'],
    ["PHP", '.php'],
    ["SQL", '.sql'],
    ["Java", '.java'],
    ["Python", '.py'],
    ["Lua", '.lua'],
    ["C++", '.cpp'],
    ["Diff/Patch", '.diff'],
  ]
  
  attr_accessor :logged_in
  
  def initialize
    super
  end
  
  def self.embed_url(id)
    "http://gist.github.com/#{id}.js"
  end
  
  def paste(contents, type='.rb')
    login or return false unless self.logged_in
    post(GIST_URL, {"file_contents[gistfile1]" => contents, "file_ext[gistfile1]" => type})
    if page.uri.to_s =~ GIST_SUCCESS_URL
      gist_id = $1
    else
      false
    end
  end
  
  def delete(id)
    login or return false unless self.logged_in
    
    get("http://gist.github.com/delete/#{id}")
    if page.at("#deleted_message")
      true
    else
      false
    end
  end
  
  private
  def login(email=GIST_EMAIL, password=GIST_PASSWORD)
    @logged_in =  begin
                    post(LOGIN_URL, {"login" => email, "password" => password})
                    if page.uri.to_s == LOGIN_SUCCESS_URL
                      true
                    else
                      history.clear
                      false
                    end
                  end
  end
end

