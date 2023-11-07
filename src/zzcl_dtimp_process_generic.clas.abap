CLASS zzcl_dtimp_process_generic DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: ms_configuration TYPE STRUCTURE FOR READ RESULT zzi_zt_dtimp_conf.
    DATA: ms_file TYPE STRUCTURE FOR READ RESULT zzr_zt_dtimp_files.
    DATA : uuid TYPE sysuuid_x16.
    DATA : mo_table TYPE REF TO data.
    DATA out TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log .

    METHODS  init_application_log.
    METHODS get_file_content IMPORTING p_uuid TYPE sysuuid_x16.
    METHODS get_batch_import_configuration IMPORTING p_uuid TYPE sysuuid_x16.
    METHODS get_uuid IMPORTING it_parameters TYPE if_apj_dt_exec_object=>tt_templ_val .
    METHODS get_data_from_xlsx.
    METHODS add_text_to_app_log_or_console IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
                                           RAISING
                                                     cx_bali_runtime.
    METHODS process_logic.
    METHODS save_job_info.
ENDCLASS.



CLASS ZZCL_DTIMP_PROCESS_GENERIC IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    TRY.
        IF sy-batch = abap_true.

          DATA(application_log_free_text) = cl_bali_free_text_setter=>create(
                                    severity = if_bali_constants=>c_severity_status
                                    text = i_text ).
          application_log_free_text->set_detail_level( detail_level = '1' ).
          application_log->add_item( item = application_log_free_text ).
          cl_bali_log_db=>get_instance( )->save_log(
                                                        log = application_log
                                                        assign_to_current_appl_job = abap_true
                                                     ).

        ELSE.
*          out->write( |sy-batch = abap_false | ).
          out->write( i_text ).
        ENDIF.
      CATCH cx_bali_runtime INTO DATA(lx_bali_runtime).
    ENDTRY.
  ENDMETHOD.


  METHOD get_batch_import_configuration.
    READ ENTITY zzi_zt_dtimp_conf ALL FIELDS WITH VALUE #( (  %key-uuid = ms_file-UuidConf ) )
        RESULT FINAL(LT_configuration).
    ms_configuration = lt_configuration[ 1 ].
  ENDMETHOD.


  METHOD get_data_from_xlsx.


    TRY.
        "create internal table for corresponding table type
        CREATE DATA mo_table TYPE TABLE OF (ms_configuration-Structname).

        " read xlsx object
        DATA(lo_document) = xco_cp_xlsx=>document->for_file_content( ms_file-Attachment ).
        DATA(lo_worksheet) = lo_document->read_access(  )->get_workbook(  )->worksheet->for_name( CONV string( ms_configuration-Sheetname ) ).

        DATA(lo_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(  )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 3 ) )->get_pattern(  ).

        lo_worksheet->select( lo_pattern )->row_stream(  )->operation->write_to( mo_table->* )->execute(  ).
      CATCH cx_sy_create_data_error INTO DATA(lX_SY_CREATE_DATA_ERROR).
        add_text_to_app_log_or_console( |Data structure of Import Object not found, please contact Administrator | ).
