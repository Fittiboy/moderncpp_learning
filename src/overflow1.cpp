#include <climits>
#include <cstdio>
void f(int *ptr, int pos) {
  pos++;
  if (pos < 0)
    return;
  ptr[pos] = 0;
}
int main() {
  int *tmp = new int[10];
  f(tmp, INT_MAX);
  printf("%d\n", tmp[0]);
}
