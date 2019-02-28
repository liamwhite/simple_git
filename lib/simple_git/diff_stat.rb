module SimpleGit
  class DiffStat
    attr_accessor :ptr

    def initialize(diff)
      wrapper = DiffStatWrapper.new
      SimpleGit2.git_diff_get_stats(wrapper, diff.ptr)

      @ptr = wrapper[:stat]
      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))
    end

    def insertions
      SimpleGit2.git_diff_stats_insertions(@ptr)
    end

    def deletions
      SimpleGit2.git_diff_stats_deletions(@ptr)
    end

    private
    
    def self.finalize(ptr)
      proc { SimpleGit2.git_diff_stats_free(ptr) }
    end

    class DiffWrapper < FFI::Struct
      layout :stat, SimpleGit2::GitDiffStat.by_ref
    end
  end
end
