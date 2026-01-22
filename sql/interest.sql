
spool/script/edw/ar/mg/log2/interest.log
set echo on time on timing on

------------------------------------------------[Step:1;Createnew/changerecords

truncate table Als_Interest_Mast_Imd;

begin
		 for r in(select t.rowid tid,g.branch_code
                from dwhadmin.ITF_ALS_INTEREST t
                    ,dwhadmin.gain_master_bank_wbase g
               where t.account = g.account_number
     )loop
       			update dwhadmin.ITF_ALS_INTEREST
       			   set BRANCH = r.branch_code
       			 where rowid  = r.tid;
     end loop;
     commit;
     
         execute immediate 'drop index Als_Interest_Mast_Imd_Unq';
exception when others then
        null;
end;
/
insert --+ append nologging parallel
  into als_interest_mast_imd i
select null dasof
		 , branch
		 , account
		 , item_num
		 , bal_beg_rnge
		 , bal_eng_rnge
		 , calc_cd
		 , chg_freq
		 , chg_incr
     , null nxt_rate_p_date
     , tier_type_l1, base_factor_l1, action1_l1, factor1_l1, action2_l1, factor2_l1, flat_rate_l1, indx_cd_l1, pct1_l1, pct2_l1, lmt_amt_l1
     , tier_type_l2, base_factor_l2, action1_l2, factor1_l2, action2_l2, factor2_l2, flat_rate_l2, indx_cd_l2, pct1_l2, pct2_l2, lmt_amt_l2
     , start_date
     , end_date
     , accr_status
     , normal_rate
     , curr_rate
     , dly_chrg
     , chg_day
     , frst_chg_date
     , nxt_accr_date
     , null rec_sts_flag
     , tier_type_l3, base_factor_l3, action1_l3, factor1_l3, action2_l3, factor2_l3, flat_rate_l3, indx_cd_l3, pct1_l3, pct2_l3, lmt_amt_l3
     , tier_type_l4, base_factor_l4, action1_l4, factor1_l4, action2_l4, factor2_l4, flat_rate_l4, indx_cd_l4, pct1_l4, pct2_l4, lmt_amt_l4
     , tier_type_l5, base_factor_l5, action1_l5, factor1_l5, action2_l5, factor2_l5, flat_rate_l5, indx_cd_l5, pct1_l5, pct2_l5, lmt_amt_l5
     , tier2_acct  , tier3_lmt_seq , ctl4
     --[ FS-Auto change rate for Deposit guarantee
     , dep_prod_desc, inf_rate_fr_dep_flag, eff_dep_rate
  from itf_als_interest
 minus
select null dasof
		 , branch
		 , account
		 , item_num
		 , bal_beg_rnge
		 , bal_eng_rnge
		 , calc_cd
		 , chg_freq
		 , chg_incr
     , null nxt_rate_p_date
     , tier_type_l1, base_factor_l1, action1_l1, factor1_l1, action2_l1, factor2_l1, flat_rate_l1, indx_cd_l1, pct1_l1, pct2_l1, lmt_amt_l1
     , tier_type_l2, base_factor_l2, action1_l2, factor1_l2, action2_l2, factor2_l2, flat_rate_l2, indx_cd_l2, pct1_l2, pct2_l2, lmt_amt_l2
     , start_date
     , end_date
     , accr_status
     , normal_rate
     , curr_rate
     , dly_chrg
     , chg_day
     , frst_chg_date
     , nxt_accr_date
     , null rec_sts_flag
     , tier_type_l3, base_factor_l3, action1_l3, factor1_l3, action2_l3, factor2_l3, flat_rate_l3, indx_cd_l3, pct1_l3, pct2_l3, lmt_amt_l3
     , tier_type_l4, base_factor_l4, action1_l4, factor1_l4, action2_l4, factor2_l4, flat_rate_l4, indx_cd_l4, pct1_l4, pct2_l4, lmt_amt_l4
     , tier_type_l5, base_factor_l5, action1_l5, factor1_l5, action2_l5, factor2_l5, flat_rate_l5, indx_cd_l5, pct1_l5, pct2_l5, lmt_amt_l5
     , tier2_acct  , tier3_lmt_seq , ctl4
     --[ FS-Auto change rate for Deposit guarantee
     , dep_prod_desc, inf_rate_fr_dep_flag, eff_dep_rate
  from als_interest_mast;
commit;
---- change
insert --+ APPEND NOLOGGING PARALLEL
  into Als_Interest_Mast_Imd I
select F.dasof
		 , F.branch
		 , F.account
		 , F.item_num
		 , F.bal_beg_rnge
		 , F.bal_eng_rnge
		 , F.calc_cd
		 , F.chg_freq
		 , F.chg_incr
		 , F.nxt_rate_p_date
		 , F.tier_type_l1, F.base_factor_l1, F.action1_l1, F.factor1_l1, F.action2_l1, F.factor2_l1, F.flat_rate_l1, F.indx_cd_l1, F.pct1_l1, F.pct2_l1, F.lmt_amt_l1
		 , F.tier_type_l2, F.base_factor_l2, F.action1_l2, F.factor1_l2, F.action2_l2, F.factor2_l2, F.flat_rate_l2, F.indx_cd_l2, F.pct1_l2, F.pct2_l2, F.lmt_amt_l2
		 , F.start_date
		 , F.end_date
		 , F.accr_status
		 , F.normal_rate
		 , F.curr_rate
		 , F.dly_chrg
		 , F.chg_day
		 , F.frst_chg_date
		 , F.nxt_accr_date
		 , null rec_sts_flag---------
		 , F.tier_type_l3, F.base_factor_l3, F.action1_l3, F.factor1_l3, F.action2_l3, F.factor2_l3, F.flat_rate_l3, F.indx_cd_l3, F.pct1_l3, F.pct2_l3, F.lmt_amt_l3
		 , F.tier_type_l4, F.base_factor_l4, F.action1_l4, F.factor1_l4, F.action2_l4, F.factor2_l4, F.flat_rate_l4, F.indx_cd_l4, F.pct1_l4, F.pct2_l4, F.lmt_amt_l4
		 , F.tier_type_l5, F.base_factor_l5, F.action1_l5, F.factor1_l5, F.action2_l5, F.factor2_l5, F.flat_rate_l5, F.indx_cd_l5, F.pct1_l5, F.pct2_l5, F.lmt_amt_l5
		 , F.tier2_acct	 , F.tier3_lmt_seq , F.ctl4
     --[ FS-Auto change rate for Deposit guarantee
     , F.dep_prod_desc, F.inf_rate_fr_dep_flag, F.eff_dep_rate
  from Itf_Als_Interest F, Als_Interest_Mast_Imd I
 where I.account      = F.Account
   and I.Item_Num     = F.Item_Num
   and I.Bal_Beg_Rnge = F.Bal_Beg_Rnge
   and I.Bal_Eng_Rnge = F.Bal_Eng_Rnge
   and I.Start_Date   = F.Start_Date
   and I.End_Date     = F.End_Date;
commit;

---- delete new
delete from Als_Interest_Mast_Imd
 where dasof is null;

------------------------------------------------[ Step: 2 ; Stamp record status (INSERTED, UPDATED, DELETED)
begin
         execute immediate 'create unique index Als_Interest_Mast_Imd_Unq on Als_Interest_Mast_Imd( account, Item_Num, Bal_Beg_Rnge,
 Bal_Eng_Rnge, Start_Date, End_Date ) tablespace deposit_idx_ts pctfree 10 nologging parallel 2';
exception when others then
                null;
end;
/

UPDATE (
select I.rec_sts_flag i_sts,
       case when m.rowid is not null then 
                                        'UPDATED'
            else 
                        'INSERTED' 
       end rec_sts
  from Als_Interest_Mast_Imd I, Als_Interest_Mast M
 where I.account      = M.Account(+)
   and I.Item_Num     = M.Item_Num(+)
   and I.Bal_Beg_Rnge = M.Bal_Beg_Rnge(+)
   and I.Bal_Eng_Rnge = M.Bal_Eng_Rnge(+)
   and I.Start_Date   = M.Start_Date(+)
   and I.End_Date     = M.End_Date(+)
       ) X
   SET i_sts = rec_sts;
commit;

BEGIN
        FOR rec IN (
        select M.rowid mrid
  from Als_Interest_Mast M, Itf_Als_Interest T
 where M.account      = T.Account(+)
   and M.Item_Num     = T.Item_Num(+)
   and M.Bal_Beg_Rnge = T.Bal_Beg_Rnge(+)
   and M.Bal_Eng_Rnge = T.Bal_Eng_Rnge(+)
   and M.Start_Date   = T.Start_Date(+)
   and M.End_Date     = T.End_Date(+)
   and M.rec_sts_flag != 'DELETED'
   and T.rowid is null
       )
        LOOP
                update Als_Interest_Mast M
                   set M.rec_sts_flag = 'DELETED'
                 where rowid = rec.mrid;
        END LOOP;
        
        commit;
        
END;
/

------------------------------------------------[ Step: 3 ; Delete Old(Updated), Insert New
insert --+ APPEND NOLOGGING PARALLEL
  into Als_Interest_Mast_Hist
select M.dasof
     , M.branch
     , M.account
     , M.item_num
     , M.bal_beg_rnge
     , M.bal_eng_rnge
     , M.calc_cd
     , M.chg_freq
     , M.chg_incr
     , M.nxt_rate_p_date
     , M.tier_type_l1, M.base_factor_l1, M.action1_l1, M.factor1_l1, M.action2_l1, M.factor2_l1, M.flat_rate_l1, M.indx_cd_l1, M.pct1_l1, M.pct2_l1, M.lmt_amt_l1
     , M.tier_type_l2, M.base_factor_l2, M.action1_l2, M.factor1_l2, M.action2_l2, M.factor2_l2, M.flat_rate_l2, M.indx_cd_l2, M.pct1_l2, M.pct2_l2, M.lmt_amt_l2
     , M.start_date
     , M.end_date
     , M.accr_status
     , M.normal_rate
     , M.curr_rate
     , M.dly_chrg
     , M.chg_day
     , M.frst_chg_date
     , M.nxt_accr_date
     , M.rec_sts_flag
     , I.dasof Hist_Date-----
     , M.tier_type_l3, M.base_factor_l3, M.action1_l3, M.factor1_l3, M.action2_l3, M.factor2_l3, M.flat_rate_l3, M.indx_cd_l3, M.pct1_l3, M.pct2_l3, M.lmt_amt_l3
     , M.tier_type_l4, M.base_factor_l4, M.action1_l4, M.factor1_l4, M.action2_l4, M.factor2_l4, M.flat_rate_l4, M.indx_cd_l4, M.pct1_l4, M.pct2_l4, M.lmt_amt_l4
     , M.tier_type_l5, M.base_factor_l5, M.action1_l5, M.factor1_l5, M.action2_l5, M.factor2_l5, M.flat_rate_l5, M.indx_cd_l5, M.pct1_l5, M.pct2_l5, M.lmt_amt_l5
     , M.tier2_acct  , M.tier3_lmt_seq , M.ctl4
     --[ FS-Auto change rate for Deposit guarantee
     , M.dep_prod_desc, M.inf_rate_fr_dep_flag, M.eff_dep_rate
  from Als_Interest_Mast_Imd I, Als_Interest_Mast M
 where I.account      = M.Account
   and I.Item_Num     = M.Item_Num
   and I.Bal_Beg_Rnge = M.Bal_Beg_Rnge
   and I.Bal_Eng_Rnge = M.Bal_Eng_Rnge
   and I.Start_Date   = M.Start_Date
   and I.End_Date     = M.End_Date;
commit;

delete from Als_Interest_Mast M
 where rowid in
       ( select M.rowid
           from Als_Interest_Mast_Imd I, Als_Interest_Mast M
          where I.account      = M.Account
            and I.Item_Num     = M.Item_Num
            and I.Bal_Beg_Rnge = M.Bal_Beg_Rnge
            and I.Bal_Eng_Rnge = M.Bal_Eng_Rnge
            and I.Start_Date   = M.Start_Date
            and I.End_Date     = M.End_Date
       );
commit;

------------------------------------------------[ Step: 4 ; 
insert into Als_Interest_Mast
select *
  from Als_Interest_Mast_Imd;
commit;

begin
         execute immediate 'drop table interest_temp purge';
         execute immediate 'drop table Interest_Fact_imd_del purge';
exception when others then
        null;
end;
/


--
--select count(*), count(distinct account_number) from dwhadmin.interest_fact where product_key is null -- 749/54n   
begin
     execute immediate('drop table DIM_RATE_INDEX_CODE_FRTO purge');
exception when others then
     null;
end;
/
create table DIM_RATE_INDEX_CODE_FRTO
    as
select als_code
     , t.rate_index_code_key
     , NVL(t.als_effective_date, date '1900-01-01' ) fr
     , NVL(lead(als_effective_date) over
           (partition by als_code 
                order by als_effective_date) - 1
                       , date '9999-12-31')    todt
 from dwhadmin.dim_rate_index_code t;



delete from als_interest_mast f
 where end_date >= date '9999-01-01'
   and f.rec_sts_flag='DELETED' 
   and f.bal_eng_rnge = 9999999999999.99;
commit;


------------------------------------------------------------[ Insert Fact
truncate table INTEREST_FACT;
INSERT --+ APPEND NOLOGGING
  INTO INTEREST_FACT 
  	 ( ACCOUNT_NUMBER
		 , ITEM_NUMBER
		 , BALANCE_BEGIN_RANGE
		 , BALANCE_END_RANGE
		 , CALCULATION_CODE
		 , CHANGE_CYCLE
		 , NEXT_RATE_PROCESS_DATE
		 , FLAT_RATE_LINE_1, INDEX_CODE_LINE_1, PERCENTAGE_1_LINE_1, PERCENTAGE_2_LINE_1, LIMIT_AMOUNT_LINE_1
		 , FLAT_RATE_LINE_2, INDEX_CODE_LINE_2, PERCENTAGE_1_LINE_2, PERCENTAGE_2_LINE_2, LIMIT_AMOUNT_LINE_2
		 , START_DATE
		 , END_DATE
		 , ACCRU_STATUS
		 , NORMAL_RATE
		 , CURRENT_RATE
		 , DAILY_CHARGE
		 , CHANGE_RATE_DAY
		 , FIRST_CHANGE_DATE
		 , RECORD_STATUS
		 , AS_OF_DATE
		 , DATE_CREATED
		 , GECID_COMPANY
		 ------
		 , CHANGE_RATE_FREQUENCY
		 , TIER_TYPE_LINE_1
		 , BASE_FACTOR_LINE_1
		 , ACTION1_LINE_1
		 , FACTOR1_LINE_1
		 , ACTION2_LINE_1
		 , FACTOR2_LINE_1
		 , TIER_TYPE_LINE_2
		 , BASE_FACTOR_LINE_2
		 , ACTION1_LINE_2
		 , FACTOR1_LINE_2
		 , ACTION2_LINE_2
		 , FACTOR2_LINE_2
		 , ITEM_STATUS
		 , ACCOUNT_KEY
		 , CALCULATION_KEY
		 , INTEREST_INDEX_KEY_1
		 , INTEREST_INDEX_KEY_2
		 , BRANCH_KEY 
		 ------ pns rate
		 , tier_type_l3, base_factor_l3, action1_l3, factor1_l3, action2_l3, factor2_l3, flat_rate_l3, indx_cd_l3, pct1_l3, pct2_l3, lmt_amt_l3
		 , tier_type_l4, base_factor_l4, action1_l4, factor1_l4, action2_l4, factor2_l4, flat_rate_l4, indx_cd_l4, pct1_l4, pct2_l4, lmt_amt_l4
		 , tier_type_l5, base_factor_l5, action1_l5, factor1_l5, action2_l5, factor2_l5, flat_rate_l5, indx_cd_l5, pct1_l5, pct2_l5, lmt_amt_l5
		 , tier2_acct	, tier3_lmt_seq	, ctl4
		 --[ FS-Auto change rate for Deposit guarantee
		 , dep_prod_desc, inf_rate_fr_dep_flag, eff_dep_rate
		  )
SELECT ACCOUNT
     , ITEM_NUM
     , BAL_BEG_RNGE
     , BAL_ENG_RNGE
     , CALC_CD CALC_CD
     , CHG_INCR CHG_INCR
     , NXT_RATE_P_DATE
     , FLAT_RATE_L1, INDX_CD_L1, PCT1_L1, PCT2_L1, LMT_AMT_L1
     , FLAT_RATE_L2, INDX_CD_L2, PCT1_L2, PCT2_L2, LMT_AMT_L2
     , START_DATE
     , END_DATE
     , ACCR_STATUS
     , NORMAL_RATE
     , CURR_RATE
     , DLY_CHRG
     , CHG_DAY
     , FRST_CHG_DATE
     , REC_STS_FLAG
     , DASOF AS_OF_DATE
     , DASOF DATE_CREATED
     , 50000000 GECID_COMPANY
     , case when ( A.CHG_FREQ = 'D' ) then 'DAY'
            when ( A.CHG_FREQ = 'M' ) then 'MONTH'
            else A.CHG_FREQ
        end Change_Rate_Frequency
     , case when ( A.TIER_TYPE_L1 = 'C' ) then 'CALCULATE'
            when ( A.TIER_TYPE_L1 = 'F' ) then 'FLAT RATE'
            when ( A.TIER_TYPE_L1 = 'E' ) then 'EQUAL'
            else A.TIER_TYPE_L1
        end TIER_TYPE_LINE_1
     , case when (A.BASE_FACTOR_L1 = 'I' ) then 'Index Code'
            when (A.BASE_FACTOR_L1 = '1' ) then 'Percentage 1'
            when (A.BASE_FACTOR_L1 = '2' ) then 'Percentage 2'
            else A.BASE_FACTOR_L1
        end BASE_FACTOR_LINE_1
     , case when (A.ACTION1_L1 = 'A' ) then '+'
            when (A.ACTION1_L1 = 'D' ) then '/'
            when (A.ACTION1_L1 = 'M' ) then '*'
            when (A.ACTION1_L1 = 'S' ) then '-'
            else A.ACTION1_L1
        end ACTION1_LINE_1
     , case when ( A.FACTOR1_L1 = '1' ) then 'Percentage 1'
            when ( A.FACTOR1_L1 = '2' ) then 'Percentage 2'
            else A.FACTOR1_L1
        end FACTOR1_LINE_1
     , case when ( A.ACTION2_L1 = 'A' ) then '+'
            when ( A.ACTION2_L1 = 'D' ) then '/'
            when ( A.ACTION2_L1 = 'M' ) then '*'
            when ( A.ACTION2_L1 = 'S' ) then '-'
            else A.ACTION2_L1
        end ACTION2_LINE_1
     , case when ( A.FACTOR2_L1  = '1' ) then 'Percentage 1'
            when ( A.FACTOR2_L1  = '2' ) then 'Percentage 2'
            else A.FACTOR2_L1
        end FACTOR2_LINE_1
     , case when ( A.TIER_TYPE_L2  = 'C' ) then 'CALCULATE'
            when ( A.TIER_TYPE_L2  = 'F' ) then 'FLAT RATE'
            when ( A.TIER_TYPE_L2  = 'E' ) then 'EQUAL'
            else A.TIER_TYPE_L2
        end TIER_TYPE_LINE_2
     , case when ( A.BASE_FACTOR_L2 = 'I' ) then 'Index Code'
            when ( A.BASE_FACTOR_L2 = '1' ) then 'Percentage 1'
            when ( A.BASE_FACTOR_L2 = '2' ) then 'Percentage 2'
            else A.BASE_FACTOR_L2
        end BASE_FACTOR_LINE_2
     , case when (A.ACTION1_L2 = 'A' ) then '+'
            when (A.ACTION1_L2 = 'D' ) then '/'
            when (A.ACTION1_L2 = 'M' ) then '*'
            when (A.ACTION1_L2 = 'S' ) then '-'
            else A.ACTION1_L2
        end ACTION1_LINE_2
     , case when ( A.FACTOR1_L2 = '1' ) then 'Percentage 1'
            when ( A.FACTOR1_L2 = '2' ) then 'Percentage 2'
            else A.FACTOR1_L2
        end FACTOR1_LINE_2
     , case when ( A.ACTION2_L2  = 'A' ) then '+'
            when ( A.ACTION2_L2  = 'D' ) then '/'
            when ( A.ACTION2_L2  = 'M' ) then '*'
            when ( A.ACTION2_L2  = 'S' ) then '-'
            else A.ACTION2_L2
        end ACTION2_LINE_2
     , case when ( A.FACTOR2_L2  = '1' ) then 'Percentage 1'
            when ( A.FACTOR2_L2  = '2' ) then 'Percentage 2'
            else A.FACTOR2_L2
        end FACTOR2_LINE_2
     --, case when A.dasof between A.start_date and A.end_date
     ,case when to_date('&1','DDMMYYYY')  between A.start_date and A.end_date
            and REC_STS_FLAG!='DELETED'
              then 'Active'
           else 'Inactive'
       end Item_Status
     , Ac.Account_Key
     , Cl.Calculation_Key
     , K1.RATE_INDEX_CODE_KEY  INTEREST_INDEX_KEY_1
     , K2.RATE_INDEX_CODE_KEY  INTEREST_INDEX_KEY_2
     , Br.Branch_Key
     -- List Of Keys ACCOUNT_KEY  BRANCH_KEY         PRODUCT_KEY          -- CUSTOMER_KEY         -- DEMOGRAPHICS_KEY    
     -- INTEREST_INDEX_KEY_1    INTEREST_INDEX_KEY_2    CALCULATION_KEY  
     ------ pns rate
     , A.tier_type_l3, A.base_factor_l3, A.action1_l3, A.factor1_l3, A.action2_l3, A.factor2_l3, A.flat_rate_l3, A.indx_cd_l3, A.pct1_l3, A.pct2_l3, A.lmt_amt_l3
     , A.tier_type_l4, A.base_factor_l4, A.action1_l4, A.factor1_l4, A.action2_l4, A.factor2_l4, A.flat_rate_l4, A.indx_cd_l4, A.pct1_l4, A.pct2_l4, A.lmt_amt_l4
     , A.tier_type_l5, A.base_factor_l5, A.action1_l5, A.factor1_l5, A.action2_l5, A.factor2_l5, A.flat_rate_l5, A.indx_cd_l5, A.pct1_l5, A.pct2_l5, A.lmt_amt_l5
     , A.tier2_acct  , A.tier3_lmt_seq , A.ctl4
     --[ FS-Auto change rate for Deposit guarantee
     , A.dep_prod_desc, A.inf_rate_fr_dep_flag, A.eff_dep_rate
  from Als_Interest_Mast A, account Ac
     , DIM_CALCULATION CL
     , DIM_RATE_INDEX_CODE_FRTO K1
     , DIM_RATE_INDEX_CODE_FRTO K2
     , AUTO_BRANCH Br
 where CALCULATION_CODE = nvl( A.Calc_Cd , 'DUMMY')
   and K1.ALS_CODE      = nvl(A.Indx_Cd_L1, 'N/A')
   and a.dasof          between k1.fr AND k1.todt
   and K2.ALS_CODE      = nvl(A.Indx_Cd_L2, 'N/A')
   and a.dasof          between k2.fr AND k2.todt
   and A.Account        = Ac.Account_Number
   and lpad(Br.branch_code,4,'0')   =  lpad(nvl(A.Branch, '0000'),4,'0')
   and Br.Gecid         = 50000000
   and Ac.appl_id       ='ALS';
   COMMIT;


create table Interest_Fact_imd_del
nologging as
select Rn
     , FRID 
  from (SELECT row_number() over (partition by i.account_number, i.item_number, i.balance_begin_range,i.balance_end_range, Start_Date
																			order by i.as_of_date desc) rn
             , i.ROWID FRID
          FROM dwhadmin.Interest_Fact i
       ) where rn>=2;

insert 
  into Interest_Fact_imd_del
select Rn
     , FRID
  from (SELECT row_number() over (partition by i.account_number, i.item_number, i.balance_begin_range,Start_Date, End_Date
         														  order by i.as_of_date desc) rn
						 , i.ROWID FRID
          FROM dwhadmin.Interest_Fact i
       ) where rn>=2;

delete from dwhadmin.interest_fact f
 where rowid in (select frid from interest_fact_imd_del where rn>1);
commit;

create table  interest_temp as
select --+parallel( x , 8 ) 
distinct x.account_number, p.product_key, p.gecid,
       ( select --+index( c , CUSREF_CUST_NO_BUS_GECID )
           c.customer_key from dwhadmin.cusref c
          where x.customer_number = c.customer_number
            and c.gecid = 50000000
            and c.business_type not in ('PROF', 'DEP' )
            and rownum<=1 ) ckey
  from dwhadmin.gain_customer_bank_wbase x ,
       dwhadmin.product p
 where x.account_number
       in ( select --+parallel( f , 8 )
       distinct account_number from dwhadmin.interest_fact f where product_key is null )
   and x.customer_type = 'B'
   and x.org           = p.org
   and x.logo          = p.logo
   and x.del_flag is null;

   
alter table  INTEREST_TEMP add constraint PK_INTEREST_TEMP primary key (ACCOUNT_NUMBER) using index ;

update(select f.product_key,f.customer_key,f.demographics_key,f.gecid
             ,x.product_key upd_product_key,x.ckey upd_ckey,x.gecid upd_gecid
         from dwhadmin.interest_fact  F, dwhadmin.interest_temp x
        where f.account_number = x.account_number
 )set product_key      = upd_product_key
    , customer_key     = upd_ckey
    , demographics_key = upd_ckey
    , gecid            = upd_gecid;
COMMIT;



EXEC proc_audit_job('e',7,'Loan(ALS)','D',to_date('&1','DDMMYYYY'),100,'PROCESSFINISHED',null);

disc
exit

