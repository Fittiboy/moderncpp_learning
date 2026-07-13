#include <climits>
#include <cmath>
#include <iostream>

int pow(int base, int exp) {
  int ret = 1;
  for (int i = 0; i < exp; i++) {
    if (INT_MAX / base < ret)
      return -1;
    ret *= base;
  }
  return ret;
}

int superExponential(int base, int super_exp) {
  if (super_exp == 0)
    return 0;
  int exponent = superExponential(base, super_exp - 1);
  if (exponent < 0)
    return -1;
  return pow(base, exponent);
}

int main() {
  for (int i = 0;; i++) {
    int res = superExponential(2, i);
    std::cout << "2_" << i << " = ";
    if (res < 0) {
      std::cout << "https://sites.google.com/site/largenumbers/home/appendix/a/"
                   "ulnl/265536\n";
      break;
    }
    std::cout << res << '\n';
  }

  return 0;
}
