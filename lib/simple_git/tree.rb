module SimpleGit
  class Tree
    attr_accessor :ptr
    
    def from_commit(commit)
      wrapper = TreeWrapper.new
      SimpleGit2.git_commit_tree(wrapper, commit.ptr)

      @ptr = wrapper[:tree]
      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))
    end

    private

    def self.finalize(ptr)
      proc { SimpleGit2.git_tree_free(ptr) }
    end

    class TreeWrapper < FFI::Struct
      layout :tree, SimpleGit2::GitTree.by_ref
    end
  end
end
