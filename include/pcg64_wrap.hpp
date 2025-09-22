#pragma once
#include <cstdint>
extern "C" {
  struct pcg64_handle;
  pcg64_handle* pcg64_create(uint64_t seed, uint64_t seq) noexcept;
  void          pcg64_destroy(pcg64_handle* h) noexcept;
  uint32_t      pcg64_random_u32(pcg64_handle* h) noexcept;
  double        pcg64_random_double53(pcg64_handle* h) noexcept; // [0,1)
  void          pcg64_advance(pcg64_handle* h, uint64_t delta) noexcept;
}
