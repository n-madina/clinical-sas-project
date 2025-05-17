libname dm xport '/home/u64018816/myproject/dm.xpt';
libname ds xport '/home/u64018816/myproject/ds.xpt';
libname mi xport '/home/u64018816/myproject/mi.xpt';
libname pr xport '/home/u64018816/myproject/pr.xpt';
libname ss xport '/home/u64018816/myproject/ss.xpt';
libname tu xport '/home/u64018816/myproject/tu.xpt';
libname tr xport '/home/u64018816/myproject/tr.xpt';
libname mydata '/home/u64018816/myproject/';

data mydata.dm; set dm.dm_postg; run;
data mydata.ds; set ds.ds_postg; run;
data mydata.mi; set mi.mi_postg; run;
data mydata.pr; set pr.pr_postg; run;
data mydata.ss; set ss.ss_postg; run;
data mydata.tu; set tu.tu_postg; run;
data mydata.tr; set tr.tr_postg; run;

data mydata.dm_clean;
    set mydata.dm;
    length age 8;
    if age < 0 or age > 120 then age = .;
    if sex in ('', '.', '-') or missing(sex) then sex = 'U'; else sex = upcase(sex);
    if race in ('', '.', '-') or missing(race) then race = 'Unknown'; else race = propcase(race);
    if ethnic in ('', '.', '-') or missing(ethnic) then ethnic = 'Unknown'; else ethnic = propcase(ethnic);
    if country in ('', '.', '-') or missing(country) then country = 'UNKNOWN'; else country = upcase(country);
    if ageu in ('', '.', '-') or missing(ageu) then ageu = 'Years'; else ageu = propcase(ageu);
    retain studyid domain usubjid subjid rfstdtc rfendtc siteid brthdtc age ageu sex race dmxfn ethnic country;
run;

data mydata.ds_clean;
    set mydata.ds;
    length dsdecod dsterm dsspid dscat epoch $100;
    if strip(dsterm) in ('', '.', '-') or missing(dsterm) then dsterm = 'Unknown'; else dsterm = propcase(strip(dsterm));
    if strip(dsdecod) in ('', '.', '-') or missing(dsdecod) then dsdecod = 'Unknown'; else dsdecod = upcase(strip(dsdecod));
    if strip(dsspid) in ('', '.', '-') or missing(dsspid) then dsspid = 'Unknown'; else dsspid = upcase(strip(dsspid));
    if strip(dsstdtc) in ('', '.', '-') or missing(dsstdtc) then dsstdtc = '';
    if strip(dsdtc) in ('', '.', '-') or missing(dsdtc) then dsdtc = '';
    if dsdecod = 'DISEASE RELAPSE' then relapse = 'Y'; else relapse = 'N';
    retain studyid domain usubjid dsseq dsdecod dsterm dsspid dsstdtc relapse;
    keep studyid domain usubjid dsseq dsdecod dsterm dsspid dsstdtc relapse;
run;

data mydata.mi_clean;
    set mydata.mi;
    array checkchars _character_;
    do over checkchars;
        if missing(checkchars) or strip(checkchars) in ('', '.', '-') then checkchars = 'Unknown';
    end;
    mitestcd = upcase(strip(mitestcd));
    mitest = propcase(strip(mitest));
    miorres = propcase(strip(miorres));
    mistresc = propcase(strip(mistresc));
    mispec = upcase(strip(mispec));
    miloc = upcase(strip(miloc));
run;

data mydata.pr_clean;
    set mydata.pr;
    label PRTRT = "Name of Procedure"
          PRDECOD = "Standardized Procedure Name"
          PRCAT = "Category for Procedure"
          PRSCAT = "Subcategory for Procedure"
          PRSTDTC = "Start Date of Procedure";
run;

data mydata.ss_clean;
    set mydata.ss;
    ssorres = propcase(ssorres);
    label STUDYID = "Study Identifier"
          DOMAIN = "Domain Abbreviation"
          USUBJID = "Unique Subject Identifier"
          SSSEQ = "Sequence Number"
          SSTESTCD = "Short Name of Subject Status Test"
          SSTEST = "Subject Status Test Name"
          SSORRES = "Original Result";
