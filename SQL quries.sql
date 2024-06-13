select * from fin1;
select * from fin2;

desc fin2;
update fin2 set last_pymnt_d = str_to_date(last_pymnt_d,'%d%m%Y');    -- Change to Date Format
alter table fin2 modify last_pymnt_d date;                            -- Change datatype text to String


desc fin1;
update fin1 set issue_d = str_to_date(issue_d,'%d%m%Y');
alter table fin1 modify issue_d date;


-- KPI 1 Year wise loan amount Stats
select year(issue_d) Year ,concat("$",round(sum(Loan_amnt)/1000000,2)," M") as Loan_Amnt 
from fin1 group by Year;

-- KPI 2 Grade and sub grade wise revol_bal
select f1.grade,f1.sub_grade,concat("$",round(sum(f2.revol_bal)/1000000,2)," M") as Rev_Balance
from fin1 f1 inner join fin2 f2 on f1.id=f2.id 
group by f1.grade,f1.sub_grade order by grade;

-- KPI 3 Total Payment for Verified Status Vs Total Payment for Non Verified Status
select f1.verification_status,concat("$",Round(sum(f2.total_pymnt)/1000000,2)," M") as Total_payment
from fin1 f1 inner join fin2 f2 on f1.id=f2.id
where f1.verification_status != "Source Verified" 
group by f1.verification_status ;

-- KPI 4 State wise and month wise loan status
select addr_state, monthname(issue_d) as Month ,loan_status , count(id) as Loans_Count,concat("$",floor(sum(loan_amnt)/1000)," K") as Total_Loans
from fin1 group by addr_state,Month,loan_status
order by addr_state,Month,loan_status;

-- KPI 5 Home ownership Vs last payment date stats
select f1.home_ownership as Home_Ownership,
concat(monthname(f2.last_pymnt_d),"-",year(f2.last_pymnt_d)) as Last_paymnt_Date,
concat("$",round(sum(f2.last_pymnt_amnt)/1000,0)," K") as Last_Payment_Amt
from fin1 f1 inner join fin2 f2 on f1.id=f2.id 
group by Home_Ownership,Last_paymnt_Date order by Home_Ownership ; 

