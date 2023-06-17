#if defined(SWIGCSHARP)
%module(directors="1") NLLamaWrap
#elif defined(SWIGJAVA)
%module(directors="1") LLamaWrap
#else
%module LLamaWrap
#endif

#if defined(SWIGPYTHON)
%feature("autodoc");
#endif

%include "stdint.i"
%include "std_string.i"
%include "std_vector.i"
%include "carrays.i"

%array_class(float, floatArray);

%extend std::vector {
  T* data(void) { return (*$self).data() ; }
  void push_back(const T&d) { return (*$self).push_back(d) ; }
  void emplace(size_t pos, T& d) {  (*$self).emplace((*$self).begin()+pos, d) ; }
  void emplace_back(T&d ) {  (*$self).emplace_back(d); }  
}


namespace std {
   %template(vectori) vector<int>;
};
 

%pragma(java) jniclasscode=%{
  /// Load the JNI library
  static {
    System.loadLibrary("llama_wrap");
  }
%}


%{
#include "llama.h"
#include "examples/common.h"  
%}

%include "llama.h"
%include "examples/common.h"

namespace std {
   %template(vectorll) vector<llama_token_data>;
};



#if defined(SWIGPYTHON)
%feature("autodoc");
#endif
