#if defined(SWIGCSHARP)
%module(directors="1") NLLamaWrap
#elif defined(SWIGJAVA)
%module(directors="1") LLamaWrap
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
%include "std_common.i"
%include "std_string.i"
%include <std_map.i>
%include <std_pair.i>
%include "std_unordered_map.i"
%include "various.i"
%include "swig/java/std_vector.i"
%include "carrays.i"

// %extend std::vector {
// //  T* data(void) { return (*$self).data() ; }
//   void push_back(const T&d) { return (*$self).push_back(d) ; }
// //   void emplace(size_t pos, T& d) {  (*$self).emplace((*$self).begin()+pos, d) ; }
// //   void emplace_back(T&d ) {  (*$self).emplace_back(d); }
// }

%pragma(java) jniclasscode=%{
  /// Load the JNI library
  static {
    System.loadLibrary("llama_wrap");
  }
%}

//%apply size_t OUTPUT {size_t * n_token_count_out}; // Warning 453: Can't apply (size_t OUTPUT). No typemaps are defined.
//%apply llama_context * INPUT {llama_context * ctx};
%rename("$ignore") progress_callback;
%rename("$ignore") progress_callback_user_data;
%rename("LLamaContextParams") llama_context_params;
%rename("LLamaContext") p_llama_context;
%rename("LLamaFType") llama_ftype;
%rename("LLamaTokenData") llama_token_data;
%rename("LLamaTokenDataArray") llama_token_data_array;
%rename("LLamaModelQuantizeParams") llama_model_quantize_params;

%rename("ConsoleColor") console_color_t;
%rename("GptParams") gpt_params;

// %rename("%(camelcase)s", %$isclass) "";
// %rename("%(camelcase)s", %$isenum) "";
//%rename("%(lowercamelcase)s", %isfunction) "";


//%ignore llama_get_vocab;
// %ignore llama_load_session_file;
// %ignore llama_save_session_file;
// %ignore llama_eval;
// %ignore llama_tokenize;
%ignore llama_set_state_data;
%ignore llama_copy_state_data;
// %ignore llama_get_logits;
// %ignore llama_get_embeddings;
// %ignore llama_sample_token_mirostat;
// %ignore llama_sample_token_mirostat_v2;
// %ignore llama_sample_repetition_penalty;
// %ignore llama_sample_frequency_and_presence_penalties;

%ignore console_state;
%ignore console_init;
%ignore console_cleanup;
%ignore console_set_color;
%ignore console_readline;
%ignore gpt_random_prompt;
%ignore gpt_params_parse;
%ignore gpt_print_usage;

//%typemap(jni) llama_context * "jobject"
//%typemap(jtype) llama_context * "p_llama_context"
%typemap(jstype) llama_context * "LLamaContext"
%typemap(javain) llama_context * "LLamaContext.getCPtr($javainput)"
%typemap(javaout) llama_context * {
  return new LLamaContext($jnicall, $owner);
}

// ---


%apply const char **OUTPUT { const char ** strings };
//%apply int[] { int * };

%typemap(javainterfaces) SWIGTYPE "java.io.Closeable"
%typemap(javafinalize) SWIGTYPE %{
  @Override
  public void close() {
    delete();
  }
%}


%nodefaultctor;


%{
  #include "llama.h"
  #include "examples/common.h"
  struct p_llama_context{};
%}

namespace std {
  %template(CStringVector) std::vector<std::string>;
  %template(CMapIntToFloat) std::unordered_map<llama_token, float>;
}

struct p_llama_context{};

%array_functions(float, floatArray);
%array_functions(char *, stringArray)

%include "llama.h"
%include "examples/common.h"

%inline %{
struct gpt_params new_gpt_params() {
  gpt_params params;
  return params;
}
%}

#if defined(SWIGPYTHON)
%feature("autodoc");
#endif
