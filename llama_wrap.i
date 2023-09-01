#if defined(SWIGCSHARP)
%module(directors="1") NLLamaWrap
#elif defined(SWIGJAVA)
%module(directors="1") LLamaWrap
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

%rename("$ignore") progress_callback;
%rename("$ignore") progress_callback_user_data;
%rename("LLamaContextParams") llama_context_params;
%rename("LLamaFType") llama_ftype;
%rename("LLamaTokenData") llama_token_data;
%rename("LLamaTokenDataArray") llama_token_data_array;
%rename("LLamaModelQuantizeParams") llama_model_quantize_params;
%rename("LLamaGrammarElement") llama_grammar_element;
%rename("LLamaGretType") llama_gretype;
%rename("LLamaLogLevel") llama_log_level;
%rename("LLamaTimings") llama_timings;

%typemap(javainterfaces) SWIGTYPE "java.lang.AutoCloseable"
%typemap(javafinalize) SWIGTYPE %{
  @Override
  public void close() {
    delete();
  }
%}

// --- make p_llama_context autoclosable
%typemap(javainterfaces) llama_context * "java.lang.AutoCloseable"
%typemap(javacode) llama_context * %{
  @Override
  public void close() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      LLamaWrap.llama_free(this);
      swigCPtr = 0;
    }
  }
%}
// ---


// --- Add additional constructor for LLamaTokenData
%typemap(javacode) llama_token_data %{

  public LLamaTokenData(int id, float logit, float p) {
    this(LLamaWrapJNI.new_llama_token_data(id, logit, p), true);
  }
%}
// ---


// --- Add additional constructors for LLamaTokenDataArray
%typemap(javacode) llama_token_data_array %{

  public LLamaTokenDataArray(LLamaTokenData data, int size, boolean sorted) {
    this(LLamaWrapJNI.new_llama_token_data_array(LLamaTokenData.getCPtr(data), data, size, sorted), true);
  }

  public LLamaTokenDataArray(CTokenDataVector data, boolean sorted) {
    this(LLamaWrapJNI.new_llama_token_data_array(LLamaTokenData.getCPtr(data.data()), data.data(), data.size(), sorted), true);
  }
%}
// ---

%{
  #include "llama.h"
%}

namespace std {
  %template(CStringVector) std::vector<std::string>;
  %template(CIntVector) std::vector<int>;
  %template(CMapIntToFloat) std::unordered_map<llama_token, float>;
  %template(CTokenDataVector) vector<llama_token_data>;
}

%array_functions(float, float_array);
%array_functions(char *, string_array)
%array_functions(int, int_array)
%array_functions(uint8_t, uint8_array)

%include "llama.h"


%inline %{

struct llama_token_data new_llama_token_data(llama_token id, float logit, float p) {
  llama_token_data data;
  data.id = id;
  data.logit = logit;
  data.p = p;
  return data;
}

struct llama_token_data_array new_llama_token_data_array(llama_token_data * data, size_t size, bool sorted) {
  llama_token_data_array data_array;
  data_array.data = data;
  data_array.size = size;
  data_array.sorted = sorted;
  return data_array;
}

%}


#if defined(SWIGPYTHON)
%feature("autodoc");
#endif
