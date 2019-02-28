module SimpleGit
  class Signature
    attr_accessor :ptr

    def initialize(commit)
      @ptr = SimpleGit2.git_commit_author(commit.ptr)
    end

    def name
      @ptr[:name]
    end

    def email
      @ptr[:email]
    end
  end
end
