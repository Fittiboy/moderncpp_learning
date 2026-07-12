#include <iostream>

using namespace std;

int main() {
  int A[3][4];

  for (int i = 0; i < 3 * 4; ++i) {
    cout << "Address of A[" << i / 4 << "][" << i % 4 << "]:\t";
    cout << &A[i / 4][i % 4] << '\n';
  }
}
