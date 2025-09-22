module m_pcg64_bind
  use iso_c_binding, only: c_ptr, c_null_ptr, c_int64_t, c_int32_t, c_double
  implicit none
  private
  public :: pcg64_create, pcg64_destroy, pcg64_random_u32, pcg64_random_double53, pcg64_advance

  interface
    function pcg64_create(seed, seq) result(h) bind(c, name="pcg64_create")
      import :: c_ptr, c_int64_t
      integer(c_int64_t), value :: seed, seq
      type(c_ptr) :: h
    end function
    subroutine pcg64_destroy(h) bind(c, name="pcg64_destroy")
      import :: c_ptr
      type(c_ptr), value :: h
    end subroutine
    function pcg64_random_u32(h) result(v) bind(c, name="pcg64_random_u32")
      import :: c_ptr, c_int32_t
      type(c_ptr), value :: h
      integer(c_int32_t) :: v
    end function
    function pcg64_random_double53(h) result(x) bind(c, name="pcg64_random_double53")
      import :: c_ptr, c_double
      type(c_ptr), value :: h
      real(c_double) :: x
    end function
    subroutine pcg64_advance(h, delta) bind(c, name="pcg64_advance")
      import :: c_ptr, c_int64_t
      type(c_ptr), value :: h
      integer(c_int64_t), value :: delta
    end subroutine
  end interface
end module
