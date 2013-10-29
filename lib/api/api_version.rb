class ApiVersion
  def initialize(version)
    @version = version
  end

  def matches?(request)
    versioned_accept_header?(request) || version_one?(request)
  end

  private

  def versioned_accept_header?(request)
    accept = request.headers['ACCEPT']
    accept && accept[/application\/vnd\.quadroid-server-v#{@version}\+json/]
  end

  def unversioned_accept_header?(request)
    accept = request.headers['ACCEPT']
    accept.blank? || accept[/application\/vnd\.quadroid-server/].nil?
  end

  def version_one?(request)
    @version == 1 && unversioned_accept_header?(request)
  end
end