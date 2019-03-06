module SimpleGit
  class Reference
    attr_accessor :ptr

    def from_head(repo)
      wrapper = ReferenceWrapper.new
      ret = Git2.git_repository_head(wrapper, repo.ptr)
      if ret != 0
        error = Git2::GitError.new(Git2.giterr_last)
        raise ArgumentError, error[:message].read_string
      end

      @ptr = wrapper[:ref]
      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))

      self
    end

    def branch_name
      name_wrapper = FFI::MemoryPointer.new(:pointer)
      ret = Git2.git_branch_name(name_wrapper, @ptr)
      if ret != 0
        error = Git2::GitError.new(Git2.giterr_last)
        raise ArgumentError, error[:message].read_string
      end

      name_wrapper.read_pointer.read_string
    end

    def to_object
      wrapper = SimpleGit::Object::ObjectWrapper.new
      ret = Git2.git_reference_peel(wrapper, @ptr, :GIT_OBJ_ANY)
      if ret != 0
        error = Git2::GitError.new(Git2.giterr_last)
        raise ArgumentError, error[:message].read_string
      end

      Object.new.from_wrapper(wrapper)
    end

    private
    
    def self.finalize(ptr)
      proc { Git2.git_reference_free(ptr) }
    end

    class ReferenceWrapper < FFI::Struct
      layout :ref, Git2::GitReference.by_ref
    end
  end
end
