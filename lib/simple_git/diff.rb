module SimpleGit
  class Diff
    attr_accessor :ptr

    def from_trees(repo, old_tree, new_tree, options)
      wrapper = DiffWrapper.new
      ret = Git2.git_diff_tree_to_tree(wrapper, repo.ptr, old_tree.ptr, new_tree.ptr, options.ptr)
      if ret != 0
        error = Git2::GitError.new(Git2.giterr_last)
        raise ArgumentError, error[:message].read_string
      end

      @ptr = wrapper[:diff]
      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))

      self
    end

    def stats
      @stats ||= DiffStat.new(self)
    end

    private

    def self.finalize(ptr)
      proc { Git2.git_diff_free(ptr) }
    end

    class DiffWrapper < FFI::Struct
      layout :diff, Git2::GitDiff.by_ref
    end
  end
end
