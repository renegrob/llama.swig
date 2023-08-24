#if defined(SWIGCSHARP)
%module(directors="1") NLLamaWrap
#elif defined(SWIGJAVA)
%module(directors="1") LLamaWrap
//%module LLamaWrap
%include "arrays_java.i"
#else
%module LLamaWrap
#endif

#if defined(SWIGPYTHON)
%feature("autodoc");
%include "carrays.i"
#endif

%include "stdint.i"
%include "enums.swg"
%include "typemaps.i"
%include "stl.i"
%include "various.i"

// %extend std::vector {
// //  T* data(void) { return (*$self).data() ; }
//   void push_back(const T&d) { return (*$self).push_back(d) ; }
// //   void emplace(size_t pos, T& d) {  (*$self).emplace((*$self).begin()+pos, d) ; }
// //   void emplace_back(T&d ) {  (*$self).emplace_back(d); }
// }

// namespace std {
//    %template(vectori) vector<int>;
// };


%pragma(java) jniclasscode=%{
  /// Load the JNI library
  static {
    System.loadLibrary("llama_wrap");
  }
%}

%apply size_t OUTPUT {size_t * n_token_count_out};
//%apply llama_context * INPUT {llama_context * ctx};
%rename("$ignore") progress_callback;
%rename("$ignore") progress_callback_user_data;
%rename("LLamaContextParams") llama_context_params;
%rename("LLamaContext") p_llama_context;
%rename("LLamaFType") llama_ftype;
%rename("LLamaTokenData") llama_token_data;
%rename("LLamaTokenDataArray") llama_token_data_array;
%rename("LLamaModelQuantizeParams") llama_model_quantize_params;

// %rename("%(camelcase)s", %$isclass) "";
// %rename("%(camelcase)s", %$isenum) "";
//%rename("%(lowercamelcase)s", %isfunction) "";


%ignore llama_get_vocab;
%ignore llama_load_session_file;
%ignore llama_save_session_file;
%ignore llama_eval;
%ignore llama_tokenize;
%ignore llama_set_state_data;
%ignore llama_copy_state_data;
%ignore llama_get_logits;
%ignore llama_get_embeddings;
%ignore llama_sample_token_mirostat;
%ignore llama_sample_token_mirostat_v2;
%ignore llama_sample_repetition_penalty;
%ignore llama_sample_frequency_and_presence_penalties;

//%typemap(jni) llama_context * "jobject"
//%typemap(jtype) llama_context * "p_llama_context"
%typemap(jstype) llama_context * "LLamaContext"
%typemap(javain) llama_context * "LLamaContext.getCPtr($javainput)"
%typemap(javaout) llama_context * {
 return new LLamaContext($jnicall, $owner);
}

%{
#include "llama.h"
//#include "examples/common.h"
typedef struct p_llama_context{};

%}

struct p_llama_context{};

%include "llama.h"
//%include "examples/common.h"

// namespace std {
//    %template(vectorll) vector<llama_token_data>;
// };



#if defined(SWIGPYTHON)
%feature("autodoc");
#endif
