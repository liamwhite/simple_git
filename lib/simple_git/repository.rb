module SimpleGit
  class Repository
    attr_accessor :ptr

    def initialize(path)
      wrapper = RepositoryWrapper.new
      SimpleGit2.git_repository_open(wrapper, path)

      @ptr = wrapper[:repo]

      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))
    end

    private
    
    def self.finalize(ptr)
      proc { SimpleGit2.git_repository_free(ptr) }
    end

    class RepositoryWrapper < FFI::Struct
      layout :repo, SimpleGit2::GitRepository.by_ref
    end
  end
end
