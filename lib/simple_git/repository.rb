module SimpleGit
  class Repository
    attr_accessor :ptr

    def initialize(path)
      wrapper = RepositoryWrapper.new
      ret = Git2.git_repository_open(wrapper, path)
      if ret != 0
        error = Git2::GitError.new(Git2.giterr_last)
        raise ArgumentError, error[:message].read_string
      end

      @ptr = wrapper[:repo]

      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))
    end

    def revparse(refspec)
      wrapper = SimpleGit::Object::ObjectWrapper.new
      Git2.git_revparse_single(wrapper, @ptr, refspec)

      Object.new.from_wrapper(wrapper)
    end

    private
    
    def self.finalize(ptr)
      proc { Git2.git_repository_free(ptr) }
    end

    class RepositoryWrapper < FFI::Struct
      layout :repo, Git2::GitRepository.by_ref
    end
  end
end
