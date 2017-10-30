//
//  Warning.h
//  CDT
//
//  Created by WangBo (developforapple@163.com) on 2017/7/6.
//  Copyright © 2017年 来电科技 All rights reserved.
//

#ifndef Warning_h
#define Warning_h

// 不要修改下面的宏
#define _N_W_MACRO_CAT(a,b)      a b
#define _N_W_MACRO_STR_(text)    # text
#define _N_W_MACRO_STR(text)     _N_W_MACRO_STR_(text)
#define _N_W_MACRO_PREFIX_       clang diagnostic ignored
#define _N_W_MACRO_PREFIX        _N_W_MACRO_PREFIX_
#define _N_W_MACRO_(text)        _N_W_MACRO_CAT(_N_W_MACRO_PREFIX,_N_W_MACRO_STR(text))
#define _N_W_MACRO(text)         _N_W_MACRO_STR(_N_W_MACRO_(text))

#define NO_WARNING_BEGIN(type)\
_Pragma("clang diagnostic push")\
_Pragma(_N_W_MACRO(type))


#define NO_WARNING_END \
_Pragma("clang diagnostic pop")


#ifndef NWB_MACRO
#define NWB_MACRO

#define NWEND NO_WARNING_END


// link http://nshipster.com/clang-diagnostics/
// link http://fuckingclangwarnings.com/#lex

// 替换正则 (#define NWB_[a-zA-Z0-9_]*)- 为 $1_

