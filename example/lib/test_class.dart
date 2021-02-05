
int add(int a,int b){
  return a+b;
}

int increase(int a,int b){
  a+=1;
  return a+b;
}

///
class TestClass{
  ///
  // int increase(int a,int b){
  //   a+=1;
  //   return a+b;
  // }

  int test(){
    return increase(1, 2);
  }
}