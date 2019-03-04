module SimpleGit
  class DiffOptions
    attr_reader :ptr

    def initialize
      @ptr = Git2::GitDiffOption.new
      @ptr[:version] = 1
    end

    def [](key)
      @ptr[key]
    end

    def []=(key, value)
      @ptr[key] = value
    end
  end
end
