module SimpleGit
  class Signature
    attr_accessor :ptr

    def initialize(commit)
      @ptr = Git2::GitSignature.new(Git2.git_commit_author(commit.ptr))
    end

    def name
      @name ||= @ptr[:name].read_string
    end

    def email
      @email ||= @ptr[:email].read_string
    end
  end
end