*        return.
*        RAISE EXCEPTION TYPE cx_bali_runtime.
    ENDTRY.





  ENDMETHOD.


  METHOD get_file_content.
    READ ENTITY zzr_zt_dtimp_files ALL FIELDS WITH VALUE #( (  %key-uuid = p_uuid ) )
        RESULT FINAL(lt_file).
    ms_file = lt_file[ 1 ].
  ENDMETHOD.


  METHOD get_uuid.
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'P_ID'.
          uuid = ls_parameter-low.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.
    " Return the supported selection parameters here
    et_parameter_def = VALUE #(
      ( selname = 'P_ID'    kind = if_apj_dt_exec_object=>parameter datatype = 'X' length = 16 param_text = 'UUID of stored file' changeable_ind = abap_true )
    ).
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.



    " get uuid
    get_uuid( it_parameters ).

    "create log handle
    init_application_log(  ).

    " save job info to ZZC_ZT_DTIMP_FILES
    save_job_info(  ).

    cl_system_uuid=>convert_uuid_x16_static( EXPORTING uuid = uuid IMPORTING uuid_c36 = DATA(lv_uuid_C36)  ).
    add_text_to_app_log_or_console( |process batch import uuid { lv_uuid_C36 }|   ).


    IF uuid IS INITIAL.
      add_text_to_app_log_or_console( |record not found for uuid { lv_uuid_C36 }|   ).
      RETURN.
    ENDIF.




    " get file content
    get_file_content( uuid ).
    add_text_to_app_log_or_console( |file name: { ms_file-filename } |   ).

    IF ms_file IS INITIAL.
      add_text_to_app_log_or_console( |record not found for uuid { lv_uuid_C36 }|   ).
      RETURN.
    ENDIF.

    IF ms_file-Attachment IS INITIAL.
      add_text_to_app_log_or_console( |File not found|   ).
      RETURN.
    ENDIF.

    " get configuration
    get_batch_import_configuration( uuid ).
    add_text_to_app_log_or_console( |import object: { ms_configuration-Objectname } |   ).

    " read excel
    IF ms_configuration IS INITIAL.
      add_text_to_app_log_or_console( |configuration not found for this batch import record |   ).
      RETURN.
    ENDIF.
    get_data_from_xlsx(  ).

    " call function module
    IF mo_table IS  INITIAL.
      RETURN.
    ENDIF.
    process_logic(  ).



  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    me->out = out.

    DATA  et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val  .

    et_parameters = VALUE #(
        ( selname = 'P_ID'
          kind = if_apj_dt_exec_object=>parameter
          sign = 'I'
          option = 'EQ'
          low = 'F9847D36B9471EEE99A5D4D9C9315E8A' )
      ).

    TRY.

        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).

      CATCH cx_root INTO DATA(job_scheduling_exception).
        out->write( |Exception has occured: { job_scheduling_exception->get_text(  ) }| ).
    ENDTRY.
  ENDMETHOD.


  METHOD init_application_log.
    DATA : external_id TYPE c LENGTH 100.

    external_id = uuid.
*    cl_bali_log=>
    application_log = cl_bali_log=>create_with_header(
                           header = cl_bali_header_setter=>create( object = 'ZZ_ALO_DATAIMPORT'
                                                                   subobject = 'ZZ_ALO_TEXT_SUB'
                                                                   external_id = external_id ) ).
  ENDMETHOD.


  METHOD process_logic.
    DATA : ptab      TYPE abap_func_parmbind_tab,
           lo_data_e TYPE REF TO data.
    FIELD-SYMBOLS : <fs_t_e> TYPE STANDARD TABLE.

    ptab = VALUE #( ( name  = 'IO_DATA'
                  kind  = abap_func_exporting
                  value = REF #( mo_table ) )
                ( name  = 'IV_STRUC'
                  kind  = abap_func_exporting
                  value = REF #( ms_configuration-structname ) )
                ( name  = 'EO_DATA'
                  kind  = abap_func_importing
                  value = REF #( lo_data_e ) ) ).

    CALL FUNCTION ms_configuration-Fmname PARAMETER-TABLE ptab.

    ASSIGN lo_data_e->* TO <fs_t_e>.


    " save log
    LOOP AT <fs_t_e> ASSIGNING FIELD-SYMBOL(<fs_s_e>).
      add_text_to_app_log_or_console( |data line: { sy-tabix }, result: { <fs_s_e>-('type') }, message: {  <fs_s_e>-('message') } | ).
    ENDLOOP.
  ENDMETHOD.


  METHOD save_job_info.
    DATA(log_handle) = application_log->get_handle( ).
    DATA: jobname   TYPE cl_apj_rt_api=>ty_jobname.
    DATA: jobcount  TYPE cl_apj_rt_api=>ty_jobcount.
    DATA: catalog   TYPE cl_apj_rt_api=>ty_catalog_name.
    DATA: template  TYPE cl_apj_rt_api=>ty_template_name.
    cl_apj_rt_api=>get_job_runtime_info(
                        IMPORTING
                          ev_jobname        = jobname
                          ev_jobcount       = jobcount
                          ev_catalog_name   = catalog
                          ev_template_name  = template ).

    MODIFY ENTITY zzr_zt_dtimp_files UPDATE FIELDS ( JobCount JobName LogHandle ) WITH VALUE #( ( JobCount = jobcount JobName = jobname LogHandle = log_handle uuid = uuid ) ).
    COMMIT ENTITIES.
  ENDMETHOD.
ENDCLASS.
