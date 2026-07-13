#include <climits>
#include <cmath>
#include <expected>
#include <iostream>

enum class TetrationError {
  overflow,
};

std::expected<int, TetrationError> pow(int base, int exp) {
  int ret = 1;
  for (int i = 0; i < exp; i++) {
    if (INT_MAX / base < ret)
      return std::unexpected(TetrationError::overflow);
    ret *= base;
  }
  return ret;
}

std::expected<int, TetrationError> tetrate(int base, int height) {
  if (height == 0)
    return 1;
  auto exponent = tetrate(base, height - 1);
  if (exponent)
    return pow(base, exponent.value());
  return exponent;
}

int main() {
  for (int i = 0;; i++) {
    std::cout << "2_" << i << " = ";
    auto res = tetrate(2, i);
    if (res) {
      std::cout << res.value() << '\n';
    } else {
      std::cout << "https://sites.google.com/site/largenumbers/home/appendix/a/"
                   "ulnl/265536\n";
      break;
    }
  }

  return 0;
}
