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

%pragma(java) jniclasscode=%{
  /// Load the JNI library
  static {
    System.loadLibrary("llama_wrap");
  }
%}


%{
#include "llama.h"
%}

%include "llama.h"

#if defined(SWIGPYTHON)
%feature("autodoc");
#endif