run;

data mydata.tr_clean;
    set mydata.tr;
    TRTEST = propcase(TRTEST);
    TRMETHOD = propcase(TRMETHOD);
    VISIT = propcase(VISIT);
    DOMAIN = upcase(DOMAIN);
run;

data mydata.tu_clean;
    set mydata.tu;
    if missing(TULOC) or strip(TULOC) = '' then TULOC = 'Unknown'; else TULOC = propcase(TULOC);
    if missing(TULAT) or strip(TULAT) = '' then TULAT = 'Unknown'; else TULAT = propcase(TULAT);
    if missing(TUMETHOD) or strip(TUMETHOD) = '' then TUMETHOD = 'Unknown'; else TUMETHOD = propcase(TUMETHOD);
    DOMAIN = upcase(DOMAIN);
run;

data mydata.dm_final;
    set mydata.dm_clean;
    length ARM $200 ARMCD $10 COUNTRY $200 ETHNIC $200 BRTHDTC RFSTDTC RFENDTC $20;
    DOMAIN = 'DM';
    ARM = '';
    ARMCD = '';
    ETHNIC = propcase(ETHNIC);
    COUNTRY = upcase(COUNTRY);
    RACE = propcase(RACE);
    SEX = upcase(SEX);
    label STUDYID = "Study Identifier"
          DOMAIN = "Domain Abbreviation"
          USUBJID = "Unique Subject Identifier"
          SUBJID = "Subject Identifier for the Study"
          RFSTDTC = "Subject Reference Start Date/Time"
          RFENDTC = "Subject Reference End Date/Time"
          SITEID = "Study Site Identifier"
          BRTHDTC = "Date/Time of Birth"
          AGE = "Age"
          AGEU = "Age Units"
          SEX = "Sex"
          RACE = "Race"
          ETHNIC = "Ethnicity"
          COUNTRY = "Country"
          ARM = "Description of Planned Arm"
          ARMCD = "Planned Arm Code";
    keep STUDYID DOMAIN USUBJID SUBJID RFSTDTC RFENDTC SITEID BRTHDTC AGE AGEU SEX RACE ETHNIC COUNTRY ARM ARMCD;
run;

data mydata.ds_final;
    set mydata.ds_clean;
    length DSSTDTC $20 RELAPSE $1;
    DOMAIN = 'DS';
    if missing(dsstdtc) or strip(dsstdtc) in ('', '.', '-') then DSSTDTC = ''; else DSSTDTC = dsstdtc;
    if upcase(dsdecod) = 'DISEASE RELAPSE' then relapse = 'Y'; else relapse = 'N';
    label STUDYID = "Study Identifier"
          DOMAIN = "Domain Abbreviation"
          USUBJID = "Unique Subject Identifier"
          DSSEQ = "Sequence Number"
          DSSPID = "Sponsor-Defined Identifier"
          DSTERM = "Trial-Specific Term"
          DSDECOD = "Dictionary-Derived Term"
          DSSTDTC = "Start Date/Time of Disease Status"
          RELAPSE = "Relapse Flag";
    keep STUDYID DOMAIN USUBJID DSSEQ DSSPID DSTERM DSDECOD DSSTDTC RELAPSE;
run;

data mydata.mi_final;
    set mydata.mi_clean;
    array char_vars _character_;
    do over char_vars;
        if missing(char_vars) or strip(char_vars) in ('', '.', '-') then char_vars = 'Unknown';
    end;
    mitestcd = upcase(strip(mitestcd));
    mitest = propcase(strip(mitest));
    miorres = propcase(strip(miorres));
    mistresc = propcase(strip(mistresc));
    mispec = upcase(strip(mispec));
    miloc = upcase(strip(miloc));
    keep studyid domain usubjid miseq mitestcd mitest miorres mistresc mispec miloc;
