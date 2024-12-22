
cd "C:\Users\lyja3\Dropbox\RA_6_\Survey\세훈쌤분석"

use "survey_rawdata", clear 


{******************************************************************************** Demographic variables
*gender
gen sex= q1 == 1
label variable sex "성별"

label define sexlbl 1 "남자" 0 "여자"
label values sex sexlbl

*age 
rename q3 agegroup

label variable agegroup "연령"
label define agegrouplbl 1 "20대" 2 "30대" 3 "40대" 4 " 50대" 5 "60대"
label values agegroup agegrouplbl

*tapital/non-capital
gen metro = (q4 ==1 | q4 ==4 | q4==8)  

label variable metro "수도권"
label define metrolbl 1 "수도권" 0 "비수도권"
label values metro metrolbl	

*region
gen region = 1 if q4 ==1 | q4 ==4 | q4==8 
replace region = 2 if q4 ==2 | q4 ==3 |q4 ==7 | q4 ==14 | q4 ==15 
replace region = 3 if q4 ==9 
replace region = 4 if q4 == 6 | q4 ==10 | q4 ==11 | q4 ==17
replace region = 5 if q4 == 5 | q4==12 | q4==13 
replace region = 6 if q4 == 16 

label variable region "지역"
label define regionlbl 1 "수도권" 2 "부산,대구,울산,경상도" 3 "강원" 4 "대전/세종/충청" 5 "광주/전라" 6 "제주" 
label values region regionlbl		

*education status
gen educ= 1 if q118<=4
replace educ =2 if q118 == 5   
replace educ =3 if q118>=6

label variable educ "최종학력"
label define educlbl 1 "고졸이하" 2 "전문대졸" 3"대졸이상"
label values educ educlbl
		

*marriage
gen mar = q76 ==1

label variable mar "혼인관계"
label define marlbl 1 "기혼" 0 "미혼/이혼/사별"
label values mar marlbl
 
 
*job
gen job = 1 if q115 ==.
replace job = 2 if q115 == 1 
replace job = 3 if q115 == 2 
replace job = 4 if q115 == 3 
replace job = 5 if q115 == 4

label variable job "직종"
label define joblbl 1 "무직" 2 "사무직" 3 "생산직" 4 "개발자" 5 "전문직"
label values job joblbl

*housing
gen housing = q113 == 1

label variable housing "주택 소유"
label define housinglbl 1 "주택 소유" 0 "전/월세"
label values housing housinglbl

*income
rename q120 inc

label variable inc "소득"
label define inclbl 1 "200만원 미만" 2 "200~300만원" 3 "300~400만원" 4 "400~500만원" 5 "500~600만원" 6 "600만원이상"
label values inc inclbl

*religion
replace q117=5 if q117==6
rename q117 relig

label variable relig "종교"
label define rellbl 1 "무종교" 2 "개신교" 3 "천주교" 4 "불교" 5 "기타"
label values relig rellbl

*asset size
rename q121 asset 

label variable asset "자산규모"
label define astlbl 1 "5천만원 미만" 2 "5천만원~3억원" 3 "3억원~6억원" 4 "6억원~9억원" 5 "9억원~12억원" 6 "12억원 이상"
label values asset astlbl

}


{********************************************************************************* Section 1 위험선호 
*Q5 
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q5 `x', robust

local z: variable label q5
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "위험을 감수할 확률이 높다") size(small)) ///
name(gr1, replace) 


local z: variable label q5
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" 2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "위험을 감수할 확률이 높다") size(small)) name(gr1, replace) 


*Q6
replace q6 = 0 if q6==2

local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q6 `x', robust 

local z: variable label q6
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q1-2. 귀하는 40%의 확률로 20만원을 얻고, 60% 확률로 아무 것도 얻지 못하는 복권과 확실한 10만원 중 무엇을 선택?", size(vsmall))  legend(order(2 "40% 확률로 20만원을 더 선호한다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q7
replace q7 = 0 if q7==2

local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q7 `x', robust

local z: variable label q7
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q1-3. 귀하는 50%의 확률로 20만원을 얻고, 50% 확률로 아무 것도 얻지 못하는 복권과 확실한 10만원 중 무엇을 선택?", size(vsmall)) legend(order(2 "50% 확률로 20만원을 더 선호한다") size(small)) ///
name(gr1, replace) 

*Q8
replace q8 = 0 if q8==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q8 `x', robust

local z: variable label q8
coefplot , drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q1-3. 귀하는 60%의 확률로 20만원을 얻고, 50% 확률로 아무 것도 얻지 못하는 복권과 확실한 10만원 중 무엇을 선택?", size(vsmall)) legend(order(2 "60% 확률로 20만원을 더 선호한다") size(small)) ///
name(gr2, replace)


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q9 
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q9 `x', robust 

local z: variable label q9
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "미래를 위해 오늘을 포기할 확률이 높다") size(small)) ///
name(gr1, replace) 


*Q10 
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q10 `x', robust 

local z: variable label q10
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "더 많은 돈을 기부할 확률이 높다") size(small)) ///
name(gr2, replace) 



graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace

}

{********************************************************************************* Section 2 거시정책
*Q11 
replace q11 = 0 if q11==2

local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q11 `x', robust 

local z: variable label q11
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "물가상승이 경기침체보다 더 나쁘다") size(small)) ///
name(gr1, replace) 


*Q12 
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q12 `x', robust 

local z: variable label q12
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "금리가 더 낮아져야 한다고 생각할 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace




** Q13_1
*소비세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q13_1 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(1)) post


local z: variable label q13_1
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "1순위는 법인세보다 소비세라고 생각할 가능성이 높다") size(small)) ///
name(gr1, replace) 

*소득세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q13_1 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(2)) post

local z: variable label q13_1
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "1순위는 법인세보다 소득세라고 생각할 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*재산세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q13_1 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(4)) post

local z: variable label q13_1
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "1순위는 법인세보다 재산세라고 생각할 가능성이 높다") size(small)) ///
name(gr1, replace) 

*부가가치세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q13_1 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(5)) post

local z: variable label q13_1
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "1순위는 법인세보다 부가가치세라고 생각할 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



** Q13_2
*소비세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q13_2 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(1)) post


local z: variable label q13_2
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "2순위는 법인세보다 소비세라고 생각할 가능성이 높다")size(small) ) ///
name(gr1, replace) 

*소득세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q13_2 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(2)) post

local z: variable label q13_2
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "2순위는 법인세보다 소득세라고 생각할 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*재산세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q13_2 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(4)) post

local z: variable label q13_2
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "2순위는 법인세보다 재산세라고 생각할 가능성이 높다") size(small)) ///
name(gr1, replace) 

*부가가치세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q13_2 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(5)) post

local z: variable label q13_2
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "2순위는 법인세보다 부가가치세라고 생각할 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



** Q14
replace q14 = 0 if q14==2
*1번
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q14 `x', robust 

local z: variable label q14
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "고소득자 증세보다 세금을 내지 않는 사람들을 축소하여 과세 기반 확대을 해야한다") size(small)) ///
name(gr1, replace) 

graph combine gr1 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q15
replace q15 = 0 if q15==2

local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q15 `x', robust 

local z: variable label q15
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "상속세 및 증여세 찬성") size(small)) ///
name(gr1, replace) 


*Q16 
replace q16 = 0 if q16==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q16 `x', robust 

local z: variable label q16
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "금융투자세 찬성") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q17
replace q17 = 0 if q17==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q17 `x', robust 

local z: variable label q17
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "거시경제 및 금융시장 안정을 위해 정부는 개입해야한다") size(small)) ///
name(gr1, replace) 



*Q18
replace q18 = 0 if q18==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q18 `x', robust 

local z: variable label q18
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "기업보다 경제개발 5개년 계획 등 정부의 역량이다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace

}

{********************************************************************************* Section 3 교육정책
*Q19
replace q19 = 0 if q19==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q19 `x', robust 

local z: variable label q19
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}"  1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "등록금 인상을 통해 대학교육의 질을 개선해야한다") size(small)) ///
name(gr1, replace) 



*Q20
replace q20 = 0 if q20==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q20 `x', robust 

local z: variable label q20
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "수능성적 등 공통의 기준보다 대학별로 입시기준을 자율화할 수 있어야 한다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q21
replace q21 = 0 if q21==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q21 `x', robust 

local z: variable label q21
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "국가장학금은 소득분위에 따라 선별적 지원되어야 한다") size(small)) ///
name(gr1, replace) 



*Q22
replace q22 = 0 if q22==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q22 `x', robust 

local z: variable label q22
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "교육 불평등을 야기하는 자사고, 외고를 폐지해야 한다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q23
replace q23 = 0 if q23==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q23 `x', robust 

local z: variable label q23
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q3-5. 학령인구 감소 등을 감안해 초중등교육에 대한 지원 축소 및 고등교육 지원을 강화해야 한다는 주장에 동의?", size(vsmall)) legend(order(2 "동의한다") size(small)) ///
name(gr1, replace) 



*Q24
replace q24 = 0 if q24==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q24 `x', robust 

local z: variable label q24
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "동의한다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q25
replace q25 = 0 if q25==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q25 `x', robust 

local z: variable label q25
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "예") size(small)) ///
name(gr1, replace) 



*Q26
replace q26 = 0 if q26==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q26 `x', robust 

local z: variable label q26
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "대학 무전공 제도를 찬성한다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace

}

{********************************************************************************* Section 4 고용노동정책

*Q27
replace q27 = 0 if q27==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q27 `x', robust 

local z: variable label q27
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "직무급/성과급보다 연공제/호봉제를 선호한다") size(small)) ///
name(gr1, replace) 



