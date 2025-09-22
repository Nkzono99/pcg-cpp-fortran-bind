#include "pcg64_wrap.hpp"
#include "pcg_random.hpp" // pcg-cpp のヘッダ（ヘッダオンリー）:contentReference[oaicite:1]{index=1}
#include <new>

struct pcg64_handle
{
  pcg64 rng;
};

pcg64_handle *pcg64_create(uint64_t seed, uint64_t seq) noexcept
{
  try
  {
    auto *h = new pcg64_handle{};
    h->rng = pcg64(seed, seq); // 64bit 出力ジェネレータ（64bit欲しいなら pcg64 を使う）:contentReference[oaicite:2]{index=2}
    return h;
  }
  catch (...)
  {
    return nullptr;
  }
}
void pcg64_destroy(pcg64_handle *h) noexcept { delete h; }

uint32_t pcg64_random_u32(pcg64_handle *h) noexcept
{
  return h ? static_cast<uint32_t>(h->rng()) : 0u;
}
double pcg64_random_double53(pcg64_handle *h) noexcept
{
  if (!h)
    return 0.0;
  uint64_t x = h->rng();                                      // 64-bit 出力
  uint64_t m = x >> 11;                                       // 上位53bit
  return static_cast<double>(m) * (1.0 / 9007199254740992.0); // 2^-53
}
void pcg64_advance(pcg64_handle *h, uint64_t delta) noexcept
{
  if (h)
    h->rng.advance(delta);
}
