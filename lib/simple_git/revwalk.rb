module SimpleGit
  class Revwalk
    include Enumerable

    attr_accessor :ptr

    def initialize(repo)
      wrapper = RevwalkWrapper.new
      SimpleGit2.git_revwalk_new(wrapper, repo.ptr)

      @ptr = wrapper[:revwalk]

      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))
    end

    def sort(sort_type)
      SimpleGit2.git_revwalk_sorting(@ptr, sort_type)
    end

    def push_head
      SimpleGit2.git_revwalk_push_head(@ptr)
    end

    def each
      oid = Oid.new

      while SimpleGit2.git_revwalk_next(oid.ptr, @ptr) == 0
        yield Commit.new(repo, oid)
      end
    end

    private

    def self.finalize(ptr)
      proc { SimpleGit2.git_revwalk_free(ptr) }
    end

    class RevwalkWrapper < FFI::Struct
      layout :revwalk, SimpleGit2::GitRevwalk.by_ref
    end
    
  end
end
