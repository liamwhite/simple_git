module SimpleGit
  class Oid
    attr_accessor :ptr

    def initialize
      @ptr = Git2::GitOid.new
    end

    def to_s
      string = FFI::MemoryPointer.new(:char, 41)
      Git2.git_oid_tostr(string, 41, @ptr)
      string.read_string
    end

    def [](*args)
      to_s.[](*args)
    end
  end
end