*Q28
replace q28 = 0 if q28==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q28 `x', robust 

local z: variable label q28
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "근로시간 관리는 주 단위보다 월 또는 분기 단위로 이루어져야 한다.") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q29
replace q29 = 0 if q29==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q29 `x', robust 

local z: variable label q29
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "정규직 근로자와 비정규직 근로자의 임금은 동일해야 한다") size(small)) ///
name(gr1, replace) 



*Q30
replace q30 = 0 if q30==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q30 `x', robust 

local z: variable label q30
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "원활한 일자리/청년층 일자리를 위해 고용 및 해고 요건은 완화되어야 한다.") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace




*Q31
replace q31 = 0 if q31==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q31 `x', robust 

local z: variable label q31
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "지난 5년간 최저임금 상승은 고용을 감소시킨 것 같다") size(small)) ///
name(gr1, replace) 



*Q32
replace q32 = 0 if q32==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q32 `x', robust 

local z: variable label q32
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "지난 5년간 최저임금 상승은 물가를 올린 것 같다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace




*Q33
replace q33 = 0 if q33==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q33 `x', robust 

local z: variable label q33
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "지난 5년간 최저임금 상승은 소득을 개선시킨 것 같다") size(small)) ///
name(gr1, replace) 



*Q34
replace q34 = 0 if q34==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q34 `x', robust 

local z: variable label q34
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "정년 연장은 고령화 대처를 위해 필요하다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace





*Q35
replace q35 = 0 if q35==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q35 `x', robust 

local z: variable label q35
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "저소득층 가구의 소득 보전에 최저임금이 근로장려세제보다 더 효과적") size(small)) ///
name(gr1, replace) 



*Q36
replace q36 = 0 if q36==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q36 `x', robust 

local z: variable label q36
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "경영자의 형사처벌규정이 부족하다고 느낄 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q37
replace q37 = 0 if q37==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q37 `x', robust 

local z: variable label q37
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "노란봉투법은 근로자 권리를 위해 필요하다") size(small)) ///
name(gr1, replace) 



*Q38
replace q38 = 0 if q38==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q38 `x', robust 

local z: variable label q38
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "수급기간보다 수급액을 축소해야한다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q39
replace q39 = 0 if q39==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q39 `x', robust 

local z: variable label q39
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "노동시장의 성별 격차 해소를 위해 정부의 개입이 필요하다") size(small)) ///
name(gr1, replace) 


graph combine gr1 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace

}

{********************************************************************************* Section 5 지역균형발전
*Q40
replace q40 = 0 if q40==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q40 `x', robust 

local z: variable label q40
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "세종시 건설은 지역균형발전에 기여했다고 생각한다") size(small)) ///
name(gr1, replace) 


*Q41
replace q41 = 0 if q41==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q41 `x', robust 

local z: variable label q41
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "메가시티 정책은 도시 경쟁력 강화 및 생활권 효율화를 위해 필요하다.") size(small)) ///
name(gr2, replace) 



graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace




*Q42
replace q42 = 0 if q42==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q42 `x', robust 

local z: variable label q42
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "금융기관 대출을 통해 전세금 지급이 원활해지도록 해야 한다.") size(small)) ///
name(gr1, replace) 


*Q43
replace q43 = 0 if q43==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q43 `x', robust 

local z: variable label q43
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "매매가격을 장기적으로 상승시키므로 줄여나가야 한다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q44
replace q44 = 0 if q44==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q44 `x', robust 

local z: variable label q44
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "주거정책의 방향은 저소득층을 위한 임대주택 지원을 우선시해야 한다.") size(small)) ///
name(gr1, replace) 




*Q45
replace q45 = 0 if q45==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q45 `x', robust 

local z: variable label q45
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "임차인 권리를 강화하는 방향으로 규제를 강화해야 한다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace




*Q46
replace q46 = 0 if q46==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q46 `x', robust 

local z: variable label q46
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "예타는 효율적인 재정 활용을 위해 강화되어야 한다.") size(small)) ///
name(gr1, replace) 




*Q47
replace q47 = 0 if q47==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q47 `x', robust 

local z: variable label q47
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "한 곳 집중보다 광역시, 도 내에서도 균형발전을 추구해야 한다.") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


}

{********************************************************************************* Section 6 산업/기술
*Q48
replace q48 = 0 if q48==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q48 `x', robust 

local z: variable label q48
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "연구개발 지원예산에 비효율이 있고, 연구 카르텔이 존재한다고 생각한다.") size(small)) ///
name(gr1, replace) 


*Q49

replace q49 = 0 if q49==2
local x ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig i.sex#i.agegroup
logit q49 `x', robust 

****교차항 포함(sex & agegroup)
replace q49 = 0 if q49==2
local x i.sex##i.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig i.sex#i.agegroup
logit q49 `x', robust 


local z: variable label q49
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "중소기업은 대기업에 비해 열악한 위치에 있으므로 정부가 도와야 한다.") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q50
replace q50 = 0 if q50==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig


local z: variable label q50
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "AI, 바이오 등 특정 산업을 국가적으로 지원하는 산업정책이 필요하다.") size(small)) ///
name(gr1, replace) 


*Q51
replace q51 = 0 if q51==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q51 `x', robust 

local z: variable label q51
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "플랫폼 기술은 소비자들에게 더 많은 선택권과 편리함을 준다.") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



