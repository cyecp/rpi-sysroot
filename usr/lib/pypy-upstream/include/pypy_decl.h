#ifndef PYPY_STANDALONE

#ifdef __cplusplus
extern "C" {
#endif

#define Signed   long           /* xxx temporary fix */

#define Unsigned unsigned long  /* xxx temporary fix */

typedef struct { PyObject_HEAD } PyMethodObject;
typedef struct { PyObject_HEAD } PyListObject;
typedef struct { PyObject_HEAD } PyLongObject;
typedef struct { PyObject_HEAD } PyDictObject;
typedef struct { PyObject_HEAD } PyTupleObject;
typedef struct { PyObject_HEAD } PyClassObject;
PyAPI_FUNC(int) PyBool_Check(PyObject *arg0);
PyAPI_FUNC(int) PyBool_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyBool_FromLong(Signed arg0);
PyAPI_FUNC(Signed) PyBuffer_FillInfo(Py_buffer *arg0, PyObject *arg1, void *arg2, Py_ssize_t arg3, Signed arg4, Signed arg5);
PyAPI_FUNC(int) PyBuffer_IsContiguous(Py_buffer *arg0, char arg1);
PyAPI_FUNC(void) PyBuffer_Release(Py_buffer *arg0);
PyAPI_FUNC(int) PyCFunction_Check(PyObject *arg0);
PyAPI_FUNC(int) PyCFunction_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyCFunction) PyCFunction_GetFunction(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyCFunction_NewEx(PyMethodDef *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyCallIter_New(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyCallable_Check(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyClassMethod_New(PyObject *arg0);
PyAPI_FUNC(int) PyClass_Check(PyObject *arg0);
PyAPI_FUNC(int) PyClass_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyClass_New(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(int) PyCode_Check(PyObject *arg0);
PyAPI_FUNC(int) PyCode_CheckExact(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) PyCode_GetNumFree(PyCodeObject *arg0);
PyAPI_FUNC(PyCodeObject *) PyCode_New(int arg0, int arg1, int arg2, int arg3, PyObject *arg4, PyObject *arg5, PyObject *arg6, PyObject *arg7, PyObject *arg8, PyObject *arg9, PyObject *arg10, PyObject *arg11, int arg12, PyObject *arg13);
PyAPI_FUNC(PyCodeObject *) PyCode_NewEmpty(const char *arg0, const char *arg1, int arg2);
PyAPI_FUNC(PyObject *) PyCodec_IncrementalDecoder(const char *arg0, const char *arg1);
PyAPI_FUNC(PyObject *) PyCodec_IncrementalEncoder(const char *arg0, const char *arg1);
PyAPI_FUNC(int) PyComplex_Check(PyObject *arg0);
PyAPI_FUNC(int) PyComplex_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyComplex_FromDoubles(double arg0, double arg1);
PyAPI_FUNC(double) PyComplex_ImagAsDouble(PyObject *arg0);
PyAPI_FUNC(double) PyComplex_RealAsDouble(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_Check(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_CheckExact(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_DATE_GET_HOUR(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_DATE_GET_MICROSECOND(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_DATE_GET_MINUTE(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_DATE_GET_SECOND(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_DELTA_GET_DAYS(PyDateTime_Delta *arg0);
PyAPI_FUNC(int) PyDateTime_DELTA_GET_MICROSECONDS(PyDateTime_Delta *arg0);
PyAPI_FUNC(int) PyDateTime_DELTA_GET_SECONDS(PyDateTime_Delta *arg0);
PyAPI_FUNC(PyObject *) PyDateTime_FromDateAndTime(int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6);
PyAPI_FUNC(PyObject *) PyDateTime_FromTimestamp(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_GET_DAY(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_GET_MONTH(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_GET_YEAR(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_TIME_GET_HOUR(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_TIME_GET_MICROSECOND(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_TIME_GET_MINUTE(PyObject *arg0);
PyAPI_FUNC(int) PyDateTime_TIME_GET_SECOND(PyObject *arg0);
PyAPI_FUNC(int) PyDate_Check(PyObject *arg0);
PyAPI_FUNC(int) PyDate_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyDate_FromDate(int arg0, int arg1, int arg2);
PyAPI_FUNC(PyObject *) PyDate_FromTimestamp(PyObject *arg0);
PyAPI_FUNC(int) PyDelta_Check(PyObject *arg0);
PyAPI_FUNC(int) PyDelta_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyDelta_FromDSU(int arg0, int arg1, int arg2);
PyAPI_FUNC(PyObject *) PyDescr_NewClassMethod(PyObject *arg0, PyMethodDef *arg1);
PyAPI_FUNC(PyObject *) PyDescr_NewMethod(PyObject *arg0, PyMethodDef *arg1);
PyAPI_FUNC(PyObject *) PyDictProxy_New(PyObject *arg0);
PyAPI_FUNC(int) PyDict_Check(PyObject *arg0);
PyAPI_FUNC(int) PyDict_CheckExact(PyObject *arg0);
PyAPI_FUNC(void) PyDict_Clear(PyObject *arg0);
PyAPI_FUNC(int) PyDict_Contains(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyDict_Copy(PyObject *arg0);
PyAPI_FUNC(int) PyDict_DelItem(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyDict_DelItemString(PyObject *arg0, char *arg1);
PyAPI_FUNC(PyObject *) PyDict_GetItem(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyDict_GetItemString(PyObject *arg0, const char *arg1);
PyAPI_FUNC(PyObject *) PyDict_Items(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyDict_Keys(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyDict_New(void);
PyAPI_FUNC(int) PyDict_Next(PyObject *arg0, Py_ssize_t *arg1, PyObject **arg2, PyObject **arg3);
PyAPI_FUNC(int) PyDict_SetItem(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(int) PyDict_SetItemString(PyObject *arg0, const char *arg1, PyObject *arg2);
PyAPI_FUNC(Py_ssize_t) PyDict_Size(PyObject *arg0);
PyAPI_FUNC(int) PyDict_Update(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyDict_Values(PyObject *arg0);
PyAPI_FUNC(int) PyErr_BadArgument(void);
PyAPI_FUNC(void) PyErr_BadInternalCall(void);
PyAPI_FUNC(int) PyErr_CheckSignals(void);
PyAPI_FUNC(void) PyErr_Clear(void);
PyAPI_FUNC(void) PyErr_Display(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(int) PyErr_ExceptionMatches(PyObject *arg0);
PyAPI_FUNC(void) PyErr_Fetch(PyObject **arg0, PyObject **arg1, PyObject **arg2);
PyAPI_FUNC(void) PyErr_GetExcInfo(PyObject **arg0, PyObject **arg1, PyObject **arg2);
PyAPI_FUNC(int) PyErr_GivenExceptionMatches(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyErr_NoMemory(void);
PyAPI_FUNC(void) PyErr_NormalizeException(PyObject **arg0, PyObject **arg1, PyObject **arg2);
PyAPI_FUNC(PyObject *) PyErr_Occurred(void);
PyAPI_FUNC(void) PyErr_Print(void);
PyAPI_FUNC(void) PyErr_PrintEx(int arg0);
PyAPI_FUNC(void) PyErr_Restore(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(void) PyErr_SetExcInfo(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyErr_SetFromErrno(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyErr_SetFromErrnoWithFilename(PyObject *arg0, char *arg1);
PyAPI_FUNC(void) PyErr_SetInterrupt(void);
PyAPI_FUNC(void) PyErr_SetNone(PyObject *arg0);
PyAPI_FUNC(void) PyErr_SetObject(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(void) PyErr_SetString(PyObject *arg0, const char *arg1);
PyAPI_FUNC(int) PyErr_Warn(PyObject *arg0, const char *arg1);
PyAPI_FUNC(int) PyErr_WarnEx(PyObject *arg0, const char *arg1, int arg2);
PyAPI_FUNC(void) PyErr_WriteUnraisable(PyObject *arg0);
PyAPI_FUNC(void) PyEval_AcquireThread(PyThreadState *arg0);
PyAPI_FUNC(PyObject *) PyEval_CallObjectWithKeywords(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyEval_EvalCode(PyCodeObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyEval_GetBuiltins(void);
PyAPI_FUNC(PyObject *) PyEval_GetGlobals(void);
PyAPI_FUNC(PyObject *) PyEval_GetLocals(void);
PyAPI_FUNC(void) PyEval_InitThreads(void);
PyAPI_FUNC(int) PyEval_MergeCompilerFlags(PyCompilerFlags *arg0);
PyAPI_FUNC(void) PyEval_ReleaseThread(PyThreadState *arg0);
PyAPI_FUNC(void) PyEval_RestoreThread(PyThreadState *arg0);
PyAPI_FUNC(PyThreadState *) PyEval_SaveThread(void);
PyAPI_FUNC(int) PyEval_ThreadsInitialized(void);
PyAPI_FUNC(PyObject *) PyExceptionInstance_Class(PyObject *arg0);
PyAPI_FUNC(FILE *) PyFile_AsFile(PyObject *arg0);
PyAPI_FUNC(int) PyFile_Check(PyObject *arg0);
PyAPI_FUNC(int) PyFile_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyFile_FromFile(FILE *arg0, const char *arg1, const char *arg2, void *arg3);
PyAPI_FUNC(PyObject *) PyFile_FromString(const char *arg0, const char *arg1);
PyAPI_FUNC(PyObject *) PyFile_GetLine(PyObject *arg0, int arg1);
PyAPI_FUNC(PyObject *) PyFile_Name(PyObject *arg0);
PyAPI_FUNC(void) PyFile_SetBufSize(PyObject *arg0, int arg1);
PyAPI_FUNC(int) PyFile_SoftSpace(PyObject *arg0, int arg1);
PyAPI_FUNC(int) PyFile_WriteObject(PyObject *arg0, PyObject *arg1, int arg2);
PyAPI_FUNC(int) PyFile_WriteString(const char *arg0, PyObject *arg1);
PyAPI_FUNC(double) PyFloat_AS_DOUBLE(PyObject *arg0);
PyAPI_FUNC(double) PyFloat_AsDouble(PyObject *arg0);
PyAPI_FUNC(int) PyFloat_Check(PyObject *arg0);
PyAPI_FUNC(int) PyFloat_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyFloat_FromDouble(double arg0);
PyAPI_FUNC(PyObject *) PyFloat_FromString(PyObject *arg0, char **arg1);
PyAPI_FUNC(PyFrameObject *) PyFrame_New(PyThreadState *arg0, PyCodeObject *arg1, PyObject *arg2, PyObject *arg3);
PyAPI_FUNC(int) PyFunction_Check(PyObject *arg0);
PyAPI_FUNC(int) PyFunction_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyFunction_GetCode(PyObject *arg0);
PyAPI_FUNC(PyGILState_STATE) PyGILState_Ensure(void);
PyAPI_FUNC(void) PyGILState_Release(PyGILState_STATE arg0);
PyAPI_FUNC(PyObject *) PyImport_AddModule(const char *arg0);
PyAPI_FUNC(PyObject *) PyImport_ExecCodeModule(char *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyImport_ExecCodeModuleEx(char *arg0, PyObject *arg1, char *arg2);
PyAPI_FUNC(PyObject *) PyImport_GetModuleDict(void);
PyAPI_FUNC(PyObject *) PyImport_Import(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyImport_ImportModule(const char *arg0);
PyAPI_FUNC(PyObject *) PyImport_ImportModuleNoBlock(const char *arg0);
PyAPI_FUNC(PyObject *) PyImport_ReloadModule(PyObject *arg0);
PyAPI_FUNC(int) PyIndex_Check(PyObject *arg0);
PyAPI_FUNC(int) PyInstance_Check(PyObject *arg0);
PyAPI_FUNC(int) PyInstance_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyInstance_New(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyInstance_NewRaw(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(Signed) PyInt_AS_LONG(PyObject *arg0);
PyAPI_FUNC(Signed) PyInt_AsLong(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) PyInt_AsSsize_t(PyObject *arg0);
PyAPI_FUNC(Unsigned) PyInt_AsUnsignedLong(PyObject *arg0);
PyAPI_FUNC(unsigned long long) PyInt_AsUnsignedLongLongMask(PyObject *arg0);
PyAPI_FUNC(Unsigned) PyInt_AsUnsignedLongMask(PyObject *arg0);
PyAPI_FUNC(int) PyInt_Check(PyObject *arg0);
PyAPI_FUNC(int) PyInt_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyInt_FromLong(Signed arg0);
PyAPI_FUNC(PyObject *) PyInt_FromSize_t(Unsigned arg0);
PyAPI_FUNC(PyObject *) PyInt_FromSsize_t(Py_ssize_t arg0);
PyAPI_FUNC(PyObject *) PyInt_FromString(const char *arg0, char **arg1, int arg2);
PyAPI_FUNC(Signed) PyInt_GetMax(void);
PyAPI_FUNC(PyInterpreterState *) PyInterpreterState_Head(void);
PyAPI_FUNC(PyInterpreterState *) PyInterpreterState_Next(PyInterpreterState *arg0);
PyAPI_FUNC(int) PyIter_Check(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyIter_Next(PyObject *arg0);
PyAPI_FUNC(int) PyList_Append(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyList_AsTuple(PyObject *arg0);
PyAPI_FUNC(int) PyList_Check(PyObject *arg0);
PyAPI_FUNC(int) PyList_CheckExact(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) PyList_GET_SIZE(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyList_GetItem(PyObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) PyList_GetSlice(PyObject *arg0, Py_ssize_t arg1, Py_ssize_t arg2);
PyAPI_FUNC(int) PyList_Insert(PyObject *arg0, Py_ssize_t arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyList_New(Py_ssize_t arg0);
PyAPI_FUNC(int) PyList_Reverse(PyObject *arg0);
PyAPI_FUNC(int) PyList_SetItem(PyObject *arg0, Py_ssize_t arg1, PyObject *arg2);
PyAPI_FUNC(int) PyList_SetSlice(PyObject *arg0, Py_ssize_t arg1, Py_ssize_t arg2, PyObject *arg3);
PyAPI_FUNC(Py_ssize_t) PyList_Size(PyObject *arg0);
PyAPI_FUNC(int) PyList_Sort(PyObject *arg0);
PyAPI_FUNC(double) PyLong_AsDouble(PyObject *arg0);
PyAPI_FUNC(Signed) PyLong_AsLong(PyObject *arg0);
PyAPI_FUNC(Signed) PyLong_AsLongAndOverflow(PyObject *arg0, int *arg1);
PyAPI_FUNC(long long) PyLong_AsLongLong(PyObject *arg0);
PyAPI_FUNC(long long) PyLong_AsLongLongAndOverflow(PyObject *arg0, int *arg1);
PyAPI_FUNC(Py_ssize_t) PyLong_AsSsize_t(PyObject *arg0);
PyAPI_FUNC(Unsigned) PyLong_AsUnsignedLong(PyObject *arg0);
PyAPI_FUNC(unsigned long long) PyLong_AsUnsignedLongLong(PyObject *arg0);
PyAPI_FUNC(unsigned long long) PyLong_AsUnsignedLongLongMask(PyObject *arg0);
PyAPI_FUNC(Unsigned) PyLong_AsUnsignedLongMask(PyObject *arg0);
PyAPI_FUNC(void *) PyLong_AsVoidPtr(PyObject *arg0);
PyAPI_FUNC(int) PyLong_Check(PyObject *arg0);
PyAPI_FUNC(int) PyLong_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyLong_FromDouble(double arg0);
PyAPI_FUNC(PyObject *) PyLong_FromLong(Signed arg0);
PyAPI_FUNC(PyObject *) PyLong_FromLongLong(long long arg0);
PyAPI_FUNC(PyObject *) PyLong_FromSize_t(Unsigned arg0);
PyAPI_FUNC(PyObject *) PyLong_FromSsize_t(Py_ssize_t arg0);
PyAPI_FUNC(PyObject *) PyLong_FromString(const char *arg0, char **arg1, int arg2);
PyAPI_FUNC(PyObject *) PyLong_FromUnsignedLong(Unsigned arg0);
PyAPI_FUNC(PyObject *) PyLong_FromUnsignedLongLong(unsigned long long arg0);
PyAPI_FUNC(PyObject *) PyLong_FromVoidPtr(void *arg0);
PyAPI_FUNC(int) PyMapping_Check(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyMapping_GetItemString(PyObject *arg0, const char *arg1);
PyAPI_FUNC(int) PyMapping_HasKey(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyMapping_HasKeyString(PyObject *arg0, const char *arg1);
PyAPI_FUNC(PyObject *) PyMapping_Items(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyMapping_Keys(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) PyMapping_Length(PyObject *arg0);
PyAPI_FUNC(int) PyMapping_SetItemString(PyObject *arg0, const char *arg1, PyObject *arg2);
PyAPI_FUNC(Py_ssize_t) PyMapping_Size(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyMapping_Values(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyMember_GetOne(PyObject *arg0, PyMemberDef *arg1);
PyAPI_FUNC(int) PyMember_SetOne(PyObject *arg0, PyMemberDef *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyMemoryView_FromObject(PyObject *arg0);
PyAPI_FUNC(int) PyMethod_Check(PyObject *arg0);
PyAPI_FUNC(int) PyMethod_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyMethod_Class(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyMethod_Function(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyMethod_New(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyMethod_Self(PyObject *arg0);
PyAPI_FUNC(int) PyModule_Check(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyModule_GetDict(PyObject *arg0);
PyAPI_FUNC(char *) PyModule_GetName(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyNumber_Absolute(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyNumber_Add(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_And(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(Py_ssize_t) PyNumber_AsSsize_t(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyNumber_Check(PyObject *arg0);
PyAPI_FUNC(int) PyNumber_Coerce(PyObject **arg0, PyObject **arg1);
PyAPI_FUNC(int) PyNumber_CoerceEx(PyObject **arg0, PyObject **arg1);
PyAPI_FUNC(PyObject *) PyNumber_Divide(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_Divmod(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_Float(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyNumber_FloorDivide(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceAdd(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceAnd(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceDivide(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceFloorDivide(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceLshift(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceMultiply(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceOr(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlacePower(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceRemainder(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceRshift(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceSubtract(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceTrueDivide(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_InPlaceXor(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_Index(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyNumber_Int(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyNumber_Invert(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyNumber_Long(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyNumber_Lshift(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_Multiply(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_Negative(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyNumber_Or(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_Positive(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyNumber_Power(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyNumber_Remainder(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_Rshift(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_Subtract(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_TrueDivide(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyNumber_Xor(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(double) PyOS_string_to_double(char *arg0, char **arg1, PyObject *arg2);
PyAPI_FUNC(int) PyObject_AsCharBuffer(PyObject *arg0, char **arg1, Py_ssize_t *arg2);
PyAPI_FUNC(int) PyObject_AsFileDescriptor(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyObject_Call(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyObject_CallObject(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyObject_CheckBuffer(PyObject *arg0);
PyAPI_FUNC(void) PyObject_ClearWeakRefs(PyObject *arg0);
PyAPI_FUNC(int) PyObject_Cmp(PyObject *arg0, PyObject *arg1, Signed *arg2);
PyAPI_FUNC(int) PyObject_Compare(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(void) PyObject_Del(void *arg0);
PyAPI_FUNC(int) PyObject_DelAttr(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyObject_DelAttrString(PyObject *arg0, const char *arg1);
PyAPI_FUNC(int) PyObject_DelItem(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyObject_Dir(PyObject *arg0);
PyAPI_FUNC(void) PyObject_FREE(void *arg0);
PyAPI_FUNC(void) PyObject_GC_Del(void *arg0);
PyAPI_FUNC(void) PyObject_GC_Track(void *arg0);
PyAPI_FUNC(void) PyObject_GC_UnTrack(void *arg0);
PyAPI_FUNC(PyObject *) PyObject_GenericGetAttr(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyObject_GenericSetAttr(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyObject_GetAttr(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyObject_GetAttrString(PyObject *arg0, const char *arg1);
PyAPI_FUNC(int) PyObject_GetBuffer(PyObject *arg0, Py_buffer *arg1, int arg2);
PyAPI_FUNC(PyObject *) PyObject_GetItem(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyObject_GetIter(PyObject *arg0);
PyAPI_FUNC(int) PyObject_HasAttr(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyObject_HasAttrString(PyObject *arg0, const char *arg1);
PyAPI_FUNC(Signed) PyObject_Hash(PyObject *arg0);
PyAPI_FUNC(Signed) PyObject_HashNotImplemented(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyObject_Init(PyObject *arg0, PyTypeObject *arg1);
PyAPI_FUNC(PyObject *) PyObject_InitVar(PyVarObject *arg0, PyTypeObject *arg1, Py_ssize_t arg2);
PyAPI_FUNC(int) PyObject_IsInstance(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyObject_IsSubclass(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyObject_IsTrue(PyObject *arg0);
PyAPI_FUNC(void *) PyObject_MALLOC(Py_ssize_t arg0);
PyAPI_FUNC(int) PyObject_Not(PyObject *arg0);
PyAPI_FUNC(int) PyObject_Print(PyObject *arg0, FILE *arg1, int arg2);
PyAPI_FUNC(PyObject *) PyObject_Repr(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyObject_RichCompare(PyObject *arg0, PyObject *arg1, int arg2);
PyAPI_FUNC(int) PyObject_RichCompareBool(PyObject *arg0, PyObject *arg1, int arg2);
PyAPI_FUNC(PyObject *) PyObject_SelfIter(PyObject *arg0);
PyAPI_FUNC(int) PyObject_SetAttr(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(int) PyObject_SetAttrString(PyObject *arg0, const char *arg1, PyObject *arg2);
PyAPI_FUNC(int) PyObject_SetItem(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(Py_ssize_t) PyObject_Size(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyObject_Str(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyObject_Type(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyObject_Unicode(PyObject *arg0);
PyAPI_FUNC(void) PyObject_dealloc(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyPy_Borrow(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyRun_File(FILE *arg0, const char *arg1, int arg2, PyObject *arg3, PyObject *arg4);
PyAPI_FUNC(int) PyRun_SimpleString(const char *arg0);
PyAPI_FUNC(PyObject *) PyRun_String(const char *arg0, int arg1, PyObject *arg2, PyObject *arg3);
PyAPI_FUNC(PyObject *) PyRun_StringFlags(char *arg0, int arg1, PyObject *arg2, PyObject *arg3, PyCompilerFlags *arg4);
PyAPI_FUNC(PyObject *) PySeqIter_New(PyObject *arg0);
PyAPI_FUNC(int) PySequence_Check(PyObject *arg0);
PyAPI_FUNC(PyObject *) PySequence_Concat(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PySequence_Contains(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PySequence_DelItem(PyObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(int) PySequence_DelSlice(PyObject *arg0, Py_ssize_t arg1, Py_ssize_t arg2);
PyAPI_FUNC(PyObject *) PySequence_Fast(PyObject *arg0, const char *arg1);
PyAPI_FUNC(PyObject *) PySequence_Fast_GET_ITEM(PyObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(Py_ssize_t) PySequence_Fast_GET_SIZE(PyObject *arg0);
PyAPI_FUNC(PyObject *) PySequence_GetItem(PyObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) PySequence_GetSlice(PyObject *arg0, Py_ssize_t arg1, Py_ssize_t arg2);
PyAPI_FUNC(PyObject *) PySequence_ITEM(PyObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(Py_ssize_t) PySequence_Index(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(Py_ssize_t) PySequence_Length(PyObject *arg0);
PyAPI_FUNC(PyObject *) PySequence_List(PyObject *arg0);
PyAPI_FUNC(PyObject *) PySequence_Repeat(PyObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(int) PySequence_SetItem(PyObject *arg0, Py_ssize_t arg1, PyObject *arg2);
PyAPI_FUNC(int) PySequence_SetSlice(PyObject *arg0, Py_ssize_t arg1, Py_ssize_t arg2, PyObject *arg3);
PyAPI_FUNC(Py_ssize_t) PySequence_Size(PyObject *arg0);
PyAPI_FUNC(PyObject *) PySequence_Tuple(PyObject *arg0);
PyAPI_FUNC(int) PySet_Add(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PySet_Check(PyObject *arg0);
PyAPI_FUNC(int) PySet_CheckExact(PyObject *arg0);
PyAPI_FUNC(int) PySet_Clear(PyObject *arg0);
PyAPI_FUNC(int) PySet_Contains(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PySet_Discard(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(Py_ssize_t) PySet_GET_SIZE(PyObject *arg0);
PyAPI_FUNC(PyObject *) PySet_New(PyObject *arg0);
PyAPI_FUNC(PyObject *) PySet_Pop(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) PySet_Size(PyObject *arg0);
PyAPI_FUNC(int) PySlice_Check(PyObject *arg0);
PyAPI_FUNC(int) PySlice_CheckExact(PyObject *arg0);
PyAPI_FUNC(int) PySlice_GetIndices(PySliceObject *arg0, Py_ssize_t arg1, Py_ssize_t *arg2, Py_ssize_t *arg3, Py_ssize_t *arg4);
PyAPI_FUNC(int) PySlice_GetIndicesEx(PySliceObject *arg0, Py_ssize_t arg1, Py_ssize_t *arg2, Py_ssize_t *arg3, Py_ssize_t *arg4, Py_ssize_t *arg5);
PyAPI_FUNC(PyObject *) PySlice_New(PyObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(PyObject *) PyStaticMethod_New(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyString_AsDecodedObject(PyObject *arg0, const char *arg1, const char *arg2);
PyAPI_FUNC(PyObject *) PyString_AsEncodedObject(PyObject *arg0, const char *arg1, const char *arg2);
PyAPI_FUNC(char *) PyString_AsString(PyObject *arg0);
PyAPI_FUNC(int) PyString_AsStringAndSize(PyObject *arg0, char **arg1, Py_ssize_t *arg2);
PyAPI_FUNC(int) PyString_Check(PyObject *arg0);
PyAPI_FUNC(int) PyString_CheckExact(PyObject *arg0);
PyAPI_FUNC(void) PyString_Concat(PyObject **arg0, PyObject *arg1);
PyAPI_FUNC(void) PyString_ConcatAndDel(PyObject **arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyString_Format(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyString_FromString(const char *arg0);
PyAPI_FUNC(PyObject *) PyString_FromStringAndSize(const char *arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) PyString_InternFromString(const char *arg0);
PyAPI_FUNC(void) PyString_InternInPlace(PyObject **arg0);
PyAPI_FUNC(Py_ssize_t) PyString_Size(PyObject *arg0);
PyAPI_FUNC(PyObject *) PySys_GetObject(const char *arg0);
PyAPI_FUNC(int) PySys_SetObject(const char *arg0, PyObject *arg1);
PyAPI_FUNC(void) PyThreadState_Clear(PyThreadState *arg0);
PyAPI_FUNC(void) PyThreadState_Delete(PyThreadState *arg0);
PyAPI_FUNC(void) PyThreadState_DeleteCurrent(void);
PyAPI_FUNC(PyThreadState *) PyThreadState_Get(void);
PyAPI_FUNC(PyObject *) PyThreadState_GetDict(void);
PyAPI_FUNC(PyThreadState *) PyThreadState_New(PyInterpreterState *arg0);
PyAPI_FUNC(PyThreadState *) PyThreadState_Swap(PyThreadState *arg0);
PyAPI_FUNC(int) PyThread_start_new_thread(void (*arg0)(void *), void *arg1);
PyAPI_FUNC(int) PyTime_Check(PyObject *arg0);
PyAPI_FUNC(int) PyTime_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyTime_FromTime(int arg0, int arg1, int arg2, int arg3);
PyAPI_FUNC(int) PyTraceBack_Check(PyObject *arg0);
PyAPI_FUNC(int) PyTraceBack_Here(PyFrameObject *arg0);
PyAPI_FUNC(int) PyTraceBack_Print(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) PyTuple_Check(PyObject *arg0);
PyAPI_FUNC(int) PyTuple_CheckExact(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) PyTuple_GET_SIZE(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyTuple_GetItem(PyObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) PyTuple_GetSlice(PyObject *arg0, Py_ssize_t arg1, Py_ssize_t arg2);
PyAPI_FUNC(PyObject *) PyTuple_New(Py_ssize_t arg0);
PyAPI_FUNC(int) PyTuple_SetItem(PyObject *arg0, Py_ssize_t arg1, PyObject *arg2);
PyAPI_FUNC(Py_ssize_t) PyTuple_Size(PyObject *arg0);
PyAPI_FUNC(int) PyType_Check(PyObject *arg0);
PyAPI_FUNC(int) PyType_CheckExact(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyType_GenericAlloc(PyTypeObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) PyType_GenericNew(PyTypeObject *arg0, PyObject *arg1, PyObject *arg2);
PyAPI_FUNC(int) PyType_IsSubtype(PyTypeObject *arg0, PyTypeObject *arg1);
PyAPI_FUNC(void) PyType_Modified(PyTypeObject *arg0);
PyAPI_FUNC(int) PyType_Ready(PyTypeObject *arg0);
PyAPI_FUNC(char *) PyUnicode_AS_DATA(PyObject *arg0);
PyAPI_FUNC(wchar_t *) PyUnicode_AS_UNICODE(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyUnicode_AsASCIIString(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyUnicode_AsEncodedObject(PyObject *arg0, const char *arg1, const char *arg2);
PyAPI_FUNC(PyObject *) PyUnicode_AsEncodedString(PyObject *arg0, const char *arg1, const char *arg2);
PyAPI_FUNC(PyObject *) PyUnicode_AsLatin1String(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyUnicode_AsUTF8String(PyObject *arg0);
PyAPI_FUNC(wchar_t *) PyUnicode_AsUnicode(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyUnicode_AsUnicodeEscapeString(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) PyUnicode_AsWideChar(PyUnicodeObject *arg0, wchar_t *arg1, Py_ssize_t arg2);
PyAPI_FUNC(int) PyUnicode_Check(PyObject *arg0);
PyAPI_FUNC(int) PyUnicode_CheckExact(PyObject *arg0);
PyAPI_FUNC(int) PyUnicode_Compare(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(Py_ssize_t) PyUnicode_Count(PyObject *arg0, PyObject *arg1, Py_ssize_t arg2, Py_ssize_t arg3);
PyAPI_FUNC(PyObject *) PyUnicode_Decode(const char *arg0, Py_ssize_t arg1, const char *arg2, const char *arg3);
PyAPI_FUNC(PyObject *) PyUnicode_DecodeASCII(const char *arg0, Py_ssize_t arg1, const char *arg2);
PyAPI_FUNC(PyObject *) PyUnicode_DecodeLatin1(const char *arg0, Py_ssize_t arg1, const char *arg2);
PyAPI_FUNC(PyObject *) PyUnicode_DecodeUTF16(char *arg0, Py_ssize_t arg1, char *arg2, Signed *arg3);
PyAPI_FUNC(PyObject *) PyUnicode_DecodeUTF32(char *arg0, Py_ssize_t arg1, char *arg2, Signed *arg3);
PyAPI_FUNC(PyObject *) PyUnicode_DecodeUTF8(const char *arg0, Py_ssize_t arg1, const char *arg2);
PyAPI_FUNC(PyObject *) PyUnicode_EncodeASCII(const wchar_t *arg0, Py_ssize_t arg1, const char *arg2);
PyAPI_FUNC(int) PyUnicode_EncodeDecimal(wchar_t *arg0, Py_ssize_t arg1, char *arg2, char *arg3);
PyAPI_FUNC(PyObject *) PyUnicode_EncodeLatin1(const wchar_t *arg0, Py_ssize_t arg1, const char *arg2);
PyAPI_FUNC(PyObject *) PyUnicode_EncodeUTF8(const wchar_t *arg0, Py_ssize_t arg1, const char *arg2);
PyAPI_FUNC(Py_ssize_t) PyUnicode_Find(PyObject *arg0, PyObject *arg1, Py_ssize_t arg2, Py_ssize_t arg3, int arg4);
PyAPI_FUNC(PyObject *) PyUnicode_Format(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyUnicode_FromEncodedObject(PyObject *arg0, const char *arg1, const char *arg2);
PyAPI_FUNC(PyObject *) PyUnicode_FromObject(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyUnicode_FromOrdinal(int arg0);
PyAPI_FUNC(PyObject *) PyUnicode_FromString(const char *arg0);
PyAPI_FUNC(PyObject *) PyUnicode_FromStringAndSize(const char *arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) PyUnicode_FromUnicode(const wchar_t *arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) PyUnicode_FromWideChar(const wchar_t *arg0, Py_ssize_t arg1);
PyAPI_FUNC(Py_ssize_t) PyUnicode_GET_DATA_SIZE(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) PyUnicode_GET_SIZE(PyObject *arg0);
PyAPI_FUNC(char *) PyUnicode_GetDefaultEncoding(void);
PyAPI_FUNC(wchar_t) PyUnicode_GetMax(void);
PyAPI_FUNC(Py_ssize_t) PyUnicode_GetSize(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyUnicode_Join(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyUnicode_Replace(PyObject *arg0, PyObject *arg1, PyObject *arg2, Py_ssize_t arg3);
PyAPI_FUNC(int) PyUnicode_Resize(PyObject **arg0, Py_ssize_t arg1);
PyAPI_FUNC(int) PyUnicode_SetDefaultEncoding(const char *arg0);
PyAPI_FUNC(PyObject *) PyUnicode_Split(PyObject *arg0, PyObject *arg1, Py_ssize_t arg2);
PyAPI_FUNC(PyObject *) PyUnicode_Splitlines(PyObject *arg0, int arg1);
PyAPI_FUNC(int) PyUnicode_Tailmatch(PyObject *arg0, PyObject *arg1, Py_ssize_t arg2, Py_ssize_t arg3, int arg4);
PyAPI_FUNC(PyObject *) PyWeakref_GET_OBJECT(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyWeakref_GetObject(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyWeakref_LockObject(PyObject *arg0);
PyAPI_FUNC(PyObject *) PyWeakref_NewProxy(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) PyWeakref_NewRef(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) Py_AddPendingCall(int (*arg0)(void *), void *arg1);
PyAPI_FUNC(int) Py_AtExit(void (*arg0)(void));
PyAPI_FUNC(PyObject *) Py_CompileStringFlags(char *arg0, char *arg1, int arg2, PyCompilerFlags *arg3);
PyAPI_FUNC(void) Py_DecRef(PyObject *arg0);
PyAPI_FUNC(PyObject *) Py_FindMethod(PyMethodDef *arg0, PyObject *arg1, const char *arg2);
PyAPI_FUNC(char *) Py_GetProgramName(void);
PyAPI_FUNC(char *) Py_GetVersion(void);
PyAPI_FUNC(void) Py_IncRef(PyObject *arg0);
PyAPI_FUNC(int) Py_IsInitialized(void);
PyAPI_FUNC(int) Py_MakePendingCalls(void);
PyAPI_FUNC(void) Py_UNICODE_COPY(wchar_t *arg0, wchar_t *arg1, Py_ssize_t arg2);
PyAPI_FUNC(int) Py_UNICODE_ISALNUM(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_ISALPHA(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_ISDECIMAL(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_ISDIGIT(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_ISLINEBREAK(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_ISLOWER(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_ISNUMERIC(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_ISSPACE(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_ISTITLE(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_ISUPPER(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_TODECIMAL(wchar_t arg0);
PyAPI_FUNC(int) Py_UNICODE_TODIGIT(wchar_t arg0);
PyAPI_FUNC(wchar_t) Py_UNICODE_TOLOWER(wchar_t arg0);
PyAPI_FUNC(double) Py_UNICODE_TONUMERIC(wchar_t arg0);
PyAPI_FUNC(wchar_t) Py_UNICODE_TOTITLE(wchar_t arg0);
PyAPI_FUNC(wchar_t) Py_UNICODE_TOUPPER(wchar_t arg0);
PyAPI_FUNC(int) _PyArray_Check(PyObject *arg0);
PyAPI_FUNC(int) _PyArray_CheckExact(PyObject *arg0);
PyAPI_FUNC(void *) _PyArray_DATA(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) _PyArray_DIM(PyObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) _PyArray_DescrFromType(Py_ssize_t arg0);
PyAPI_FUNC(int) _PyArray_FLAGS(PyObject *arg0);
PyAPI_FUNC(PyObject *) _PyArray_FromAny(PyObject *arg0, PyObject *arg1, Py_ssize_t arg2, Py_ssize_t arg3, Py_ssize_t arg4, void *arg5);
PyAPI_FUNC(PyObject *) _PyArray_FromObject(PyObject *arg0, Py_ssize_t arg1, Py_ssize_t arg2, Py_ssize_t arg3);
PyAPI_FUNC(int) _PyArray_ITEMSIZE(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) _PyArray_NBYTES(PyObject *arg0);
PyAPI_FUNC(int) _PyArray_NDIM(PyObject *arg0);
PyAPI_FUNC(PyObject *) _PyArray_New(void *arg0, Py_ssize_t arg1, Signed *arg2, Py_ssize_t arg3, Signed *arg4, void *arg5, Py_ssize_t arg6, Py_ssize_t arg7, PyObject *arg8);
PyAPI_FUNC(Py_ssize_t) _PyArray_SIZE(PyObject *arg0);
PyAPI_FUNC(Py_ssize_t) _PyArray_STRIDE(PyObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) _PyArray_SimpleNew(Py_ssize_t arg0, Signed *arg1, Py_ssize_t arg2);
PyAPI_FUNC(PyObject *) _PyArray_SimpleNewFromData(Py_ssize_t arg0, Signed *arg1, Py_ssize_t arg2, void *arg3);
PyAPI_FUNC(PyObject *) _PyArray_SimpleNewFromDataOwning(Py_ssize_t arg0, Signed *arg1, Py_ssize_t arg2, void *arg3);
PyAPI_FUNC(int) _PyArray_TYPE(PyObject *arg0);
PyAPI_FUNC(void) _PyComplex_AsCComplex(PyObject *arg0, Py_complex *arg1);
PyAPI_FUNC(PyObject *) _PyComplex_FromCComplex(Py_complex *arg0);
PyAPI_FUNC(PyDateTime_CAPI *) _PyDateTime_Import(void);
PyAPI_FUNC(int) _PyEval_SliceIndex(PyObject *arg0, Py_ssize_t *arg1);
PyAPI_FUNC(double) _PyFloat_Unpack4(const char *arg0, int arg1);
PyAPI_FUNC(double) _PyFloat_Unpack8(const char *arg0, int arg1);
PyAPI_FUNC(PyObject *) _PyInstance_Lookup(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) _PyLong_FromByteArray(unsigned char *arg0, Unsigned arg1, int arg2, int arg3);
PyAPI_FUNC(Unsigned) _PyLong_NumBits(PyObject *arg0);
PyAPI_FUNC(int) _PyLong_Sign(PyObject *arg0);
PyAPI_FUNC(PyObject *) _PyObject_GC_New(PyTypeObject *arg0);
PyAPI_FUNC(PyObject **) _PyObject_GetDictPtr(PyObject *arg0);
PyAPI_FUNC(PyObject *) _PyObject_New(PyTypeObject *arg0);
PyAPI_FUNC(PyObject *) _PyObject_NewVar(PyTypeObject *arg0, Py_ssize_t arg1);
PyAPI_FUNC(Signed) _PyString_Eq(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) _PyString_Join(PyObject *arg0, PyObject *arg1);
PyAPI_FUNC(int) _PyString_Resize(PyObject **arg0, Py_ssize_t arg1);
PyAPI_FUNC(int) _PyTuple_Resize(PyObject **arg0, Py_ssize_t arg1);
PyAPI_FUNC(PyObject *) _PyType_Lookup(PyTypeObject *arg0, PyObject *arg1);
PyAPI_FUNC(PyObject *) _PyUnicode_AsDefaultEncodedString(PyObject *arg0, const char *arg1);
PyAPI_FUNC(Signed) _Py_HashPointer(void *arg0);
PyAPI_FUNC(PyObject *) _Py_InitPyPyModule(const char *arg0, PyMethodDef *arg1, const char *arg2, PyObject *arg3, int arg4);
PyAPI_FUNC(void) _Py_NewReference(PyObject *arg0);
PyAPI_DATA(PyTypeObject) PyStaticMethod_Type;
PyAPI_DATA(PyObject*) PyExc_EnvironmentError;
PyAPI_DATA(PyTypeObject) PySlice_Type;
PyAPI_DATA(PyObject*) PyExc_IOError;
PyAPI_DATA(PyObject*) PyExc_RuntimeError;
PyAPI_DATA(PyObject*) PyExc_AttributeError;
PyAPI_DATA(PyObject*) PyExc_NameError;
PyAPI_DATA(PyObject*) PyExc_MemoryError;
PyAPI_DATA(PyObject*) PyExc_SystemExit;
PyAPI_DATA(PyTypeObject) PyModule_Type;
PyAPI_DATA(PyTypeObject) PyBaseObject_Type;
PyAPI_DATA(PyObject*) PyExc_FloatingPointError;
PyAPI_DATA(PyObject*) PyExc_UnicodeDecodeError;
PyAPI_DATA(PyObject*) PyExc_Exception;
PyAPI_DATA(PyObject*) PyExc_TypeError;
PyAPI_DATA(PyObject*) PyExc_SystemError;
PyAPI_DATA(PyObject*) PyExc_ReferenceError;
PyAPI_DATA(PyTypeObject) PyNotImplemented_Type;
PyAPI_DATA(PyTypeObject) PySet_Type;
PyAPI_DATA(PyObject*) PyExc_TabError;
PyAPI_DATA(PyTypeObject) PyDict_Type;
PyAPI_DATA(PyTypeObject) PyByteArray_Type;
PyAPI_DATA(PyTypeObject) PyNone_Type;
PyAPI_DATA(PyTypeObject) PyLong_Type;
PyAPI_DATA(PyTypeObject) PyWrapperDescr_Type;
PyAPI_DATA(PyObject*) PyExc_PendingDeprecationWarning;
PyAPI_DATA(PyObject*) PyExc_OverflowError;
PyAPI_DATA(PyObject*) PyExc_BaseException;
PyAPI_DATA(PyObject*) PyExc_StandardError;
PyAPI_DATA(PyObject*) PyExc_Warning;
PyAPI_DATA(PyTypeObject) PyTuple_Type;
PyAPI_DATA(PyObject*) PyExc_UnicodeError;
PyAPI_DATA(PyTypeObject) PyProperty_Type;
PyAPI_DATA(PyObject*) PyExc_IndexError;
PyAPI_DATA(PyTypeObject) PyCell_Type;
PyAPI_DATA(PyObject*) PyExc_FutureWarning;
PyAPI_DATA(PyObject) _Py_ZeroStruct;
PyAPI_DATA(PyObject*) PyExc_UnboundLocalError;
PyAPI_DATA(PyObject) _Py_NotImplementedStruct;
PyAPI_DATA(PyTypeObject) PyList_Type;
PyAPI_DATA(PyTypeObject) PyComplex_Type;
PyAPI_DATA(PyTypeObject) PyFrozenSet_Type;
PyAPI_DATA(PyTypeObject) PyUnicode_Type;
PyAPI_DATA(PyTypeObject) PyCFunction_Type;
PyAPI_DATA(PyObject*) PyExc_BytesWarning;
PyAPI_DATA(PyObject*) PyExc_DeprecationWarning;
PyAPI_DATA(PyObject*) PyExc_SyntaxError;
PyAPI_DATA(PyObject*) PyExc_UnicodeWarning;
PyAPI_DATA(PyObject*) PyExc_ZeroDivisionError;
PyAPI_DATA(PyTypeObject) PyFloat_Type;
PyAPI_DATA(PyObject*) PyExc_RuntimeWarning;
PyAPI_DATA(PyObject) _Py_NoneStruct;
PyAPI_DATA(PyObject*) PyExc_IndentationError;
PyAPI_DATA(PyObject*) PyExc_AssertionError;
PyAPI_DATA(PyObject*) PyExc_GeneratorExit;
PyAPI_DATA(PyObject*) PyExc_ImportWarning;
PyAPI_DATA(PyObject*) PyExc_UnicodeEncodeError;
PyAPI_DATA(PyTypeObject) PyInt_Type;
PyAPI_DATA(PyTypeObject) PyString_Type;
PyAPI_DATA(PyTypeObject) PyBool_Type;
PyAPI_DATA(PyObject*) PyExc_OSError;
PyAPI_DATA(PyObject*) PyExc_KeyError;
PyAPI_DATA(PyObject*) PyExc_SyntaxWarning;
PyAPI_DATA(PyTypeObject) PyBaseString_Type;
PyAPI_DATA(PyObject*) PyExc_StopIteration;
PyAPI_DATA(PyObject*) PyExc_NotImplementedError;
PyAPI_DATA(PyObject*) PyExc_ImportError;
PyAPI_DATA(PyDateTime_CAPI*) PyDateTimeAPI;
PyAPI_DATA(PyObject*) PyExc_UserWarning;
PyAPI_DATA(PyObject) _Py_TrueStruct;
PyAPI_DATA(PyObject*) PyExc_ArithmeticError;
PyAPI_DATA(PyTypeObject) PyClass_Type;
PyAPI_DATA(PyTypeObject) PyType_Type;
PyAPI_DATA(PyTypeObject) PyMemoryView_Type;
PyAPI_DATA(PyObject*) PyExc_UnicodeTranslateError;
PyAPI_DATA(PyObject*) PyExc_LookupError;
PyAPI_DATA(PyObject*) PyExc_EOFError;
PyAPI_DATA(PyObject*) PyExc_BufferError;
PyAPI_DATA(PyObject*) PyExc_ValueError;
PyAPI_DATA(PyObject) _Py_EllipsisObject;
PyAPI_DATA(PyObject*) PyExc_KeyboardInterrupt;
#undef Signed    /* xxx temporary fix */

#undef Unsigned  /* xxx temporary fix */

#ifdef __cplusplus
}
#endif
#endif /*PYPY_STANDALONE*/
