module PgEngine
  class Error < StandardError
  end

  class BadUserInput < Error
  end

  class PageNotFoundError < Error
  end
end
