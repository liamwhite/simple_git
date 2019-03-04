module SimpleGit
  class Commit
    attr_accessor :ptr

    def initialize(repo, oid)
      wrapper = CommitWrapper.new
      Git2.git_commit_lookup(wrapper, repo.ptr, oid.ptr)

      @repo = repo
      @oid = oid.to_s
      @ptr = wrapper[:commit]

      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))
    end

    def parent(n)
      wrapper = CommitWrapper.new
      Git2.git_commit_parent(wrapper, @ptr, n)

      c = Commit.allocate
      c.ptr = wrapper[:commit]
      ObjectSpace.define_finalizer(c, c.class.finalize(c.ptr))

      c
    end

    def parent_count
      Git2.git_commit_parentcount(@ptr)
    end

    def tree
      @tree ||= Tree.new.from_commit(self)
    end

    def author
      @author ||= Signature.new(self)
    end

    def message
      @message ||= Git2.git_commit_message(@ptr).read_string
    end

    def oid
      @oid
    end

    def diff(new_commit, options = nil)
      @diffs ||= {}
      @diffs[options] ||= Diff.new.from_trees(@repo, tree, new_commit.tree, options || DiffOptions.new)
    end

    private
    
    def self.finalize(ptr)
      proc { Git2.git_commit_free(ptr) }
    end

    class CommitWrapper < FFI::Struct
      layout :commit, Git2::GitCommit.by_ref
    end
  end
end
