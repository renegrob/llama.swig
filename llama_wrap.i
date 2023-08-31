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

%extend std::vector {
  T* data(void) { return (*$self).data() ; }
  void push_back(const T&d) { return (*$self).push_back(d) ; }
  void emplace(size_t pos, T& d) {  (*$self).emplace((*$self).begin()+pos, d) ; }
  void emplace_back(T&d ) {  (*$self).emplace_back(d); }
}

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
//&ignore llama_set_state_data;
//%ignore llama_copy_state_data;
// %ignore llama_get_logits;
// %ignore llama_get_embeddings;
// %ignore llama_sample_token_mirostat;
// %ignore llama_sample_token_mirostat_v2;
// %ignore llama_sample_repetition_penalty;
// %ignore llama_sample_frequency_and_presence_penalties;

%ignore console_state;

%ignore console_state;
%ignore console_init;
%ignore console_cleanup;
%ignore console_set_color;
%ignore console_readline;
%ignore gpt_random_prompt;
%ignore gpt_params_parse;
%ignore gpt_print_usage;

// We cannot rename SWIGtypes so we substitute it
%typemap(jstype) llama_context * "LLamaContext"
%typemap(javain) llama_context * "LLamaContext.getCPtr($javainput)"
%typemap(javaout) llama_context * {
  return new LLamaContext($jnicall, $owner);
}

// ---


%apply const char **OUTPUT { const char ** strings };


%typemap(javainterfaces) SWIGTYPE "java.lang.AutoCloseable"
%typemap(javafinalize) SWIGTYPE %{
  @Override
  public void close() {
    delete();
  }
%}

// %typemap(out, fragment="convertString") std::string
// %{
//   const std::string &s = $1;
//   $result = jenv->NewString(s, strlen($s));
// %}


%nodefaultctor;


%{
  #include "llama.h"
  #include "examples/common.h"
  struct p_llama_context{};
%}

namespace std {
  %template(CStringVector) std::vector<std::string>;
  //%template(CIntVector) std::vector<int>;
  %template(CMapIntToFloat) std::unordered_map<llama_token, float>;
  %template(CTokenDataVector) vector<llama_token_data>;
}

struct p_llama_context{};

%array_functions(float, float_array);
%array_functions(char *, string_array)
%array_functions(int, int_array)
%array_functions(uint8_t, uint8_array)
%array_functions(llama_token_data *, token_data_array);

%include "llama.h"
%include "examples/common.h"

// %typemap(javacode) llama_token_data %{
//     public LLamaTokenData() {
//         this(LLamaWrap.new_llama_token_data(), true);
//     }
// %}

%inline %{
struct gpt_params new_gpt_params() {
  gpt_params params;
  return params;
}

struct llama_token_data new_llama_token_data() {
  llama_token_data data;
  return data;
}

// static uint8_t * new_uint8_array(size_t size) {
//   return new uint8_t[size]();
// }


// TODO: https://stackoverflow.com/questions/30672468/return-an-array-of-java-objects-using-swig

struct llama_token_data_array new_llama_token_data_array(size_t size, bool sorted) {
  llama_token_data_array data_array;
  data_array.data = new llama_token_data[size]();
  data_array.size = size;
  data_array.sorted = sorted;
  return data_array;
}

struct llama_token_data_array new_llama_token_data_array(llama_token_data * data, size_t size, bool sorted) {
  llama_token_data_array data_array;
  data_array.data = data;
  data_array.size = size;
  data_array.sorted = sorted;
  return data_array;
}

static void tokenDataArray_set_token_data(llama_token_data_array * token_data_array, int index, llama_token id, float logit, float p) {
    llama_token_data * token_data = token_data_array->data;
    token_data[index].id = id;
    token_data[index].logit = logit;
    token_data[index].p = p;
}

struct llama_token_data tokenDataArray_get_token_data(llama_token_data_array * token_data_array, int index) {
    llama_token_data * token_data = token_data_array->data;
    return token_data[index];
}

/* TODO: FIXME
std::vector<llama_token> llama_tokenize(struct llama_context * ctx, const std::string & text, bool add_bos) {
    // initialize to prompt numer of chars, since n_tokens <= n_prompt_chars
    std::vector<llama_token> res(text.size() + (int) add_bos);
    const int n = llama_tokenize(ctx, text.c_str(), res.data(), res.size(), add_bos);
    assert(n >= 0);
    res.resize(n);

    return res;
}
*/

%}

#if defined(SWIGPYTHON)
%feature("autodoc");
#endif