** Q52
*지역가게이용을 줄일 것이다
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q52 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(1)) post

local z: variable label q52
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "지역 가게 이용을 줄일 가능성이 높다") size(small)) ///
name(gr1, replace) 

*비슷할 것이다
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q52 `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(2)) post


local z: variable label q52
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "지역가게 이용이 비슷할 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace





*Q53
replace q53 = 0 if q53==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q53 `x', robust 

local z: variable label q53
coefplot, drop(_cons) headings(0.sex="" 1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "사람의 일을 대체하여 일자리를 줄이는 효과가 더 클 것이다.") size(small)) ///
name(gr1, replace) 


*Q54
replace q54 = 0 if q54==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q54 `x', robust 

local z: variable label q54
coefplot, drop(_cons) headings(0.sex="" 1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "수입물가를 낮추고 수출산업을 성장시키는 긍정적 효과가 크다고 생각") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q55
replace q55 = 0 if q55==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q55 `x', robust 

local z: variable label q55
coefplot, drop(_cons) headings(0.sex="" 1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "생성형 AI를 빈번히 활용할 가능성이 높다") size(small)) ///
name(gr1, replace) 


*Q56
replace q56 = 0 if q56==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.region 
ologit q56 `x', robust 

local z: variable label q56
coefplot, drop(_cons) headings(0.sex="" 1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "중소기업 적합업종이 효과가 있다고 생각할 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q57
replace q57 = 0 if q57==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.region
ologit q57 `x', robust 

local z: variable label q57
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "대형마트 영업시간제한이 효과가 있다고 생각할 가능성이 높다") size(small)) ///
name(gr1, replace) 



*Q58
replace q58 = 0 if q58==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q58 `x', robust 

replace q58 = 0 if q58==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q58 age, robust 

local z: variable label q58
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "임대료 지원 등이 효과가 있다고 생각할 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace

}

{********************************************************************************* Section 7 환경 및 에너지
*Q59
replace q59 = 0 if q59==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q59 `x', robust 

local z: variable label q59
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "재생에너지보다 원자력 발전을 더 확대해야 한다.") size(small)) ///
name(gr1, replace) 



*Q60
replace q60 = 0 if q60==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q60 `x', robust 

local z: variable label q60
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "탄소세 도입은 탄소감축으로 인한 사회적 편익이 더 클 것") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q61
replace q61 = 0 if q61==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q61 `x', robust 

local z: variable label q61
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "우리나라 산업에 피해가 가더라도 국제적 협약을 준수해야 한다.") size(small)) ///
name(gr1, replace) 



*Q62
replace q62 = 0 if q62==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q62 `x', robust 

local z: variable label q62
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "기존 화석연료의 효율개선보다 클린에너지 육성이 더 우선") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q63
replace q63 = 0 if q63==2
local x age i.sex ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset
logit q63 `x', robust 

local z: variable label q63
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "소상공인의 부담을 증가시키므로 폐기 또는 완화되어야 한다.") size(small)) ///
name(gr1, replace) 

graph combine gr1 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace



** Q64
*인구가 적은지방
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q64 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(2)) post


local z: variable label q64
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "인구가 적은 지방에 설치하는 것이 효율적이다.") size(small)) ///
name(gr1, replace) 


*해외이전
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q64 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(3)) post


local z: variable label q64
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "가능하다면 해외로 이전해야 한다.")  size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


}

{********************************************************************************* Section 8. 복지 및 문화

*Q65
replace q65 = 0 if q65==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q65 `x', robust 

local z: variable label q65
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "진료시간 증가 등 의료서비스 개선을 위해서는 증가가 필요하다.") size(small)) ///
name(gr1, replace) 



*Q66
replace q66 = 0 if q66==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q66 `x', robust 

local z: variable label q66
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "중증질환 건강보험 보장성을 높이고 경증질환 건강보험 지원을 줄여야") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q67
replace q67 = 0 if q67==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q67 `x', robust 

local z: variable label q67
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "의대정원확대는 의료비 절감으로 이어질 것이므로 필요하다.") size(small)) ///
name(gr1, replace) 



*Q68
replace q68 = 0 if q68==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q68 `x', robust 

local z: variable label q68
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "원격진료는 휴일 및 주말 진료와 소외지역을 위해 적극적으로 도입되어야 한다.") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q69
replace q69 = 0 if q69==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q69 `x', robust 

local z: variable label q69
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "공공의료 강화는 지역간 의료 격차 해소를 위해 필요하다.") size(small)) ///
name(gr1, replace) 



*Q70
replace q70 = 0 if q70==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q70 `x', robust 