#define NWB_WCFString_literal                           NO_WARNING_BEGIN(-WCFString-literal)
#define NWB_WNSObject_attribute                         NO_WARNING_BEGIN(-WNSObject-attribute)
#define NWB_Wabstract_vbase_init                        NO_WARNING_BEGIN(-Wabstract-vbase-init)
#define NWB_Waddress_of_array_temporary                 NO_WARNING_BEGIN(-Waddress-of-array-temporary)
#define NWB_Warc_maybe_repeated_use_of_weak             NO_WARNING_BEGIN(-Warc-maybe-repeated-use-of-weak)
#define NWB_Warc_non_pod_memaccess                      NO_WARNING_BEGIN(-Warc-non-pod-memaccess)
#define NWB_Warc_performSelector_leaks                  NO_WARNING_BEGIN(-Warc-performSelector-leaks)
#define NWB_Warc_repeated_use_of_weak                   NO_WARNING_BEGIN(-Warc-repeated-use-of-weak)
#define NWB_Warc_retain_cycles                          NO_WARNING_BEGIN(-Warc-retain-cycles)
#define NWB_Warc_unsafe_retained_assign                 NO_WARNING_BEGIN(-Warc-unsafe-retained-assign)
#define NWB_Warray_bounds                               NO_WARNING_BEGIN(-Warray-bounds)
#define NWB_Warray_bounds_pointer_arithmetic            NO_WARNING_BEGIN(-Warray-bounds-pointer-arithmetic)
#define NWB_Wassign_enum                                NO_WARNING_BEGIN(-Wassign-enum)
#define NWB_Watomic_property_with_user_defined_accessor NO_WARNING_BEGIN(-Watomic-property-with-user-defined-accessor)
#define NWB_Wattributes                                 NO_WARNING_BEGIN(-Wattributes)
#define NWB_Wauto_var_id                                NO_WARNING_BEGIN(-Wauto-var-id)
#define NWB_Wavailability                               NO_WARNING_BEGIN(-Wavailability)
#define NWB_Wbad_function_cast                          NO_WARNING_BEGIN(-Wbad-function-cast)
#define NWB_Wbitfield_constant_conversion               NO_WARNING_BEGIN(-Wbitfield-constant-conversion)
#define NWB_Wbitwise_op_parentheses                     NO_WARNING_BEGIN(-Wbitwise-op-parentheses)
#define NWB_Wbool_conversion                            NO_WARNING_BEGIN(-Wbool-conversion)
#define NWB_Wbridge_cast                                NO_WARNING_BEGIN(-Wbridge-cast)
#define NWB_Wbuiltin_requires_header                    NO_WARNING_BEGIN(-Wbuiltin-requires-header)
#define NWB_Wc___compat                                 NO_WARNING_BEGIN(-Wc++-compat)
#define NWB_Wc__11_compat                               NO_WARNING_BEGIN(-Wc++11-compat)
#define NWB_Wc__11_narrowing                            NO_WARNING_BEGIN(-Wc++11-narrowing)
#define NWB_Wc__98_c__11_compat                         NO_WARNING_BEGIN(-Wc++98-c++11-compat)
#define NWB_Wc__98_compat                               NO_WARNING_BEGIN(-Wc++98-compat)
#define NWB_Wc__98_compat_pedantic                      NO_WARNING_BEGIN(-Wc++98-compat-pedantic)
#define NWB_Wcast_align                                 NO_WARNING_BEGIN(-Wcast-align)
#define NWB_Wcast_of_sel_type                           NO_WARNING_BEGIN(-Wcast-of-sel-type)
#define NWB_Wchar_subscripts                            NO_WARNING_BEGIN(-Wchar-subscripts)
#define NWB_Wconditional_uninitialized                  NO_WARNING_BEGIN(-Wconditional-uninitialized)
#define NWB_Wconstant_logical_operand                   NO_WARNING_BEGIN(-Wconstant-logical-operand)
#define NWB_Wconstexpr_not_const                        NO_WARNING_BEGIN(-Wconstexpr-not-const)
#define NWB_Wconsumed                                   NO_WARNING_BEGIN(-Wconsumed)
#define NWB_Wconversion                                 NO_WARNING_BEGIN(-Wconversion)
#define NWB_Wcovered_switch_default                     NO_WARNING_BEGIN(-Wcovered-switch-default)
#define NWB_Wcustom_atomic_properties                   NO_WARNING_BEGIN(-Wcustom-atomic-properties)
#define NWB_Wdangling_field                             NO_WARNING_BEGIN(-Wdangling-field)
#define NWB_Wdangling_initializer_list                  NO_WARNING_BEGIN(-Wdangling-initializer-list)
#define NWB_Wdelete_incomplete                          NO_WARNING_BEGIN(-Wdelete-incomplete)
#define NWB_Wdelete_non_virtual_dtor                    NO_WARNING_BEGIN(-Wdelete-non-virtual-dtor)
#define NWB_Wdeprecated                                 NO_WARNING_BEGIN(-Wdeprecated)
#define NWB_Wdeprecated_increment_bool                  NO_WARNING_BEGIN(-Wdeprecated-increment-bool)
#define NWB_Wdeprecated_objc_isa_usage                  NO_WARNING_BEGIN(-Wdeprecated-objc-isa-usage)
#define NWB_Wdeprecated_objc_pointer_introspection      NO_WARNING_BEGIN(-Wdeprecated-objc-pointer-introspection)
#define NWB_Wdeprecated_objc_pointer_introspection_performSelector NO_WARNING_BEGIN(-Wdeprecated-objc-pointer-introspection-performSelector)
#define NWB_Wdeprecated_writable_strings                NO_WARNING_BEGIN(-Wdeprecated-writable-strings)
#define NWB_Wdirect_ivar_access                         NO_WARNING_BEGIN(-Wdirect-ivar-access)
#define NWB_Wdistributed_object_modifiers               NO_WARNING_BEGIN(-Wdistributed-object-modifiers)
#define NWB_Wdivision_by_zero                           NO_WARNING_BEGIN(-Wdivision-by-zero)
#define NWB_Wdocumentation                              NO_WARNING_BEGIN(-Wdocumentation)
#define NWB_Wduplicate_enum                             NO_WARNING_BEGIN(-Wduplicate-enum)
#define NWB_Wduplicate_method_match                     NO_WARNING_BEGIN(-Wduplicate-method-match)
#define NWB_Wdynamic_class_memaccess                    NO_WARNING_BEGIN(-Wdynamic-class-memaccess)
#define NWB_Wempty_body                                 NO_WARNING_BEGIN(-Wempty-body)
#define NWB_Wenum_compare                               NO_WARNING_BEGIN(-Wenum-compare)
#define NWB_Wenum_conversion                            NO_WARNING_BEGIN(-Wenum-conversion)
#define NWB_Wexit_time_destructors                      NO_WARNING_BEGIN(-Wexit-time-destructors)
#define NWB_Wexplicit_ownership_type                    NO_WARNING_BEGIN(-Wexplicit-ownership-type)
#define NWB_Wextern_c_compat                            NO_WARNING_BEGIN(-Wextern-c-compat)
#define NWB_Wextern_initializer                         NO_WARNING_BEGIN(-Wextern-initializer)
#define NWB_Wfloat_equal                                NO_WARNING_BEGIN(-Wfloat-equal)
#define NWB_Wformat                                     NO_WARNING_BEGIN(-Wformat)
#define NWB_Wformat_extra_args                          NO_WARNING_BEGIN(-Wformat-extra-args)
#define NWB_Wformat_invalid_specifier                   NO_WARNING_BEGIN(-Wformat-invalid-specifier)
#define NWB_Wformat_nonliteral                          NO_WARNING_BEGIN(-Wformat-nonliteral)
#define NWB_Wformat_security                            NO_WARNING_BEGIN(-Wformat-security)
#define NWB_Wformat_zero_length                         NO_WARNING_BEGIN(-Wformat-zero-length)
#define NWB_Wgcc_compat                                 NO_WARNING_BEGIN(-Wgcc-compat)
#define NWB_Wglobal_constructors                        NO_WARNING_BEGIN(-Wglobal-constructors)
#define NWB_Wgnu_conditional_omitted_operand            NO_WARNING_BEGIN(-Wgnu-conditional-omitted-operand)
#define NWB_Wheader_hygiene                             NO_WARNING_BEGIN(-Wheader-hygiene)
#define NWB_Widiomatic_parentheses                      NO_WARNING_BEGIN(-Widiomatic-parentheses)
#define NWB_Wignored_attributes                         NO_WARNING_BEGIN(-Wignored-attributes)
#define NWB_Wignored_qualifiers                         NO_WARNING_BEGIN(-Wignored-qualifiers)
#define NWB_Wimplicit_atomic_properties                 NO_WARNING_BEGIN(-Wimplicit-atomic-properties)
#define NWB_Wimplicit_fallthrough                       NO_WARNING_BEGIN(-Wimplicit-fallthrough)
#define NWB_Wimplicit_function_declaration              NO_WARNING_BEGIN(-Wimplicit-function-declaration)
#define NWB_Wimplicit_retain_self                       NO_WARNING_BEGIN(-Wimplicit-retain-self)
#define NWB_Wincompatible_library_redeclaration         NO_WARNING_BEGIN(-Wincompatible-library-redeclaration)
#define NWB_Wincomplete_implementation                  NO_WARNING_BEGIN(-Wincomplete-implementation)
#define NWB_Winherited_variadic_ctor                    NO_WARNING_BEGIN(-Winherited-variadic-ctor)
#define NWB_Winitializer_overrides                      NO_WARNING_BEGIN(-Winitializer-overrides)
#define NWB_Wint_to_pointer_cast                        NO_WARNING_BEGIN(-Wint-to-pointer-cast)
#define NWB_Wint_to_void_pointer_cast                   NO_WARNING_BEGIN(-Wint-to-void-pointer-cast)
#define NWB_Winvalid_iboutlet                           NO_WARNING_BEGIN(-Winvalid-iboutlet)
#define NWB_Winvalid_noreturn                           NO_WARNING_BEGIN(-Winvalid-noreturn)
#define NWB_Wlarge_by_value_copy                        NO_WARNING_BEGIN(-Wlarge-by-value-copy)
#define NWB_Wliteral_conversion                         NO_WARNING_BEGIN(-Wliteral-conversion)
#define NWB_Wliteral_range                              NO_WARNING_BEGIN(-Wliteral-range)
#define NWB_Wlogical_not_parentheses                    NO_WARNING_BEGIN(-Wlogical-not-parentheses)
#define NWB_Wloop_analysis                              NO_WARNING_BEGIN(-Wloop-analysis)
#define NWB_Wmethod_signatures                          NO_WARNING_BEGIN(-Wmethod-signatures)
#define NWB_Wmicrosoft                                  NO_WARNING_BEGIN(-Wmicrosoft)
#define NWB_Wmismatched_method_attributes               NO_WARNING_BEGIN(-Wmismatched-method-attributes)
#define NWB_Wmismatched_parameter_types                 NO_WARNING_BEGIN(-Wmismatched-parameter-types)
#define NWB_Wmismatched_return_types                    NO_WARNING_BEGIN(-Wmismatched-return-types)
#define NWB_Wmissing_braces                             NO_WARNING_BEGIN(-Wmissing-braces)
#define NWB_Wmissing_declarations                       NO_WARNING_BEGIN(-Wmissing-declarations)
#define NWB_Wmissing_field_initializers                 NO_WARNING_BEGIN(-Wmissing-field-initializers)
#define NWB_Wmissing_method_return_type                 NO_WARNING_BEGIN(-Wmissing-method-return-type)
#define NWB_Wmissing_noreturn                           NO_WARNING_BEGIN(-Wmissing-noreturn)
#define NWB_Wmissing_prototypes                         NO_WARNING_BEGIN(-Wmissing-prototypes)
#define NWB_Wmissing_variable_declarations              NO_WARNING_BEGIN(-Wmissing-variable-declarations)
#define NWB_Wmultiple_move_vbase                        NO_WARNING_BEGIN(-Wmultiple-move-vbase)
#define NWB_Wnested_anon_types                          NO_WARNING_BEGIN(-Wnested-anon-types)
#define NWB_Wno_typedef_redefinition                    NO_WARNING_BEGIN(-Wno-typedef-redefinition)
#define NWB_Wnon_literal_null_conversion                NO_WARNING_BEGIN(-Wnon-literal-null-conversion)
#define NWB_Wnon_pod_varargs                            NO_WARNING_BEGIN(-Wnon-pod-varargs)
#define NWB_Wnon_virtual_dtor                           NO_WARNING_BEGIN(-Wnon-virtual-dtor)
#define NWB_Wnonnull                                    NO_WARNING_BEGIN(-Wnonnull)
#define NWB_Wnull_arithmetic                            NO_WARNING_BEGIN(-Wnull-arithmetic)
#define NWB_Wnull_dereference                           NO_WARNING_BEGIN(-Wnull-dereference)
#define NWB_Wobjc_autosynthesis_property_ivar_name_match NO_WARNING_BEGIN(-Wobjc-autosynthesis-property-ivar-name-match)
#define NWB_Wobjc_forward_class_redefinition            NO_WARNING_BEGIN(-Wobjc-forward-class-redefinition)
#define NWB_Wobjc_interface_ivars                       NO_WARNING_BEGIN(-Wobjc-interface-ivars)
#define NWB_Wobjc_literal_compare                       NO_WARNING_BEGIN(-Wobjc-literal-compare)
#define NWB_Wobjc_literal_missing_atsign                NO_WARNING_BEGIN(-Wobjc-literal-missing-atsign)
#define NWB_Wobjc_method_access                         NO_WARNING_BEGIN(-Wobjc-method-access)
#define NWB_Wobjc_missing_property_synthesis            NO_WARNING_BEGIN(-Wobjc-missing-property-synthesis)
#define NWB_Wobjc_missing_super_calls                   NO_WARNING_BEGIN(-Wobjc-missing-super-calls)
#define NWB_Wobjc_noncopy_retain_block_property         NO_WARNING_BEGIN(-Wobjc-noncopy-retain-block-property)
#define NWB_Wobjc_nonunified_exceptions                 NO_WARNING_BEGIN(-Wobjc-nonunified-exceptions)
#define NWB_Wobjc_property_implementation               NO_WARNING_BEGIN(-Wobjc-property-implementation)
#define NWB_Wobjc_property_implicit_mismatch            NO_WARNING_BEGIN(-Wobjc-property-implicit-mismatch)
#define NWB_Wobjc_property_matches_cocoa_ownership_rule NO_WARNING_BEGIN(-Wobjc-property-matches-cocoa-ownership-rule)
#define NWB_Wobjc_property_no_attribute                 NO_WARNING_BEGIN(-Wobjc-property-no-attribute)
#define NWB_Wobjc_property_synthesis                    NO_WARNING_BEGIN(-Wobjc-property-synthesis)
#define NWB_Wobjc_protocol_method_implementation        NO_WARNING_BEGIN(-Wobjc-protocol-method-implementation)
#define NWB_Wobjc_protocol_property_synthesis           NO_WARNING_BEGIN(-Wobjc-protocol-property-synthesis)
#define NWB_Wobjc_redundant_literal_use                 NO_WARNING_BEGIN(-Wobjc-redundant-literal-use)
#define NWB_Wobjc_root_class                            NO_WARNING_BEGIN(-Wobjc-root-class)
#define NWB_Wobjc_string_compare                        NO_WARNING_BEGIN(-Wobjc-string-compare)
#define NWB_Wobjc_string_concatenation                  NO_WARNING_BEGIN(-Wobjc-string-concatenation)
#define NWB_Wover_aligned                               NO_WARNING_BEGIN(-Wover-aligned)
#define NWB_Woverloaded_shift_op_parentheses            NO_WARNING_BEGIN(-Woverloaded-shift-op-parentheses)
#define NWB_Woverloaded_virtual                         NO_WARNING_BEGIN(-Woverloaded-virtual)
#define NWB_Woverriding_method_mismatch                 NO_WARNING_BEGIN(-Woverriding-method-mismatch)
#define NWB_Wpacked                                     NO_WARNING_BEGIN(-Wpacked)
#define NWB_Wpadded                                     NO_WARNING_BEGIN(-Wpadded)
#define NWB_Wparentheses                                NO_WARNING_BEGIN(-Wparentheses)
#define NWB_Wparentheses_equality                       NO_WARNING_BEGIN(-Wparentheses-equality)
#define NWB_Wpointer_arith                              NO_WARNING_BEGIN(-Wpointer-arith)
#define NWB_Wpredefined_identifier_outside_function     NO_WARNING_BEGIN(-Wpredefined-identifier-outside-function)
#define NWB_Wprivate_extern                             NO_WARNING_BEGIN(-Wprivate-extern)
#define NWB_Wprotocol                                   NO_WARNING_BEGIN(-Wprotocol)
#define NWB_Wprotocol_property_synthesis_ambiguity      NO_WARNING_BEGIN(-Wprotocol-property-synthesis-ambiguity)
#define NWB_Wreadonly_iboutlet_property                 NO_WARNING_BEGIN(-Wreadonly-iboutlet-property)
#define NWB_Wreadonly_setter_attrs                      NO_WARNING_BEGIN(-Wreadonly-setter-attrs)
#define NWB_Wreceiver_expr                              NO_WARNING_BEGIN(-Wreceiver-expr)
#define NWB_Wreceiver_forward_class                     NO_WARNING_BEGIN(-Wreceiver-forward-class)
#define NWB_Wreceiver_is_weak                           NO_WARNING_BEGIN(-Wreceiver-is-weak)
#define NWB_Wreinterpret_base_class                     NO_WARNING_BEGIN(-Wreinterpret-base-class)
#define NWB_Wreorder                                    NO_WARNING_BEGIN(-Wreorder)
#define NWB_Wrequires_super_attribute                   NO_WARNING_BEGIN(-Wrequires-super-attribute)
#define NWB_Wreturn_stack_address                       NO_WARNING_BEGIN(-Wreturn-stack-address)
#define NWB_Wreturn_type                                NO_WARNING_BEGIN(-Wreturn-type)
#define NWB_Wreturn_type_c_linkage                      NO_WARNING_BEGIN(-Wreturn-type-c-linkage)
#define NWB_Wsection                                    NO_WARNING_BEGIN(-Wsection)
#define NWB_Wselector                                   NO_WARNING_BEGIN(-Wselector)
#define NWB_Wselector_type_mismatch                     NO_WARNING_BEGIN(-Wselector-type-mismatch)
#define NWB_Wself_assign                                NO_WARNING_BEGIN(-Wself-assign)
#define NWB_Wself_assign_field                          NO_WARNING_BEGIN(-Wself-assign-field)
#define NWB_Wsentinel                                   NO_WARNING_BEGIN(-Wsentinel)
#define NWB_Wshadow                                     NO_WARNING_BEGIN(-Wshadow)
#define NWB_Wshadow_ivar                                NO_WARNING_BEGIN(-Wshadow-ivar)
#define NWB_Wshift_count_negative                       NO_WARNING_BEGIN(-Wshift-count-negative)
#define NWB_Wshift_count_overflow                       NO_WARNING_BEGIN(-Wshift-count-overflow)
#define NWB_Wshift_op_parentheses                       NO_WARNING_BEGIN(-Wshift-op-parentheses)
#define NWB_Wshift_overflow                             NO_WARNING_BEGIN(-Wshift-overflow)
#define NWB_Wshift_sign_overflow                        NO_WARNING_BEGIN(-Wshift-sign-overflow)
#define NWB_Wshorten_64_to_32                           NO_WARNING_BEGIN(-Wshorten-64-to-32)
#define NWB_Wsign_compare                               NO_WARNING_BEGIN(-Wsign-compare)
#define NWB_Wsign_conversion                            NO_WARNING_BEGIN(-Wsign-conversion)
#define NWB_Wsizeof_array_argument                      NO_WARNING_BEGIN(-Wsizeof-array-argument)
#define NWB_Wsizeof_array_decay                         NO_WARNING_BEGIN(-Wsizeof-array-decay)
#define NWB_Wsizeof_pointer_memaccess                   NO_WARNING_BEGIN(-Wsizeof-pointer-memaccess)
#define NWB_Wsometimes_uninitialized                    NO_WARNING_BEGIN(-Wsometimes-uninitialized)
#define NWB_Wstatic_local_in_inline                     NO_WARNING_BEGIN(-Wstatic-local-in-inline)
#define NWB_Wstatic_self_init                           NO_WARNING_BEGIN(-Wstatic-self-init)
#define NWB_Wstrict_selector_match                      NO_WARNING_BEGIN(-Wstrict-selector-match)
#define NWB_Wstring_compare                             NO_WARNING_BEGIN(-Wstring-compare)
#define NWB_Wstring_conversion                          NO_WARNING_BEGIN(-Wstring-conversion)
#define NWB_Wstring_plus_char                           NO_WARNING_BEGIN(-Wstring-plus-char)
#define NWB_Wstring_plus_int                            NO_WARNING_BEGIN(-Wstring-plus-int)
#define NWB_Wstrlcpy_strlcat_size                       NO_WARNING_BEGIN(-Wstrlcpy-strlcat-size)
#define NWB_Wstrncat_size                               NO_WARNING_BEGIN(-Wstrncat-size)
#define NWB_Wsuper_class_method_mismatch                NO_WARNING_BEGIN(-Wsuper-class-method-mismatch)
#define NWB_Wswitch                                     NO_WARNING_BEGIN(-Wswitch)
#define NWB_Wswitch_enum                                NO_WARNING_BEGIN(-Wswitch-enum)
#define NWB_Wtautological_compare                       NO_WARNING_BEGIN(-Wtautological-compare)
#define NWB_Wtautological_constant_out_of_range_compare NO_WARNING_BEGIN(-Wtautological-constant-out-of-range-compare)
#define NWB_Wthread_safety_analysis                     NO_WARNING_BEGIN(-Wthread-safety-analysis)
#define NWB_Wthread_safety_attributes                   NO_WARNING_BEGIN(-Wthread-safety-attributes)
#define NWB_Wthread_safety_beta                         NO_WARNING_BEGIN(-Wthread-safety-beta)
#define NWB_Wthread_safety_precise                      NO_WARNING_BEGIN(-Wthread-safety-precise)
#define NWB_Wtype_safety                                NO_WARNING_BEGIN(-Wtype-safety)
#define NWB_Wundeclared_selector                        NO_WARNING_BEGIN(-Wundeclared-selector)
#define NWB_Wundefined_inline                           NO_WARNING_BEGIN(-Wundefined-inline)
#define NWB_Wundefined_internal                         NO_WARNING_BEGIN(-Wundefined-internal)
#define NWB_Wundefined_reinterpret_cast                 NO_WARNING_BEGIN(-Wundefined-reinterpret-cast)
#define NWB_Wuninitialized                              NO_WARNING_BEGIN(-Wuninitialized)
#define NWB_Wunneeded_internal_declaration              NO_WARNING_BEGIN(-Wunneeded-internal-declaration)
#define NWB_Wunneeded_member_function                   NO_WARNING_BEGIN(-Wunneeded-member-function)
#define NWB_Wunreachable_code                           NO_WARNING_BEGIN(-Wunreachable-code)
#define NWB_Wunsequenced                                NO_WARNING_BEGIN(-Wunsequenced)
#define NWB_Wunsupported_friend                         NO_WARNING_BEGIN(-Wunsupported-friend)
#define NWB_Wunsupported_visibility                     NO_WARNING_BEGIN(-Wunsupported-visibility)
#define NWB_Wunused_comparison                          NO_WARNING_BEGIN(-Wunused-comparison)
#define NWB_Wunused_const_variable                      NO_WARNING_BEGIN(-Wunused-const-variable)
#define NWB_Wunused_exception_parameter                 NO_WARNING_BEGIN(-Wunused-exception-parameter)
#define NWB_Wunused_function                            NO_WARNING_BEGIN(-Wunused-function)
#define NWB_Wunused_label                               NO_WARNING_BEGIN(-Wunused-label)
#define NWB_Wunused_member_function                     NO_WARNING_BEGIN(-Wunused-member-function)
#define NWB_Wunused_parameter                           NO_WARNING_BEGIN(-Wunused-parameter)
#define NWB_Wunused_private_field                       NO_WARNING_BEGIN(-Wunused-private-field)
#define NWB_Wunused_property_ivar                       NO_WARNING_BEGIN(-Wunused-property-ivar)
#define NWB_Wunused_result                              NO_WARNING_BEGIN(-Wunused-result)
#define NWB_Wunused_value                               NO_WARNING_BEGIN(-Wunused-value)
#define NWB_Wunused_variable                            NO_WARNING_BEGIN(-Wunused-variable)
#define NWB_Wunused_volatile_lvalue                     NO_WARNING_BEGIN(-Wunused-volatile-lvalue)
#define NWB_Wused_but_marked_unused                     NO_WARNING_BEGIN(-Wused-but-marked-unused)
#define NWB_Wuser_defined_literals                      NO_WARNING_BEGIN(-Wuser-defined-literals)
#define NWB_Wvarargs                                    NO_WARNING_BEGIN(-Wvarargs)
#define NWB_Wvector_conversion                          NO_WARNING_BEGIN(-Wvector-conversion)
#define NWB_Wvexing_parse                               NO_WARNING_BEGIN(-Wvexing-parse)
#define NWB_Wvisibility                                 NO_WARNING_BEGIN(-Wvisibility)
#define NWB_Wvla                                        NO_WARNING_BEGIN(-Wvla)
#define NWB_Wvla_extension                              NO_WARNING_BEGIN(-Wvla-extension)
#define NWB_Wweak_template_vtables                      NO_WARNING_BEGIN(-Wweak-template-vtables)
#define NWB_Wweak_vtables                               NO_WARNING_BEGIN(-Wweak-vtables)
//#define NWB_warning NO_WARNING_BEGIN(warning)

