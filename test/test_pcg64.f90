program test_pcg64
   use iso_c_binding, only: c_ptr, c_null_ptr, c_associated, c_int64_t, c_double
   use m_pcg64_bind
   implicit none

   type(c_ptr) :: h0, h1, h2
   integer :: i, n
   real(c_double) :: x, a(20), b(20), c(20)

   call assert_true(.true., "self check")

   !--- 1) Check generator creation succeeds
   h0 = pcg64_create(123456789_8, 42_8)
   call assert_true(c_associated(h0), "pcg64_create failed")

   !--- 2) Range check: verify 0 <= x < 1
   n = 100
   do i = 1, n
      x = pcg64_random_double53(h0)
      call assert_true((x >= 0.0d0) .and. (x < 1.0d0), "random out of [0,1)")
   end do

   !--- 3) Reproducibility: same seed/seq should produce identical sequence
   h1 = pcg64_create(987654321_8, 24_8)
   h2 = pcg64_create(987654321_8, 24_8)
   call assert_true(c_associated(h1) .and. c_associated(h2), "create h1/h2 failed")

   do i = 1, size(a)
      a(i) = pcg64_random_double53(h1)
      b(i) = pcg64_random_double53(h2)
   end do
   call assert_true(all(a == b), "reproducibility failed (same seed/seq differ)")

   !--- 4) Advance test
   !     Recreate h1 as the baseline sequence
   call pcg64_destroy(h1)
   h1 = pcg64_create(111_8, 7_8)
   call assert_true(c_associated(h1), "recreate h1 failed")

   !     Recreate h2 with same seed/seq, then advance by 1000 steps
   call pcg64_destroy(h2)
   h2 = pcg64_create(111_8, 7_8)
   call assert_true(c_associated(h2), "recreate h2 failed")
   call pcg64_advance(h2, int(1000, c_int64_t))

   !     Move h1 forward by 1000 steps manually
   do i = 1, 1000
      x = pcg64_random_double53(h1)
   end do

   !     Next 20 values should match between h1 and h2
   do i = 1, size(c)
      a(i) = pcg64_random_double53(h1)
      c(i) = pcg64_random_double53(h2)
   end do
   call assert_true(all(a == c), "advance failed (skip-ahead mismatch)")

   !--- Cleanup
   call pcg64_destroy(h0)
   call pcg64_destroy(h1)
   call pcg64_destroy(h2)

   print *, "OK: pcg64 Fortran binding basic tests passed."

contains

   subroutine assert_true(cond, msg)
      logical, intent(in) :: cond
      character(*), intent(in) :: msg
      if (.not. cond) then
         print *, "TEST FAILED: ", trim(msg)
         stop 1
      end if
   end subroutine assert_true

end program test_pcg64