local z: variable label q70
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "국민연금은 보장성을 제한하더라도 재정안정성을 확보하는 것이 우선") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q71
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q71 `x', robust 

local z: variable label q71
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q8-7, 감염병이 다시 온다면 다음 정책이 얼마나 효과적? 추적-격리-치료 정책", size(vsmall)) legend(order(2 "추적-격리-치료 정책이 효과적일 가능성이 높다") size(small)) ///
name(gr1, replace) 



*Q72
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q72 `x', robust 

local z: variable label q72
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q8-7, 감염병이 다시 온다면 다음 정책이 얼마나 효과적? 사회적 거리두기", size(vsmall)) legend(order(2 "사회적 거리두기가 효과적일 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q73
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q73 `x', robust 

local z: variable label q73
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q8-7, 감염병이 다시 온다면 다음 정책이 얼마나 효과적? 백신접종", size(vsmall)) legend(order(2 "백신접종이 효과적일 가능성이 높다") size(small)) ///
name(gr1, replace) 


*Q74
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q74 `x', robust 

local z: variable label q74
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "현금복지정책은 확대되어야 한다고 생각할 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q75
replace q75 = 0 if q75==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q75 `x', robust 

local z: variable label q75
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "현금보다 문화생활에 쓸 수 있는 바우처를 지원하는 것이 필요") size(small)) ///
name(gr1, replace) 


graph combine gr1 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace

}

{********************************************************************************* Section 9. Population 
*Q76
*기혼
local x i.sex ib3.agegroup ib3.educ i.job i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q76 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(2)) post

local z: variable label q76
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.metro="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "기혼일 가능성이 높다") size(small)) ///
name(gr1, replace) 

*이혼
local x i.sex ib3.agegroup ib3.educ i.job i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q76 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(3)) post

local z: variable label q76
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.metro="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "이혼했을 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*사별
local x i.sex ib3.agegroup ib3.educ i.job i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q76 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(4)) post

local z: variable label q76
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.metro="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "사별했을 가능성이 높다") size(small)) ///
name(gr1, replace) 


graph combine gr1, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q77
local x i.sex ib3.agegroup ib3.educ i.job i.metro i.housing ib2.inc ib2.asset i.relig
ologit q77 `x', robust 

local z: variable label q77
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.metro="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "결혼을 최근 또는 늦게 했을 가능성이 높다") size(small)) ///
name(gr1, replace) 


graph combine gr1, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q78
local x i.sex ib3.agegroup ib3.educ i.job i.metro i.housing ib2.inc ib2.asset i.relig
ologit q78 `x', robust 

local z: variable label q78
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.metro="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "자녀가 있을 가능성이 높다") size(small)) ///
name(gr1, replace) 

*Q79
local x i.sex ib3.agegroup ib3.educ i.job i.metro i.housing ib2.inc ib2.asset i.relig
ologit q79 `x', robust 

local z: variable label q79
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.metro="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "결혼 전 연애횟수가 많았을 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q80
local x i.sex ib3.agegroup ib3.educ i.job i.metro i.housing ib2.inc ib2.asset i.relig
ologit q80 `x', robust 

local z: variable label q80
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.metro="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "연애횟수가 많았을 가능성이 높다") size(small)) ///
name(gr1, replace) 

graph combine gr1 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q81
replace q81 = 0 if q81==2
local x i.sex ib3.agegroup ib3.educ i.job i.metro i.housing ib2.inc ib2.asset i.relig
logit q81 `x', robust 

local z: variable label q81
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.metro="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "예") size(small)) ///
name(gr1, replace) 


*Q82
replace q82 = 0 if q82==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q82 `x', robust 

local z: variable label q82
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "예") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q83
replace q83 = 0 if q83==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q83 `x', robust 

local z: variable label q83
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "저출산 개선을 위해 결혼하고 출산을 결정하기까지의 과정을 도와야") size(small)) ///
name(gr1, replace) 


*Q84
replace q84 = 0 if q84==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q84 `x', robust 

local z: variable label q84
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "저출산해결을 위해 비혼가구보다 기혼 유자녀 가정 혜택을 강화해야") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q85
replace q85 = 0 if q85==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q85 `x', robust 

local z: variable label q85
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "예") size(small)) ///
name(gr1, replace) 


*Q86
replace q86 = 0 if q86==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q86 `x', robust 

local z: variable label q86
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "예") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q87
replace q87 = 0 if q87==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q87 `x', robust 

local z: variable label q87
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "이민확대정책은 저출산에 따른 인구절벽을 막기 위해 필요하다") size(small)) ///
name(gr1, replace) 


