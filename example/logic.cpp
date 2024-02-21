#include <iostream>

int main(void){
  int count;
  std::cin >> count;

  for(int i = 0; i < count; i++){
    int k_num;
    std::cin >> k_num;
    std::cout << k_num * 2 << std::endl;
  }

  return 0;
}