module VisClient
  class Redirection < StandardError
  end
  class BadRequest < StandardError
  end
  class UnauthorizedAccess < StandardError
  end
  class ResourceNotFound < StandardError
  end
  class ConnectionError < StandardError
  end
  class Conflict < StandardError
  end
end
