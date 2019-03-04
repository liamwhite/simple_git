module SimpleGit
  class Object
    attr_accessor :ptr

    def from_wrapper(wrapper)
      @ptr = wrapper[:object]

      ObjectSpace.define_finalizer(self, self.class.finalize(@ptr))

      self
    end

    def to_s
      oid = Oid.allocate
      oid.ptr = Git2::GitOid.new(Git2.git_object_id(@ptr))
      oid.to_s
    end

    private
    
    def self.finalize(ptr)
      proc { Git2.git_object_free(ptr) }
    end

    class ObjectWrapper < FFI::Struct
      layout :object, Git2::GitObject.by_ref
    end
  end
end