*Q88
replace q88 = 0 if q88==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
logit q88 `x', robust 

local z: variable label q88
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "남성육아휴직확대는 출산률을 개선하는 긍정적인 효과가 클 것") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q89
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q89 `x', robust 

local z: variable label q89
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "청년의 연애와 결혼에 긍정적인 영향을 미칠 가능성이 높다") size(small)) ///
name(gr1, replace) 

graph combine gr1 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace


}

{********************************************************************************* Section 10. 외교안보
*Q90
replace q90 = 0 if q90==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region  ib2.inc ib2.asset i.relig
logit q90 `x', robust 

local z: variable label q90
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}"  1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "두 국가로 평화 공존하는 것이 바람직하다.") size(small)) ///
name(gr1, replace) 


*Q91
replace q91 = 0 if q91==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region  ib2.inc ib2.asset i.relig
logit q91 `x', robust 

local z: variable label q91
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "한-미-일 간 군사협력이 강화되어야 한다.") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q92
replace q92 = 0 if q92==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region  ib2.inc ib2.asset i.relig
logit q92 `x', robust 

local z: variable label q92
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "우리나라도 보다 적극적으로 입장을 표시하고 대응해야 한다.") size(small)) ///
name(gr1, replace) 


*Q93
replace q93 = 0 if q93==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region  ib2.inc ib2.asset i.relig
logit q93 `x', robust 

local z: variable label q93
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "중국이 아닌 동맹국인 미국과의 더 강한 결합을 추구해야 한다.") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q94
replace q94 = 0 if q94==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region  ib2.inc ib2.asset i.relig
logit q94 `x', robust 

local z: variable label q94
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "국제사회 위상에 맞도록 더 증가되어야 한다") size(small)) ///
name(gr1, replace) 


*Q95
replace q95 = 0 if q95==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region  ib2.inc ib2.asset i.relig
ologit q95 `x', robust 

local z: variable label q95
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "인도적 지원을 위해 고르게 배분해야 한다.") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q96
replace q96 = 0 if q96==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region  ib2.inc ib2.asset i.relig
ologit q96 `x', robust 

local z: variable label q96
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "모병제에 동의할 가능성이 높다") size(small)) ///
name(gr1, replace) 


*Q97
replace q97 = 0 if q97==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region  ib2.inc ib2.asset i.relig
ologit q97 `x', robust 

local z: variable label q97
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "남/여 징병제에 동의할 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace

}

{********************************************************************************* Section 11. 정치
*Q98
replace q98 = 0 if q98==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
ologit q98 `x', robust 

local z: variable label q98
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}"  1.inc="{bf:소득}"  1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "보수라고 생각할 가능성이 높다'") size(small)) ///
name(gr1, replace) 

graph combine gr1, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace


** Q99
*문재인
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q99 `x', baseoutcome(6) robust 
margins, dydx(*) predict(outcome(1)) post

local z: variable label q99
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "문재인을 투표했을 가능성이 높다") size(small)) ///
name(gr1, replace) 


*홍준표
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q99 `x', baseoutcome(6) robust 
margins, dydx(*) predict(outcome(2)) post

local z: variable label q99
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "홍준표를 투표했을 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*안철수
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q99 `x', baseoutcome(6) robust 
margins, dydx(*) predict(outcome(3)) post

local z: variable label q99
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "안철수를 투표했을 가능성이 높다") size(small)) ///
name(gr1, replace) 

graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*유승민
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q99 `x', baseoutcome(6) robust 
margins, dydx(*) predict(outcome(4)) post

local z: variable label q99
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "유승민을 투표했을 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*심상정
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q99 `x', baseoutcome(6) robust 
margins, dydx(*) predict(outcome(5)) post

local z: variable label q99
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "심상정을 투표했을 가능성이 높다") size(small)) ///
name(gr1, replace) 

graph combine gr1, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace




** Q100
*윤석열
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q100 `x', baseoutcome(4) robust 
margins, dydx(*) predict(outcome(1)) post

local z: variable label q100
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "윤석열을 투표했을 가능성이 높다") size(small)) ///
name(gr1, replace) 


*이재명
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q100 `x', baseoutcome(4) robust 
margins, dydx(*) predict(outcome(2)) post

local z: variable label q100
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "이재명을 투표했을 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*심상정
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q100 `x', baseoutcome(4) robust 
margins, dydx(*) predict(outcome(3)) post

local z: variable label q100
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "심상정을 투표했을 가능성이 높다") size(small)) ///
name(gr1, replace) 

graph combine gr1 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace



** Q101
*민주당
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q101 `x', baseoutcome(5) robust 
margins, dydx(*) predict(outcome(1)) post

local z: variable label q101
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "민주당에 투표할 가능성이 높다") size(small)) ///
name(gr1, replace) 

*국민의힘
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q101 `x', baseoutcome(5) robust 
margins, dydx(*) predict(outcome(2)) post

local z: variable label q101
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "국민의힘에 투표할 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*개혁신당
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q101 `x', baseoutcome(5) robust 
margins, dydx(*) predict(outcome(3)) post

