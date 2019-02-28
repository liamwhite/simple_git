module SimpleGit
  class Diff
    attr_accessor :ptr

    def from_trees(repo, old_tree, new_tree, options)
      wrapper = DiffWrapper.new
      SimpleGit2.git_diff_tree_to_tree(wrapper, repo.ptr, old_tree.ptr, new_tree.ptr, options.ptr)

      @ptr = wrapper[:diff]
      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))
    end

    def stats
      DiffStat.new(self)
    end

    private

    def self.finalize(ptr)
      proc { SimpleGit2.git_diff_free(ptr) }
    end

    class DiffWrapper < FFI::Struct
      layout :diff, SimpleGit2::GitDiff.by_ref
    end
  end
end
