module SimpleGit
  class Commit
    attr_accessor :ptr

    def initialize(repo, oid)
      wrapper = CommitWrapper.new
      SimpleGit2.git_commit_lookup(wrapper, repo.ptr, oid.ptr)

      @ptr = wrapper[:commit]
      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))
    end

    def parent(n)
      wrapper = CommitWrapper.new
      SimpleGit2.git_commit_parent(wrapper, @ptr, n)

      c = Commit.allocate
      c.ptr = wrapper[:commit]
      ObjectSpace.define_finalizer(c, c.class.finalize(c.ptr))

      c
    end

    def parent_count
      SimpleGit2.git_commit_parentcount(@ptr)
    end

    def tree
      Tree.new.from_commit(self)
    end

    def author
      Signature.new(self)
    end

    def message
      SimpleGit2.git_commit_message(@ptr).read_string
    end

    def diff(new_commit, options)
      Diff.new.from_trees(tree, new_commit.tree, options)
    end

    private
    
    def self.finalize(ptr)
      proc { SimpleGit2.git_commit_free(ptr) }
    end

    class CommitWrapper < FFI::Struct
      layout :commit, SimpleGit2::GitCommit.by_ref
    end
  end
end