local z: variable label q101
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "개혁신당에 투표할 가능성이 높다") size(small)) ///
name(gr1, replace) 

*녹색정의당
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q101 `x', baseoutcome(5) robust 
margins, dydx(*) predict(outcome(4)) post

local z: variable label q101
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "녹색정의당에 투표할 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



** Q102
*복지
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q102 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(2)) post

local z: variable label q102
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "복지 및 빈곤 축소가 큰 과제라고 생각할 가능성이 높다") size(small)) ///
name(gr1, replace) 

*외교
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q102 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(3)) post

local z: variable label q102
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "외교 및 안보가 큰 과제라고 생각할 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*사회통합
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.housing i.region ib2.inc ib2.asset i.relig
mlogit q102 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(4)) post

local z: variable label q102
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 2.region="{bf:지역}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "사회통합이 큰 과제라고 생각할 가능성이 높다") size(small)) ///
name(gr1, replace) 


graph combine gr1 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q103
replace q103 = 0 if q103==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q103 `x', robust 

local z: variable label q103
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "예") size(small)) ///
name(gr1, replace) 



*Q104
replace q104 = 0 if q104==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q104 `x', robust 

local z: variable label q104
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "예") size(small)) ///
name(gr2, replace) 



graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*Q105
replace q105 = 0 if q105==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q105 `x', robust 

local z: variable label q105
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "예") size(small)) ///
name(gr1, replace) 



*Q106
replace q106 = 0 if q106==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q106 `x', robust 

local z: variable label q106
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "합의보다 강력한 리더십에 의한 정책 집행에 의해 개선되어야") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q107
replace q107 = 0 if q107==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q107 `x', robust 

local z: variable label q107
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "비례대표 확대에 찬성한다") size(small)) ///
name(gr1, replace) 



*Q108
replace q108 = 0 if q108==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q108 `x', robust 

local z: variable label q108
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "소수정당의 진입장벽을 낮추는 것에 찬성한다") size(small)) ///
name(gr2, replace) 



graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q109
replace q109 = 0 if q109==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q109 `x', robust 

local z: variable label q109
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "대통령 권한 분산에 찬성한다") size(small)) ///
name(gr1, replace) 



*Q110
replace q110 = 0 if q110==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q110 `x', robust 

local z: variable label q110
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "국회의원은 상향식 공천으로 선출되어야 한다") size(small)) ///
name(gr2, replace) 



graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace




*Q111
replace q111 = 0 if q111==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q111 `x', robust 

local z: variable label q111
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "지방자치는 더 강화되어야 한다") size(small)) ///
name(gr1, replace) 


*Q112
replace q112 = 0 if q112==2
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.region i.housing ib2.inc ib2.asset i.relig
logit q112 `x', robust 

local z: variable label q112
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "국회의원의 연봉을 더 낮춰야한다") size(small)) ///
name(gr2, replace) 



graph combine gr1 gr2, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace

}

{********************************************************************************* Section 12. 기타
*Q113
*전세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro ib2.inc ib2.asset i.relig
mlogit q113 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(2)) post


local z: variable label q113
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "자가보다 전세일 가능성이 높다") size(small)) ///
name(gr1, replace) 

*월세
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro ib2.inc ib2.asset i.relig
mlogit q113 `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(3)) post


local z: variable label q113
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "자가보다 월세일 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q114
*IT 제조업
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q114 `x', baseoutcome(8) robust 
margins, dydx(*) predict(outcome(1)) post


local z: variable label q114
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "IT 제조업에 종사할 가능성이 높다") size(small)) ///
name(gr1, replace) 


*기타 제조업
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q114 `x', baseoutcome(8) robust 
margins, dydx(*) predict(outcome(2)) post


local z: variable label q114
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "기타 제조업에 종사할 가능성이 높다") size(small)) ///
name(gr2, replace) 



graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*IT 서비스업
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q114 `x', baseoutcome(8) robust 
margins, dydx(*) predict(outcome(3)) post


local z: variable label q114
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "IT 서비스업에 종사할 가능성이 높다") size(small)) ///
name(gr1, replace) 


*전문서비스업
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q114 `x', baseoutcome(8) robust 
margins, dydx(*) predict(outcome(4)) post


local z: variable label q114
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "교육, 의료 등 전문서비스에 종사할 가능성이 높다") size(small)) ///
name(gr2, replace) 



graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace




*이외의 서비스업
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q114 `x', baseoutcome(8) robust 
margins, dydx(*) predict(outcome(5)) post


local z: variable label q114
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "이외의 서비스업에 종사할 가능성이 높다") size(small)) ///
name(gr1, replace) 


*전문서비스업
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q114 `x', baseoutcome(8) robust 
margins, dydx(*) predict(outcome(6)) post


