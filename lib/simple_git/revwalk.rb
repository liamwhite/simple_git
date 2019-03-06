module SimpleGit
  class Revwalk
    include Enumerable

    attr_accessor :ptr

    def initialize(repo)
      wrapper = RevwalkWrapper.new
      ret = Git2.git_revwalk_new(wrapper, repo.ptr)
      if ret != 0
        error = Git2::GitError.new(Git2.giterr_last)
        raise ArgumentError, error[:message].read_string
      end

      @repo = repo
      @ptr = wrapper[:revwalk]

      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))
    end

    def sort(sort_type)
      Git2.git_revwalk_sorting(@ptr, sort_type)
    end

    def push_head
      Git2.git_revwalk_push_head(@ptr)
    end

    def each
      oid = Oid.new

      while Git2.git_revwalk_next(oid.ptr, @ptr) == 0
        yield Commit.new(@repo, oid)
      end
    end

    private

    def self.finalize(ptr)
      proc { Git2.git_revwalk_free(ptr) }
    end

    class RevwalkWrapper < FFI::Struct
      layout :revwalk, Git2::GitRevwalk.by_ref
    end
    
  end
end
