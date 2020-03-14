class ProviderResult<T>{
  T data; 
  bool success;
  Function next;
  ProviderResult(this.data,this.success,{this.next});

  ProviderResult.failed(){
    data=null;
    success=false;
  }
}