local z: variable label q114
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "공무원/공공기관에 종사할 가능성이 높다") size(small)) ///
name(gr2, replace) 



graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*농림수산업 등 기타산업
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit q114 `x', baseoutcome(8) robust 
margins, dydx(*) predict(outcome(7)) post


local z: variable label q114
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "농림수산업 등에 종사할 가능성이 높다") size(small)) ///
name(gr1, replace) 


graph combine gr1, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace



*115
*사무직
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit job `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(2)) post


local z: variable label q115
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "사무직에 종사할 가능성이 높다") size(small)) ///
name(gr1, replace) 

*생산직
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit job `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(3)) post


local z: variable label q115
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "생산직에 종사할 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*개발자
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit job `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(4)) post


local z: variable label q115
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "개발자에 종사할 가능성이 높다") size(small)) ///
name(gr1, replace) 

*전문직
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit job `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(5)) post


local z: variable label q115
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "전문직에 종사할 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*q116
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q116 `x', robust

local z: variable label q116
coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("`z'", size(vsmall)) legend(order(2 "SNS를 빈번히할 가능성이 높다") size(small)) ///
name(gr1, replace) 

graph combine gr1, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace




** 117
*개신교
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset
mlogit relig `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(2)) post


coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:}" ) ///
xline(0, lcolor(red)) title("Q12-8. 귀하의 종교는 무엇입니까?", size(vsmall)) legend(order(2 "개신교일 가능성이 높다") size(small)) ///
name(gr1, replace) 

*천주교
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset
mlogit relig `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(3)) post


coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:}" ) ///
xline(0, lcolor(red)) title("Q12-8. 귀하의 종교는 무엇입니까?", size(vsmall)) legend(order(2 "천주교일 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace



*불교
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset
mlogit relig `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(4)) post


coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:}" ) ///
xline(0, lcolor(red)) title("Q12-8. 귀하의 종교는 무엇입니까?", size(vsmall)) legend(order(2 "불교일 가능성이 높다") size(small)) ///
name(gr1, replace) 

*기타
local x i.sex ib3.agegroup ib3.educ i.mar i.metro i.housing ib2.inc ib2.asset
mlogit relig `x', baseoutcome(1) robust 
margins, dydx(*) predict(outcome(5)) post


coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:}" ) ///
xline(0, lcolor(red)) title("Q12-8. 귀하의 종교는 무엇입니까?", size(vsmall)) legend(order(2 "기타 종교일 가능성이 높다") size(small)) ///
name(gr2, replace) 

graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


** Q118
*고졸이하
local x i.sex ib3.agegroup  i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit educ `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(1)) post


coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q12-9. 다음 항목 중 귀하의 최종학력에 해당하는 것을 고르십시오.", size(vsmall)) legend(order(2 "고졸 이하일 가능성이 높다") size(small)) ///
name(gr1, replace) 


*전문대졸
local x i.sex ib3.agegroup  i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
mlogit educ `x', baseoutcome(3) robust 
margins, dydx(*) predict(outcome(2)) post

coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q12-9. 다음 항목 중 귀하의 최종학력에 해당하는 것을 고르십시오.", size(vsmall)) legend(order(2 "전문대졸일 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace




*Q119
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc ib2.asset i.relig
ologit q119 `x', robust

coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q12-10. 현재 함께 살고 계시는 가족 모두의 한 달 평균 총수입은 얼마 정도입니까?", size(vsmall)) legend(order(2 "가족 한달 평균 총수입이 많을 가능성이 높다") size(small)) ///
name(gr1, replace) 


*Q120
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.asset i.relig
ologit inc `x', robust

coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q12-11. 귀하 혼자만의 한 달 평균 총수입은 얼마 정도입니까?", size(vsmall)) legend(order(2 "개인 한달 평균 총수입이 많을 가능성이 높다") size(small)) ///
name(gr2, replace) 


graph combine gr1 gr2 , rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.8) 

graph export x.png, as(png) width(4400) height(3000) replace


*Q121
local x i.sex ib3.agegroup ib3.educ i.job i.mar i.metro i.housing ib2.inc i.relig
ologit asset `x', robust

coefplot, drop(_cons) headings(1.agegroup="{bf:}" 1.educ="{bf:}" ///
2.job="{bf:}" 1.mar="{bf:}" 1.inc="{bf:소득}" 1.asset="{bf:자산규모}" 2.relig="{bf:종교}" ) ///
xline(0, lcolor(red)) title("Q12-12. 다음 항목 중 부채를 포함한 귀하의 보유자산 규모와 가장 가까운 항목은 무엇입니까?", size(vsmall)) legend(order(2 "보유자산이 많을 가능성이 높다") size(small)) ///
name(gr1, replace) 


graph combine gr1, rows(1)   ///
altshrink imargin(10 10)  ///
iscale(0.7) 

graph export x.png, as(png) width(4400) height(3000) replace


}

