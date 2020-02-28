class ProviderResult{
  dynamic data; 
  bool success;
  Function next;
  ProviderResult(this.data,this.success,{this.next});
}