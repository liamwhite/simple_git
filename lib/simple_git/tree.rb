module SimpleGit
  class Tree
    attr_accessor :ptr
    
    def from_commit(commit)
      wrapper = TreeWrapper.new
      ret = Git2.git_commit_tree(wrapper, commit.ptr)
      if ret != 0
        error = Git2::GitError.new(Git2.giterr_last)
        raise ArgumentError, error[:message].read_string
      end

      @ptr = wrapper[:tree]
      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))

      self
    end

    private

    def self.finalize(ptr)
      proc { Git2.git_tree_free(ptr) }
    end

    class TreeWrapper < FFI::Struct
      layout :tree, Git2::GitTree.by_ref
    end
  end
end