#endif //NWB_MACRO

// 不要修改上面的宏





// 用法与示例

// 请将 _N_W_DEMO 设为 1 打开示例
#define _N_W_DEMO 0

#if DEBUG && _N_W_DEMO

/*
 正常情况下，test1会有三个警告：
 a: Unused function 'test1'
 b: Undeclared selector 'theSELName'
 c: PerformSelector may cause a leak because its selector is unknown
 
 按 command + 5 打开警告列表。找到a,b,c对应的警告，右键选择 Reveal in log。
 可以看到这样的文本：
 Common/Warning.h:51:17: warning: undeclared selector 'theSELName' [-Wundeclared-selector]
 SEL aSEL = @selector(theSELName);
 ^
 /Users/jay/iOS/CDT/CDT/CDT2017/Common/Warning.h:54:14: warning: performSelector may cause a leak because its selector is unknown [-Warc-performSelector-leaks]
 [obj performSelector:aSEL];
 ^
 Common/Warning.h:48:13: warning: unused function 'test1' [-Wunused-function]
 static void test1(void){
 ^
 其中可以找到
 a 的警告类型：-Wunused-function
 b 的警告类型：-Wundeclared-selector
 c 的警告类型：-Warc-performSelector-leaks
 
 在发出警告的代码前使用消除警告代码宏即可消除这些警告。
 忘了在消除了警告的代码之后使用结束宏。消除开始宏可以写多个。结束宏只需要写一个就可以使得结束宏后面的代码的警告再次出现。
 
 你也可以在 http://fuckingclangwarnings.com 找到这些警告列表
 */

// 这个函数没有消除警告
static void test1(void){
    id obj = [NSObject new];
    SEL aSEL = @selector(theSELName);
    if ([obj respondsToSelector:aSEL]) {
        [obj performSelector:aSEL];
    }
}

// 使用消除警告宏消除警告
NO_WARNING_BEGIN(-Wunused-function)
NO_WARNING_BEGIN(-Wundeclared-selector)
NO_WARNING_BEGIN(-Warc-performSelector-leaks)

// 不消除警告时，Xcode会在这一行显示警告：Unused function 'test2'
static void test2(void){
    
    id obj = [NSObject new];
    
    // 不消除警告时，Xcode会在这一行显示警告：Undeclared selector 'theSELName'
    SEL aSEL = @selector(theSELName);
    
    if ([obj respondsToSelector:aSEL]) {
        
        // 不消除警告时，Xcode会在这一行显示警告：PerformSelector may cause a leak because its selector is unknown
        [obj performSelector:aSEL];
    }
}
NO_WARNING_END

#endif



#endif /* Warning_h */