run;

data mydata.pr_final;
    set mydata.pr_clean;
    prtrt = propcase(strip(prtrt));
    prdecod = upcase(strip(prdecod));
    prcat = upcase(strip(prcat));
    prscat = upcase(strip(prscat));
    length prstdtc $10;
    prstdtc = strip(prstdtc);
    keep studyid domain usubjid prseq prtrt prdecod prcat prscat prstdtc;
run;

data mydata.ss_final;
    set mydata.ss_clean;
    studyid = strip(studyid);
    domain = upcase(strip(domain));
    usubjid = strip(usubjid);
    ssseq = input(ssseq, best.);
    sstestcd = upcase(strip(sstestcd));
    sstest = propcase(strip(sstest));
    ssorres = propcase(strip(ssorres));
    keep studyid domain usubjid ssseq sstestcd sstest ssorres;
run;

data mydata.tr_final;
    set mydata.tr_clean;
    studyid = strip(studyid);
    domain = upcase(strip(domain));
    usubjid = strip(usubjid);
    trseq = input(trseq, best.);
    visitnum = input(visitnum, best.);
    trtestcd = upcase(strip(trtestcd));
    trtest = propcase(strip(trtest));
    trorres = strip(trorres);
    trorresu = upcase(strip(trorresu));
    trstresc = strip(trstresc);
    trstresn = input(trstresn, best.);
    trstresu = upcase(strip(trstresu));
    trmethod = propcase(strip(trmethod));
    visit = propcase(strip(visit));
    if not missing(trdtc) then do;
        trdtc_date = input(trdtc, yymmdd10.);
        format trdtc_date yymmdd10.;
    end;
    else trdtc_date = .;
    drop trdtc;
    rename trdtc_date = trdtc;
    keep studyid domain usubjid trseq trlnkid trtestcd trtest trorres trorresu trstresc trstresn trstresu trmethod visitnum visit trdtc;
run;

data mydata.tu_final;
    set mydata.tu_clean;
    length STUDYID DOMAIN USUBJID TULNKID TUTESTCD TUTEST TUORRES TULOC TULAT TUMETHOD TUDTC $200;
    length TUID $20;
    DOMAIN = 'TU';
    if missing(TUSEQ) then TUSEQ = .;
    TUID = catx("-", "TUMOR", put(_N_, z3.));
    keep STUDYID DOMAIN USUBJID TUSEQ TUID TULNKID TUTESTCD TUTEST TUORRES TULOC TULAT TUMETHOD TUDTC;
run;

ods _all_ close;
ods rtf file="/home/u64018816/myproject/clinical_summaryoutput.rtf" style=journal;

title "Demographic Summary by Sex and Race";
proc freq data=mydata.dm_final;
    tables sex*race / missing;
run;

proc means data=mydata.dm_final n mean std min max;
    var age;
run;

title "Disposition Summary";
proc freq data=mydata.ds_final;
    tables dsdecod;
run;

title "Subjects Who Experienced Disease Relapse";
proc print data=mydata.ds_final noobs;
    where relapse = 'Y';
    var usubjid dsdecod dsstdtc;
run;

title "Frequency of Molecular Tests";
proc freq data=mydata.mi_final;
    tables mitestcd;
run;

title "Listing of Procedures Performed";
proc print data=mydata.pr_final noobs;
    var usubjid prtrt prdecod prcat prscat prstdtc;
run;

title "Listing of Disease Status by Visit";
proc print data=mydata.ss_final noobs;
    var usubjid sstestcd ssorres;
run;

title "Summary of Target Lesion Measurements";
proc means data=mydata.tr_final n mean std min max;
    var trstresn;
run;

title "Count of Tumor Records per Subject";
proc freq data=mydata.tu_final;
    tables usubjid / nocum nopercent;
run;

title "Distribution of Tumor Test Codes";
proc freq data=mydata.tu_final;
    tables tutestcd;
run;

ods rtf close;